#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hum-parser: data structures: HumdrumTree
;;    tests for visualize-htree
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require "../../../parser/data-definitions/data-definitions.rkt"
         (only-in "../../../parser/functions/file.rkt"
                  path->hfile)
         "../../../data-structures/abstract-humdrum-graph/data-definitions/data-definitions.rkt"
         "../../../data-structures/abstract-humdrum-graph/functions/hfile-to-ab-hgraph.rkt"
         "../../../data-structures/abstract-humdrum-graph/functions/visualize-ab-hgraph.rkt"
         "../../../data-structures/humdrum-tree/data-definitions/data-definitions.rkt"
         "../../../data-structures/humdrum-tree/functions/visualize-htree.rkt"
         2htdp/image
         test-engine/racket-tests)

(define
  three-spines-htree
  (hfile->ab-hgraph
    (path->hfile
      "../../../tests/data-structures/data/three-spines-visualize-htree.krn")
    htree))

(define node-img (circle (image-width (text "**dynam"
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

(define left-branch-img (above left-branch-node-1
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

(define middle-branch-node-1  (node-image "**kern" node-img))
(define middle-branch-node-2  (node-image "*^"     node-img))
(define middle-branch-node-3a (node-image "4a"     node-img))
(define middle-branch-node-3b (node-image "4aa"    node-img))
(define middle-branch-node-4a (node-image "*v"     node-img))
(define middle-branch-node-4b (node-image "*v"     node-img))
(define middle-branch-node-5  (node-image "=="     node-img))
(define middle-branch-node-6  (node-image "*-"     node-img))

(define left (above middle-branch-node-3a
                    straight-line
                    middle-branch-node-4a))
(define right (above middle-branch-node-3b
                     straight-line
                     middle-branch-node-4b))
(define lower-tree-image (beside left
                                 (pad (image-height left))
                                 right))
(define half-lower-tree-width (/ (image-width lower-tree-image) 2))
(define parent-img (above/align "center"
                                middle-branch-node-2
                                (add-line (add-line lower-tree-image
                                                    (- (image-width
                                                         lower-tree-image)
                                                       half-node-img-width)
                                                    0
                                                    half-lower-tree-width
                                                    negative-y
                                                    colour)
                                          half-node-img-width
                                          positive-y
                                          half-lower-tree-width
                                          0
                                          colour)))
(define middle-branch-img (above middle-branch-node-1
                                 straight-line
                                 (above parent-img
                                        (beside
                                          (above straight-line
                                                 middle-branch-node-5
                                                 straight-line
                                                 middle-branch-node-6)
                                          (rectangle (*
                                                       (+ (image-width node-img)
                                                          pad-width)
                                                       (factor parent-img
                                                               node-img))
                                                     (image-height
                                                       (above
                                                         middle-branch-node-5
                                                         straight-line
                                                         middle-branch-node-6))
                                                     mode
                                                     pad-colour)))))

(define right-branch-node-1 (node-image "**dynam" node-img))
(define right-branch-node-2 (node-image "*"       node-img))
(define right-branch-node-3 (node-image "f"       node-img))
(define right-branch-node-4 (node-image "*"       node-img))
(define right-branch-node-5 (node-image "=="      node-img))
(define right-branch-node-6 (node-image "*-"      node-img))

(define right-branch-img (above right-branch-node-1
                                straight-line
                                right-branch-node-2
                                straight-line
                                right-branch-node-3
                                straight-line
                                right-branch-node-4
                                straight-line
                                right-branch-node-5
                                straight-line
                                right-branch-node-6))

; visualize-htree
(check-expect (visualize-htree three-spines-htree)
              (local [(define branch-images (list-branch-images
                                              three-spines-htree
                                              node-img))

                      (define x-positions (branch-x-positions branch-images))

                      (define lower-image (pad-bottom-of-graph
                                            (result-images branch-images)))]
                (add-branch-lines lower-image x-positions)))

; list-branch-images
(check-expect (list-branch-images three-spines-htree node-img)
              (result (list left-branch-img
                            middle-branch-img
                            right-branch-img)
                      (list (image-width left-branch-img)
                            (image-width middle-branch-img)
                            (image-width right-branch-img))))

; subbranch-image
(check-expect (subbranch-image (parent (token "*^" "SpineSplit" 1)
                                       (list (leaf (token "4a" "SpineData" 2))
                                             (leaf (token "*v" "SpineJoin" 3)))
                                       (list (leaf (token "4aa" "SpineData" 2))
                                             (leaf (token "*v" "SpineJoin" 3))))
                               node-img)
              parent-img)

(test)
