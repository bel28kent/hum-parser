#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hum-parser: data structures: HumdrumTree
;;    visualize-htree: produces an image of a HumdrumTree
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require "../../../parser/data-definitions/data-definitions.rkt"
         "../data-definitions/data-definitions.rkt"
         2htdp/image)

(provide visualize-htree)

(define straight-line (line 0 30 "black"))
(define top-node (circle 5 "outline" "black"))

(struct result (images widths) #:transparent)

; visualize-htree
; HumdrumTree -> Image
; produces an image of the tree

(define (visualize-htree htree)
  (local [(define node-img (circle (get-diameter htree) "outline" "black"))

          (define branch-images (list-branch-images htree node-img))

          (define x-positions (branch-x-positions branch-images))

          (define lower-tree-image (pad-bottom-of-tree
                                     (result-images branch-images)))]
    (add-branch-lines lower-tree-image x-positions)))

; list-branch-images
; HumdrumTree -> Result
; produces a list of images of each branch

(define (list-branch-images htree node-img)
  (local [; (listof (listof Natural)) -> (listof Image)
          (define (fn-for-root root)
            (cond [(empty? root) empty]
                  [else
                   (cons (fn-for-branch (first root))
                         (fn-for-root (rest root)))]))

          ; (listof Natural) -> Image
          (define (fn-for-branch branch)
            (cond [(and (empty? (rest branch))
                        (not (parent? (first branch)))) (node-image
                                                          (token-token
                                                            (leaf-token
                                                              (first branch)))
                                                          node-img)]
                  ; can a parent be the last case in a branch?
                  ; Subspines should always be merged before spine terminator.
                  [(empty? (rest branch)) (list-subbranch-images
                                            (first branch)
                                            node-img)]
                  [(parent? (first branch))
                   (above/align "left"
                                (list-subbranch-images
                                  (first branch)
                                  node-img)
                                (above straight-line
                                       (fn-for-branch
                                         (rest branch))))]
                  [else
                   (above (node-image
                            (token-token (leaf-token (first branch)))
                            node-img)
                          straight-line
                          (fn-for-branch (rest branch)))]))

          (define rnr (fn-for-root (root-branches (htree-root htree))))]
    (result rnr (map image-width rnr))))

; list-subbranch-images
; Parent -> Image
; handles parent images

(define (list-subbranch-images parent node-img)
          ; needs to be HumdrumTree
  (local [(define subtree (htree
                            (root (list (parent-left parent)
                                        (parent-right parent)))))

          (define (visualize-subtree subtree)
            (local [(define branch-images (list-branch-images
                                            subtree node-img))

                    (define x-positions (branch-x-positions branch-images))

                    (define lower-tree-image (pad-bottom-of-tree
                                               (result-images branch-images)))]
              (add-subbranch-lines lower-tree-image x-positions)))

          (define (add-subbranch-lines lower-tree-image x-positions)
            (local [(define half-tree-width (/ (image-width lower-tree-image)
                                               2))

                    (define (add-subbranch-lines x-positions)
                      (cond [(empty? (rest x-positions))
                             (add-line lower-tree-image
                                       (first x-positions)
                                       0
                                       half-tree-width
                                       -30
                                       "black")]
                            [else
                             (add-line (add-subbranch-lines (rest x-positions))
                                       (first x-positions)
                                       30
                                       half-tree-width
                                       0
                                       "black")]))]
              (above/align "center"
                           (node-image (token-token (parent-token parent))
                                       node-img)
                           (add-subbranch-lines x-positions))))]
    (visualize-subtree subtree)))

; node-image
; String -> Image
; produces an image of a node

(define (node-image token-str node-img)
  (overlay (text token-str 12 "black")
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
; produces list of x positions where top node lines will meet top of branches

(define (branch-x-positions result)
  (local [; width of each branch
          (define branch-widths (result-widths result))

          ; width of padding rectangle
          (define pad-width (image-width
                              (pad
                                (image-height
                                  (first (result-images result))))))

          ; width of bottom image
          (define tree-width (image-width
                               (pad-bottom-of-tree (result-images result))))

          (define (x-positions branch-widths)
            ; prev-x. Natural. The x position of the previous line.
            ; prev-midpoint. Natural. The midpoint of the previous branch.
            (local [(define (x-positions branch-widths prev-x prev-midpoint acc)
                      (cond [(empty? (rest branch-widths))
                             (reverse
                               (cons (- tree-width
                                        (/ (first branch-widths) 2))
                                     acc))]
                            [else
                             (x-positions (rest branch-widths)
                                          (+ prev-x
                                             prev-midpoint
                                             pad-width
                                             (/ (first branch-widths) 2))
                                          (/ (first branch-widths) 2)
                                          (cons (+ prev-x
                                                   prev-midpoint
                                                   pad-width
                                                   (/ (first branch-widths) 2))
                                                acc))]))]
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
            (cond [(empty? (rest x-positions)) (add-line tree-image
                                                         (first x-positions)
                                                         0
                                                         half-tree-width
                                                         -30
                                                         "black")]
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
; HumdrumTree -> Natural
; produces the length of the longest token string in the tree

(define (get-diameter htree)
  (local [(define (fn-for-root root)
            (local [(define (iterator branches longest)
                      (cond [(empty? branches) (image-width
                                                 (text longest 12 "black"))]
                            [else
                              (iterator (rest branches)
                                        (fn-for-lon
                                          (first branches)
                                          longest))]))]
              (iterator (root-branches root) "")))

          (define (fn-for-lon branch longest)
            (cond [(empty? branch) longest]
                  [else
                    (local [(define result (fn-for-node (first branch)
                                                        longest))]
                      (if (> (string-length result)
                             (string-length longest))
                          (fn-for-lon (rest branch) result)
                          (fn-for-lon (rest branch) longest)))]))

          (define (fn-for-node node longest)
            (cond [(leaf? node) (fn-for-leaf node)]
                  [else
                    (fn-for-parent node longest)]))

          (define (fn-for-leaf leaf)
            (fn-for-token (leaf-token leaf)))

          (define (fn-for-parent parent longest)
            (local [(define parent-str (fn-for-token (parent-token parent)))
                    (define parent-str-length (string-length parent-str))

                    (define left-str (fn-for-lon (parent-left parent) longest))
                    (define left-str-length (string-length left-str))

                    (define right-str (fn-for-lon (parent-right parent)
                                                  longest))
                    (define right-str-length (string-length right-str))]
              (cond [(and (> parent-str-length left-str-length)
                          (> parent-str-length right-str-length)) parent-str]
                    [(> left-str-length right-str-length) left-str]
                    [right-str])))

          (define (fn-for-token token)
            (token-token token))]
    (fn-for-root (htree-root htree))))
