#lang racket

(require 2htdp/image)

(provide (all-defined-out))

(define straight-line (line 0 30 "black"))
(define left-branch   (line -10 30 "black"))
(define right-branch  (line 10 30 "black"))
(define top-node (circle 5 "outline" "black"))

(struct tree (root) #:transparent)
(struct parent (string left right) #:transparent)
(define tree-ex (tree (list (list "1" "2" "3")
                            (list "1" "12" "3")
                            (list "111" "2" "3"))))
(define split-tree-ex (tree (list (list "1" "2" "3")
                                  (list (parent "1" (list "1234" "3") (list "3" "12")))
                                  (list "111" "2" "3"))))
(define nested-parent-ex (tree (list (list "1" "2" "3" "4" "5")
                                     (list (parent "1"
                                                   (list "12" (parent "3"
                                                                        (list "1" "5")
                                                                        (list "6" "3")))
                                                   (list "3" "12" "14" "60")))
                                     (list "111" "1234" "3" "44" "55"))))

(struct result (images widths) #:transparent)

(define parent-ex (parent "1" (list "1234" "3") (list "3" "12")))
(define subtree (tree (list (parent-left parent-ex) (parent-right parent-ex))))

; visualize-tree
; Tree -> Image
; produces an image of the tree

(define (visualize-tree tree)
  (local [(define node-img (circle (get-diameter tree) "outline" "black"))

          (define branch-images (list-branch-images tree node-img))

          (define x-positions (branch-x-positions branch-images))

          (define lower-tree-image (pad-bottom-of-tree (result-images branch-images)))]
    (add-branch-lines lower-tree-image x-positions)))

; list-branch-images
; Tree -> Result
; produces an image of the tree

(define (list-branch-images tree node-img)
  (local [; (listof (listof Natural)) -> (listof Image)
          (define (fn-for-root root)
            (cond [(empty? root) empty]
                  [else
                   (cons (fn-for-branch (first root))
                         (fn-for-root (rest root)))]))

          ; (listof Natural) -> Image
          (define (fn-for-branch branch)
            (cond [(and (empty? (rest branch))
                        (not (parent? (first branch)))) (node-image (first branch) node-img)]
                  [(empty? (rest branch)) (list-subbranch-images (first branch) node-img)]
                  [(parent? (first branch)) (above (list-subbranch-images (first branch) node-img)
                                                   straight-line
                                                   (fn-for-branch (rest branch)))]
                  [else
                   (above (node-image (first branch) node-img)
                          straight-line
                          (fn-for-branch (rest branch)))]))

          (define rnr (fn-for-root (tree-root tree)))]
    (result rnr (map image-width rnr))))

; list-subbranch-images
; Parent -> Image
; handles parent images

(define (list-subbranch-images parent node-img)
  (local [(define subtree (tree (list (parent-left parent) (parent-right parent))))

          (define (visualize-subtree subtree)
            (local [(define branch-images (list-branch-images subtree node-img))

                    (define x-positions (branch-x-positions branch-images))

                    (define lower-tree-image (pad-bottom-of-tree (result-images branch-images)))]
              (add-subbranch-lines lower-tree-image x-positions)))

          (define (add-subbranch-lines lower-tree-image x-positions)
            (local [(define half-tree-width (/ (image-width lower-tree-image) 2))

                    (define (add-subbranch-lines x-positions)
                      (cond [(empty? (rest x-positions)) (add-line lower-tree-image (first x-positions) 0 half-tree-width -30 "black")]
                            [else
                             (add-line (add-subbranch-lines (rest x-positions))
                                       (first x-positions)
                                       30
                                       half-tree-width
                                       0
                                       "black")]))]
              (above/align "center"
                           (node-image (parent-string parent) node-img)
                           (add-subbranch-lines x-positions))))]
    (visualize-subtree subtree)))

; node-image
; Natural -> Image
; produces an image of a node

(define (node-image natural node-img)
  (overlay (text natural 12 "black")
           node-img))

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

; get-diameter
; Tree -> Natural
; produces the width of the widest text image in the tree

(define (get-diameter tree)
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
                            [(parent? (first branch)) (local [(define parent-longest (fn-for-parent (first branch)))]
                                                        (if (> (string-length parent-longest) (string-length longest))
                                                            (fn-for-branch (rest branch) parent-longest)
                                                            (fn-for-branch (rest branch) longest)))]
                            [else
                             (if (> (string-length (first branch)) (string-length longest))
                                 (fn-for-branch (rest branch) (first branch))
                                 (fn-for-branch (rest branch) longest))]))]
              (fn-for-branch branch "")))

          (define (fn-for-parent parent)
            (local [(define left-longest (fn-for-branch (parent-left parent)))

                    (define right-longest (fn-for-branch (parent-right parent)))]
              (if (and (> (string-length (parent-string parent))
                          (string-length left-longest))
                       (> (string-length (parent-string parent))
                          (string-length right-longest)))
                  (parent-string parent)
                  (if (> (string-length left-longest) (string-length right-longest))
                      left-longest
                      right-longest))))]
    (fn-for-root (tree-root tree) "")))
