#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hum-parser: data structures: AbstractHumdrumGraph
;;    tests for visualize-ab-hgraph
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require "../../../data-structures/abstract-humdrum-graph/functions/visualize-ab-hgraph.rkt"
         2htdp/image
         test-engine/racket-tests)

(define node-img (circle (image-width (text "2.C#] 2.B"
                                            font-size
                                            colour))
                         mode
                         colour))
(define half-node-img-width (/ (image-width node-img) 2))

(define left-branch-node-1 (node-image "**kern" node-img))
(define left-branch-node-2 (node-image "*"      node-img))
(define left-branch-node-3 (node-image "4A"     node-img))
(define left-branch-node-4 (node-image "*"      node-img))
(define left-branch-node-5 (node-image "=="     node-img))
(define left-branch-node-6 (node-image "*-"     node-img))

(define right-branch-node-1  (node-image "**kern" node-img))
(define right-branch-node-2  (node-image "*^"     node-img))
(define right-branch-node-3a (node-image "4a"     node-img))
(define right-branch-node-3b (node-image "4aa"    node-img))
(define right-branch-node-4a (node-image "*v"     node-img))
(define right-branch-node-4b (node-image "*v"     node-img))
(define right-branch-node-5  (node-image "=="     node-img))
(define right-branch-node-6  (node-image "*-"     node-img))

(define pad-subbranch (pad (image-height (above node-img
                                                straight-line
                                                node-img))))

(define left-branch (above left-branch-node-1
                           straight-line
                           left-branch-node-2
                           straight-line
                           left-branch-node-3
                           straight-line
                           left-branch-node-4
                           straight-line
                           left-branch-node-5
                           straight-line
                           left-branch-node-6))

(define lower-graph-image (beside (above right-branch-node-3a
                                         straight-line
                                         right-branch-node-4a)
                                  pad-subbranch
                                  (above right-branch-node-3b
                                         straight-line
                                         right-branch-node-4b)))
(define htree-right-branch
        (above right-branch-node-1
               straight-line
               right-branch-node-2
               (above/align "left"
                            (add-line (add-line lower-graph-image
                                                half-node-img-width
                                                0
                                                (/ (image-width
                                                     lower-graph-image)
                                                   2)
                                                negative-y
                                                colour)
                                      (- (image-width lower-graph-image)
                                         half-node-img-width)
                                      positive-y
                                      (/ (image-width lower-graph-image) 2)
                                      0
                                      colour)
                                      (above straight-line
                                             right-branch-node-5
                                             straight-line
                                             right-branch-node-6))))

(define left-x (* (- (/ (image-width lower-graph-image) 2)
                     half-node-img-width)
                  -1))
(define right-x (+ (/ pad-width 2)
                   half-node-img-width))

(define lines (beside (line left-x
                            negative-y
                            colour)
                      (line right-x
                            negative-y
                            colour)))

(define lines-pad (rectangle half-node-img-width
                             (image-height
                               lines)
                             mode
                             pad-colour))

(define hgraph-right-branch
        (above right-branch-node-1
               straight-line
               right-branch-node-2
               (above (above/align "left"
                                   lower-graph-image
                                   (beside lines-pad lines))
                      (above straight-line
                             right-branch-node-5
                             straight-line
                             right-branch-node-6))))

(define htree-result (result (list left-branch htree-right-branch)
                             (list (image-width left-branch)
                                   (image-width htree-right-branch))))
(define hgraph-result (result (list left-branch hgraph-right-branch)
                              (list (image-width left-branch)
                                    (image-width hgraph-right-branch))))

(define htree-image (beside left-branch
                            (pad (image-height left-branch)) 
                            htree-right-branch))
(define hgraph-image (beside left-branch
                             (pad (image-height left-branch))
                             hgraph-right-branch))

; three spines example
(define base-spine (above left-branch-node-1
                          straight-line
                          left-branch-node-6))
(define base-spine-width (image-width base-spine))
(define base-spine-pad (pad (image-height base-spine)))
(define three-spines (beside base-spine
                             base-spine-pad
                             base-spine
                             base-spine-pad
                             base-spine))
(define three-spines-width (image-width three-spines))
(define three-spines-result (result (list base-spine base-spine base-spine)
                                    (list base-spine-width
                                          base-spine-width
                                          base-spine-width)))

; node-image
(check-expect (node-image "**kern" node-img)
              (overlay (text "**kern" font-size colour)
                       node-img))
(check-expect (node-image "2.C#] 2.B" node-img)
              (overlay (text "2.C#] 2.B" font-size colour)
                       node-img))

; pad
(check-expect (pad 50) (rectangle pad-width 50 mode pad-colour))

; pad-bottom-of-graph
(check-expect (pad-bottom-of-graph (list left-branch htree-right-branch))
              htree-image)
(check-expect (pad-bottom-of-graph (list left-branch hgraph-right-branch))
              hgraph-image)

; branch-x-positions
(check-expect (branch-x-positions (result (list left-branch)
                                          (list (image-width left-branch))))
              (list (/ (image-width left-branch) 2)))
(check-expect (branch-x-positions htree-result)
              (local [(define tree-width (image-width
                                           (pad-bottom-of-graph
                                             (list left-branch
                                                   htree-right-branch))))]
                (list half-node-img-width
                      (- tree-width
                         (/ (image-width htree-right-branch) 2)))))
(check-expect (branch-x-positions hgraph-result)
              (local [(define graph-width (image-width
                                            (pad-bottom-of-graph
                                              (list left-branch
                                                    hgraph-right-branch))))]
                (list half-node-img-width
                      (- graph-width
                         (/ (image-width hgraph-right-branch) 2)))))
(check-expect (branch-x-positions three-spines-result)
              (list half-node-img-width
                    (/ three-spines-width 2)
                    (- three-spines-width
                       half-node-img-width)))

; add-branch-lines
(check-expect (add-branch-lines htree-image
                                (branch-x-positions htree-result))
                (local [(define tree-width (image-width
                                             (pad-bottom-of-graph
                                               (list left-branch
                                                     htree-right-branch))))

                        (define half-tree-width (/ tree-width 2))]
                  (above/align "center"
                               top-node
                               (add-line (add-line htree-image
                                                   half-node-img-width
                                                   0
                                                   half-tree-width 
                                                   negative-y
                                                   colour)
                                         (- tree-width
                                            (/ (image-width htree-right-branch)
                                               2))
                                         positive-y
                                         half-tree-width
                                         0
                                         colour))))
(check-expect (add-branch-lines hgraph-image
                                (branch-x-positions hgraph-result))
              (local [(define graph-width (image-width
                                            (pad-bottom-of-graph
                                              (list left-branch
                                                    hgraph-right-branch))))
                      (define half-graph-width (/ graph-width 2))]
                (above/align "center"
                             top-node
                             (add-line (add-line hgraph-image
                                                 half-node-img-width
                                                 0
                                                 half-graph-width 
                                                 negative-y
                                                 colour)
                                       (- graph-width
                                          (/ (image-width hgraph-right-branch)
                                             2))
                                       positive-y
                                       half-graph-width
                                       0
                                       colour))))

; factor
(check-expect (factor lower-graph-image node-img) 1)
;; 2 case (3 local spines)

(test)
