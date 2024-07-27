#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hum-parser: data structures: HumdrumGraph
;;    visualize-hgraph: produces an image of a HumdrumGraph
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require "../../../parser/data-definitions/data-definitions.rkt"
         "../../abstract-humdrum-graph/data-definitions/data-definitions.rkt"
         "../../abstract-humdrum-graph/functions/longest-string-in.rkt"
         "../../abstract-humdrum-graph/functions/visualize-ab-hgraph.rkt"
         "../data-definitions/data-definitions.rkt"
         2htdp/image)

(provide visualize-hgraph)

; visualize-hgraph
; HumdrumGraph -> Image
; produces an image of the graph

(define (visualize-hgraph hgraph)
  (local [(define node-img (circle (image-width
                                     (text (longest-string-in hgraph)
                                           font-size
                                           colour))
                                   mode
                                   colour))

          (define branch-images (list-branch-images hgraph node-img))

          (define x-positions (branch-x-positions branch-images))

          (define lower-graph-image (pad-bottom-of-graph
                                      (result-images branch-images)))]
    (add-branch-lines lower-graph-image x-positions)))

; list-branch-images
; HumdrumGraph Image String -> Result
; produces a list of images of each branch

(define (list-branch-images hgraph node-img)
  (local [; (listof (listof Natural)) -> (listof Image)
          (define (fn-for-root root)
            (cond [(empty? root) empty]
                  [else
                   (cons (fn-for-branch (first root))
                         (fn-for-root (rest root)))]))

          ; (listof Natural) -> Image
          (define (fn-for-branch branch)
            (local [(define half-node-img (/ (image-width node-img) 2))

                    (define (fn-for-branch branch)
                      (cond [(empty? (rest branch))
                             (node-image (token-token
                                           (leaf-token
                                             (first branch)))
                                          node-img)]
                            [(parent? (first branch))
                             (local [(define top-image (subbranch-image
                                                         (first branch)
                                                         node-img))
                                     (define width-top-image (image-width
                                                               top-image))

                                     (define bottom-image (fn-for-branch
                                                            (rest branch)))

                                     (define left-x (* (- (/ width-top-image 2)
                                                          half-node-img)
                                                       -1))
                                     (define right-x (+ (/ pad-width 2)
                                                        half-node-img))

                                     (define lines (beside (line left-x
                                                                 negative-y
                                                                 colour)
                                                           (line right-x
                                                                 negative-y
                                                                 colour)))

                                     (define lines-pad (rectangle half-node-img
                                                                  (image-height
                                                                    lines)
                                                                  mode
                                                                  pad-colour))]
                               (above (above/align "left"
                                                   top-image
                                                   (beside lines-pad lines))
                                      bottom-image))]
                            [else
                              (above (node-image (token-token
                                                   (leaf-token
                                                     (first branch)))
                                                 node-img)
                                     straight-line
                                     (fn-for-branch (rest branch)))]))]
              (fn-for-branch branch)))

          (define rnr (fn-for-root
                        (root-branches
                          (abstract-humdrum-graph-root hgraph))))]
    (result rnr (map image-width rnr))))

; subbranch-image
; Parent Image -> Image
; produces an image of the parent

(define (subbranch-image parent node-img)
  (local [(define subgraph (hgraph
                             (root (list (parent-left parent)
                                         (parent-right parent)))))

          (define (visualize-subgraph subgraph)
            (local [(define branch-images (list-branch-images subgraph
                                                              node-img))

                    (define x-positions (branch-x-positions branch-images))

                    (define lower-graph-image (pad-bottom-of-graph
                                                (result-images branch-images)))]
              (add-subbranch-lines lower-graph-image x-positions)))

          (define (add-subbranch-lines lower-graph-image x-positions)
            (local [(define half-graph-width (/ (image-width lower-graph-image)
                                                2))

                    (define (add-subbranch-lines x-positions)
                      (cond [(empty? (rest x-positions))
                             (add-line lower-graph-image
                                       (first x-positions)
                                       0
                                       half-graph-width
                                       negative-y
                                       colour)]
                            [else
                             (add-line (add-subbranch-lines (rest x-positions))
                                       (first x-positions)
                                       positive-y
                                       half-graph-width
                                       0
                                       colour)]))]
              (above/align "center"
                           (node-image (token-token (parent-token parent))
                                       node-img)
                           (add-subbranch-lines x-positions))))]
    (visualize-subgraph subgraph)))
