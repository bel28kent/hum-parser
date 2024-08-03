#lang racket/base

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hum-parser: data structures: HumdrumTree
;;    visualize-htree: produces an image of a HumdrumTree
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require racket/list
         racket/local
         2htdp/image
         "../../../parser/data-definitions/data-definitions.rkt"
         "../../abstract-humdrum-graph/data-definitions/data-definitions.rkt"
         "../../abstract-humdrum-graph/functions/longest-string-in.rkt"
         "../../abstract-humdrum-graph/functions/visualize-ab-hgraph.rkt"
         "../data-definitions/data-definitions.rkt")

(provide (all-defined-out))

; visualize-htree
; HumdrumTree -> Image
; produces an image of the tree

(define (visualize-htree htree)
  (local [(define node-img (circle (image-width
                                     (text (longest-string-in htree)
                                           font-size
                                           colour))
                                   mode
                                   colour))

          (define branch-images (list-branch-images htree node-img))

          (define x-positions (branch-x-positions branch-images))

          (define lower-tree-image (pad-bottom-of-graph
                                     (result-images branch-images)))]
    (add-branch-lines lower-tree-image x-positions)))

; list-branch-images
; HumdrumTree Image -> Result
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
            (cond [(empty? (rest branch)) (node-image (token-token
                                                        (leaf-token
                                                          (first branch)))
                                                      node-img)]
                  [(parent? (first branch))
                   (local [(define top-image (subbranch-image
                                               (first branch)
                                               node-img))

                           (define width-top-image (image-width top-image))

                           (define bottom-image (fn-for-branch (rest branch)))

                           (define padding-rectangle
                                   (rectangle (* (+ (image-width node-img)
                                                    pad-width)
                                                 (factor top-image node-img))
                                              (image-height bottom-image)
                                              mode
                                              pad-colour))]
                     (above top-image
                            (beside
                              (above straight-line
                                     bottom-image)
                              padding-rectangle)))]
                  [else
                   (above (node-image
                            (token-token (leaf-token (first branch)))
                            node-img)
                          straight-line
                          (fn-for-branch (rest branch)))]))

          (define rnr (fn-for-root
                        (root-branches
                          (abstract-humdrum-graph-root htree))))]
    (result rnr (map image-width rnr))))

; subbranch-image
; Parent Image -> Image
; handles parent images

(define (subbranch-image parent node-img)
  (local [(define subtree (htree
                            (root (list (parent-left parent)
                                        (parent-right parent)))))

          (define (visualize-subtree subtree)
            (local [(define branch-images (list-branch-images
                                            subtree node-img))

                    (define x-positions (branch-x-positions branch-images))

                    (define lower-tree-image (pad-bottom-of-graph
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
                                       negative-y
                                       colour)]
                            [else
                             (add-line (add-subbranch-lines (rest x-positions))
                                       (first x-positions)
                                       positive-y
                                       half-tree-width
                                       0
                                       colour)]))]
              (above/align "center"
                           (node-image (token-token (parent-token parent))
                                       node-img)
                           (add-subbranch-lines x-positions))))]
    (visualize-subtree subtree)))
