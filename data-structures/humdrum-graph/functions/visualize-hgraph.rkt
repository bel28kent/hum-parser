#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hum-parser: data structures: HumdrumGraph
;;    visualize-hgraph: produces an image of a HumdrumGraph
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require "../../../parser/data-definitions/data-definitions.rkt"
         "../../abstract-humdrum-graph/data-definitions/data-definitions.rkt"
         "../../abstract-humdrum-graph/functions/longest-string-in.rkt"
         "../data-definitions/data-definitions.rkt"
         2htdp/image)

(provide visualize-hgraph)

(define straight-line (line 0 30 "black"))
(define top-node (circle 5 "outline" "black"))
(define pad-width 50)

(struct result (images widths) #:transparent)

; visualize-hgraph
; HumdrumGraph -> Image
; produces an image of the graph

(define (visualize-hgraph hgraph)
  (local [(define node-img (circle (image-width
                                     (text (longest-string-in hgraph)
                                           12
                                           "black"))
                                   "outline"
                                   "black"))

          (define branch-images (list-branch-images hgraph node-img))

          (define x-positions (branch-x-positions branch-images))

          (define lower-graph-image (pad-bottom-of-graph
                                      (result-images branch-images)))]
    (add-branch-lines lower-graph-image x-positions)))

; list-branch-images
; HumdrumGraph -> Result
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
            (cond [(empty? (rest branch)) (node-image (token-token
                                                        (leaf-token
                                                          (first branch)))
                                                      node-img)]
                  [(parent? (first branch))
                    (local [(define top-image (subbranch-image (first branch)
                                                               node-img))
                            (define width-top-image (image-width top-image))

                            (define bottom-image (fn-for-branch (rest branch)))

                            (define left-x (* (- (/ width-top-image 2)
                                                 (/ (image-width node-img) 2))
                                              -1))
                            (define right-x (- (/ width-top-image 2)
                                               (/ (image-width node-img) 2)))]
                      (above top-image
                             (beside (line left-x  -30 "black")
                                     (line right-x -30 "black"))
                             bottom-image))]
                  [else
                    (above (node-image (token-token (leaf-token (first branch)))
                                       node-img)
                           straight-line
                           (fn-for-branch (rest branch)))]))

          (define rnr (fn-for-root
                        (root-branches
                          (abstract-humdrum-graph-root hgraph))))]
    (result rnr (map image-width rnr))))

; subbranch-image
; Parent Image -> Image
; handles parent images

(define (subbranch-image parent node-img)
  (local [(define subgraph (hgraph
                             (root (list (parent-left parent)
                                         (parent-right parent)))))

          (define (visualize-subgraph subgraph)
            (local [(define branch-images (list-branch-images
                                            subgraph node-img))

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
                                       -30
                                       "black")]
                            [else
                             (add-line (add-subbranch-lines (rest x-positions))
                                       (first x-positions)
                                       30
                                       half-graph-width
                                       0
                                       "black")]))]
              (above/align "center"
                           (node-image (token-token (parent-token parent))
                                       node-img)
                           (add-subbranch-lines x-positions))))]
    (visualize-subgraph subgraph)))

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
  (rectangle pad-width height "outline" "white"))

; pad-bottom-of-graph
; (listof Image) -> Image
; produces a concatenation of result-images, separated by padding rectangle

(define (pad-bottom-of-graph loi)
  (local [(define padding (pad (image-height (first loi))))
          
          (define (pad-bottom-of-graph loi)
            (cond [(empty? (rest loi)) (first loi)]
                  [else
                   ; if not naive layered: beside/align "top"
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
            (local [(define (x-positions branch-widths prev-x prev-midpoint acc)
                      (cond [(empty? (rest branch-widths))
                             (reverse
                               (cons (- graph-width
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
; produces the final image of the graph

(define (add-branch-lines graph-image x-positions)
  (local [(define half-graph-width (/ (image-width graph-image) 2))

          (define (add-branch-lines x-positions)
            (cond [(empty? (rest x-positions)) (add-line graph-image
                                                         (first x-positions)
                                                         0
                                                         half-graph-width
                                                         -30
                                                         "black")]
                  [else
                   (add-line (add-branch-lines (rest x-positions))
                             (first x-positions)
                             30
                             half-graph-width
                             0
                             "black")]))]
    (above/align "center"
                 top-node
                 (add-branch-lines x-positions))))

; factor
; Image -> Natural
; produces a natural corresponding to one less than number of spines in parent

; TODO: could return zero
(define (factor parent-image node-img)
  (local [(define width-parent-image (image-width parent-image))

          (define width-node-img (image-width node-img))]
    (sub1 (round (/ width-parent-image (+ width-node-img pad-width))))))
