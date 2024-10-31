#lang racket
(require 2htdp/image)

#|
    VARIANT VALUES: These are values that are characteristic of single instance of a HumdrumTree.
        1. text string. Can very between each node in the tree.
        2. circle radius. Invariant between nodes, but depends on the longest string in the HumdrumTree.
        3. line y for left and right branches of parents. This will depend on the sum of the width of the padding added
            between a left and right node, and the width of the node (See 2). Once this width is known, the
            line y should not extend to the farthest corners, but to the top of each node, so line y will be
            (+ (/ (image-width parent-padding) 2) (/ (image-width circle 2)) for the right line and the same times -1 for the left line.
        4. width of the entire tree. (+ (* (image-width branch-padding) (- (length spines) 1))
                                        (foldr + 0 (map image-width (list root-branch-images))))
        5. line y for branches below root. This will depend on the width of the entire tree (See 4) below the root.
        6. Size of branch-padding depends on depth of tree. (image-height (first loi)). Naive layered.
|#
(define text-ex (text "4aa" 12 "black"))
(define circle-ex (circle (image-width text-ex)
                          "outline"
                          "black"))
(define node-ex (overlay text-ex circle-ex))

(define straight-line (line 0 30 "black"))
(define left-branch   (line -10 30 "black"))
(define right-branch  (line 10 30 "black"))

;(above node-ex straight-line)
;(above node-ex (beside left-branch right-branch))

(define top-node (circle 5 "outline" "black"))
(define top-node-width (image-width top-node))
(define top-node-height (image-height top-node))

(struct tree (root) #:transparent)
(struct result (images widths) #:transparent)
; Tree is (tree (listof (listof Natural)))

(define tree-ex (tree (list (list "1" "2" "3")
                            (list "1" "12" "3")
                            (list "111" "2" "3"))))

; visualize-tree
; Tree -> Image
; produces an image of the tree

(define (visualize-tree tree)
  (local [(define branch-images (list-branch-images tree))

          (define x-positions (branch-x-positions branch-images))

          (define lower-tree-image (pad-bottom-of-tree (result-images branch-images)))]
    (add-branch-lines lower-tree-image x-positions)))

; list-branch-images
; Tree -> Result
; produces an image of the tree
; CONSTRAINT: No branch splits

(define (list-branch-images tree)
  (local [(define (get-diameter tree)
            (local [(define (fn-for-root root longest)
                      (cond [(empty? root) (image-width (text longest 12 "black"))]
                            [else
                             (local [(define result (fn-for-branch (first root)))]
                               (if (> (string-length result) (string-length longest))
                                   (fn-for-root (rest root) result)
                                   (fn-for-root (rest root) longest)))]))

                    (define (fn-for-branch branch)
                      (local [(define (fn-for-branch branch longest)
                                (cond [(empty? branch) longest]
                                      [else
                                       (if (> (string-length (first branch)) (string-length longest))
                                           (fn-for-branch (rest branch) (first branch))
                                           (fn-for-branch (rest branch) longest))]))]
                        (fn-for-branch branch "")))]
              (fn-for-root (tree-root tree) "")))

          (define node-img (circle (get-diameter tree) "outline" "black"))
          
          ; (listof (listof Natural)) -> (listof Image)
          (define (fn-for-root root)
            (cond [(empty? root) empty]
                  [else
                   (cons (fn-for-branch (first root))
                         (fn-for-root (rest root)))]))

          ; (listof Natural) -> Image
          (define (fn-for-branch branch)
            (cond [(empty? (rest branch)) (fn-for-natural (first branch))]
                  [else
                   (above (fn-for-natural (first branch))
                          straight-line
                          (fn-for-branch (rest branch)))]))

          ; Natural -> Image
          (define (fn-for-natural natural)
            (overlay (text natural 12 "black")
                     node-img))]
    (local [(define rnr (fn-for-root (tree-root tree)))]
      (result rnr (map image-width rnr)))))

; pad
; Natural -> Image
; produces a white rectangle to pad space between branches

; assumes naive layered
(define (pad height)
  (rectangle 50 height "outline" "white"))

; pad-bottom-of-tree
; (listof Image) -> Image
; produces a concatenation of result-images, separated by padding rectangle

(define (pad-bottom-of-tree loi)
  (local [(define padding (pad (image-height (first loi))))
          
          (define (pad-bottom-of-tree loi)
            (cond [(empty? (rest loi)) (first loi)]
                  [else
                   ; if not naive layered: beside/align "top"
                   (beside (first loi)
                           padding
                           (pad-bottom-of-tree (rest loi)))]))]
    (pad-bottom-of-tree loi)))

; branch-x-positions
; Result -> (listof Natural)
; produces the list of x positions where lines from top node will connect with top of branch

(define (branch-x-positions result)
  (local [; width of each branch
          (define branch-widths (result-widths result))

          ; width of padding rectangle
          (define pad-width (image-width (pad (image-height (first (result-images result))))))

          ; width of bottom image
          (define tree-width (image-width (pad-bottom-of-tree (result-images result))))

          (define (x-positions branch-widths)
            ; prev-x. Natural. The x position of the previous line.
            ; prev-midpoint. Natural. The midpoint of the previous branch.
            (local [(define (x-positions branch-widths prev-x prev-midpoint acc)
                      (cond [(empty? (rest branch-widths)) (reverse (cons (- tree-width (/ (first branch-widths) 2)) acc))]
                            [else
                             (x-positions (rest branch-widths)
                                          (+ prev-x prev-midpoint pad-width (/ (first branch-widths) 2))
                                          (/ (first branch-widths) 2)
                                          (cons (+ prev-x prev-midpoint pad-width (/ (first branch-widths) 2)) acc))]))]
              (if (= 1 (length branch-widths))
                  (list (/ (first branch-widths) 2))
                  (x-positions (rest branch-widths)
                               (/ (first branch-widths) 2)
                               (/ (first branch-widths) 2)
                               (list (/ (first branch-widths) 2))))))]
    (x-positions branch-widths)))

; add-branch-lines
; Image (listof Natural) -> Image
; produces the final image of the tree

(define (add-branch-lines tree-image x-positions)
  (local [(define half-tree-width (/ (image-width tree-image) 2))

          (define (add-branch-lines x-positions)
            (cond [(empty? (rest x-positions)) (add-line tree-image (first x-positions) 0 half-tree-width -30 "black")]
                  [else
                   (add-line (add-branch-lines (rest x-positions))
                             (first x-positions)
                             30
                             half-tree-width
                             0
                             "black")]))]
    (above/align "center"
                 top-node
                 (add-branch-lines x-positions))))