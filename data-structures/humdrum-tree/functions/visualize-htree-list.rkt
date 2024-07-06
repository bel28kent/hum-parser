#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hum-parser: data structures: HumdrumTree
;;    visualize-htree: produces an image of a HumdrumTree
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require "../../../parser/data-definitions/data-definitions.rkt"
         "../data-definitions/data-definitions-list.rkt"
         pict
         pict/tree-layout
         racket/gui)

(provide get-diameter)

(define FACTOR 10)

; visualize-htree
; HumdrumTree -> Image
; produces an image of the HumdrumTree

(define (fn-for-htree htree)
  (local [(define (fn-for-root root)
            (local [(define (iterator branches)
                      (cond [(empty? branches) ...]
                            [else
                              (... (fn-for-lon (first branches))
                                   (iterator (rest branches)))]))]
              (iterator (root-branches root))))

          (define (fn-for-lon branch)
            (cond [(empty? branch) ...]
                  [else
                    (... (fn-for-node (first branch))
                         (fn-for-lon (rest branch)))]))

          (define (fn-for-node node)
            (cond [(leaf? node) (fn-for-leaf node)]
                  [else
                    (fn-for-parent node)]))

          (define (fn-for-leaf leaf)
            (... (fn-for-token (leaf-token leaf))))

          (define (fn-for-parent parent)
            (... (fn-for-token (parent-token parent))
                 (fn-for-lon (parent-left parent))
                 (fn-for-lon (parent-right parent))))

          (define (fn-for-token token)
            (... (token-token token)
                 (token-type token)
                 (token-record-number token)))]
    (... (fn-for-root (htree-root htree)))))

; get-diameter
; HumdrumTree -> Natural
; produces the length of the longest token string in the tree

(define (get-diameter htree)
  (local [(define (fn-for-root root)
            (local [(define (iterator branches longest)
                      (cond [(empty? branches) longest]
                            [else
                              (iterator (rest branches)
                                        (fn-for-lon (first branches) longest))]))]
              (iterator (root-branches root) 0)))

          (define (fn-for-lon branch longest)
            (cond [(empty? branch) longest]
                  [else
                    (local [(define result (fn-for-node (first branch) longest))]
                      (if (> result longest)
                          (fn-for-lon (rest branch) result)
                          (fn-for-lon (rest branch) longest)))]))

          ; Node -> Natural
          (define (fn-for-node node longest)
            (cond [(leaf? node) (fn-for-leaf node)]
                  [else
                    (fn-for-parent node longest)]))

          ; Leaf -> Natural
          (define (fn-for-leaf leaf)
            (fn-for-token (leaf-token leaf)))

          ; Parent -> Natural
          (define (fn-for-parent parent longest)
            (first (sort (list (fn-for-token (parent-token parent))
                               (fn-for-lon (parent-left parent) longest)
                               (fn-for-lon (parent-right parent) longest))
                         >)))

          (define (fn-for-token token)
            (string-length (token-token token)))]
    (fn-for-root (htree-root htree))))
