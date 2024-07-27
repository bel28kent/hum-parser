#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hum-parser: data structures: AbstractHumdrumGraph
;;    visualize-ab-hgraph: provides definitions for
;;        visualizing HumdrumTree and HumdrumGraph
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require "../../../parser/data-definitions/data-definitions.rkt"
         "../../abstract-humdrum-graph/data-definitions/data-definitions.rkt"
         2htdp/image)

(provide (all-defined-out))

(define colour "black")
(define pad-colour "white")
(define mode "outline")
(define positive-y 30)
(define negative-y -30)
(define pad-width 50)
(define font-size 12)
(define top-node (circle 5 mode colour))
(define straight-line (line 0 positive-y colour))

(struct result (images widths) #:transparent)

; node-image
; String Image -> Image
; produces an image of a node

(define (node-image token-str node-img)
  (overlay (text token-str font-size colour)
           node-img))

; pad
; Natural -> Image
; produces a white rectangle to pad space between branches

; assumes naive layered
(define (pad height)
  (rectangle pad-width height mode pad-colour))

; pad-bottom-of-graph
; (listof Image) -> Image
; produces a concatenation of result-images, separated by padding rectangle

(define (pad-bottom-of-graph loi)
  (local [(define padding (pad (image-height (first loi))))
          
          (define (pad-bottom-of-graph loi)
            (cond [(empty? (rest loi)) (first loi)]
                  [else
                   (beside (first loi)
                           padding
                           (pad-bottom-of-graph (rest loi)))]))]
    (pad-bottom-of-graph loi)))

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
          (define graph-width (image-width
                                (pad-bottom-of-graph (result-images result))))

          (define (x-positions branch-widths)
            ; prev-x. Natural. The x position of the previous line.
            ; prev-midpoint. Natural. The midpoint of the previous branch.
            (local [(define half-first (/ (first branch-widths) 2))

                    (define (x-positions branch-widths prev-x prev-midpoint acc)
                      (local [(define half-first (/ (first branch-widths) 2))]
                        (cond [(empty? (rest branch-widths))
                               (reverse
                                 (cons (- graph-width
                                          half-first)
                                       acc))]
                              [else
                               (x-positions (rest branch-widths)
                                            (+ prev-x
                                               prev-midpoint
                                               pad-width
                                               half-first)
                                            half-first
                                            (cons (+ prev-x
                                                     prev-midpoint
                                                     pad-width
                                                     half-first)
                                                  acc))])))]
              (if (= 1 (length branch-widths))
                  (list half-first)
                  (x-positions (rest branch-widths)
                               half-first
                               half-first
                               (list half-first)))))]
    (x-positions branch-widths)))

; add-branch-lines
; Image (listof Natural) -> Image
; produces the final image of the graph

(define (add-branch-lines graph-image x-positions)
  (local [(define half-graph-width (/ (image-width graph-image) 2))

          (define (add-branch-lines x-positions)
            (cond [(empty? (rest x-positions)) (add-line graph-image
                                                         (first x-positions)
                                                         0
                                                         half-graph-width
                                                         negative-y
                                                         colour)]
                  [else
                   (add-line (add-branch-lines (rest x-positions))
                             (first x-positions)
                             positive-y
                             half-graph-width
                             0
                             colour)]))]
    (above/align "center"
                 top-node
                 (add-branch-lines x-positions))))

; factor
; Image Image -> Natural
; produces a natural corresponding to one less than number of spines in parent

; TODO: could return zero
(define (factor parent-image node-img)
  (local [(define width-parent-image (image-width parent-image))

          (define width-node-img (image-width node-img))]
    (sub1
      (round (/ width-parent-image
                (+ width-node-img
                   pad-width))))))
