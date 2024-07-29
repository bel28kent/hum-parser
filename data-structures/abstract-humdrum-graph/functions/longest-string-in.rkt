#lang racket/base

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hum-parser: data structures: AbstractHumdrumGraph
;;    longest-string-in: Produces the longest token string
;;        in the AbstractHumdrumGraph
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require racket/list
         racket/local
         "../../../parser/data-definitions/data-definitions.rkt"
         "../data-definitions/data-definitions.rkt")

(provide longest-string-in)

; longest-string-in
; AbstractHumdrumGraph -> String
; produces the longest token string in the tree

(define (longest-string-in ab-hgraph)
  (local [(define (fn-for-root root)
            (local [(define (iterator branches longest)
                      (cond [(empty? branches) longest]
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
                          (> parent-str-length right-str-length))
                     parent-str]
                    [(> left-str-length right-str-length) left-str]
                    [right-str])))

          (define (fn-for-token token)
            (token-token token))]
    (fn-for-root (abstract-humdrum-graph-root ab-hgraph))))
