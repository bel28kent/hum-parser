#lang racket/base

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hum-parser: data structures: HumdrumGraph
;;    longest-string-in: Produces the longest token string
;;        in the HumdrumGraph
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require racket/list
         racket/local
         "../../../../parser/data-definitions/data-definitions.rkt"
         "../data-definitions/data-definitions.rkt")

(provide longest-string-in)

; longest-string-in
; HumdrumGraph -> String
; produces the longest token string in the tree

(define (longest-string-in hgraph)
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

          #|
              "*^" can never be the longest string in parent because the left
              and right children will at least contain "*v", which is equal in
              length to "*^".
          |#
          (define (fn-for-parent parent longest)
            (local [(define left-str (fn-for-lon (parent-left parent) longest))
                    (define left-str-length (string-length left-str))

                    (define right-str (fn-for-lon (parent-right parent)
                                                  longest))
                    (define right-str-length (string-length right-str))]
              (if (> left-str-length right-str-length)
                  left-str
                  right-str)))

          (define (fn-for-token token)
            (token-token token))]
    (fn-for-root (humdrum-graph-root hgraph))))
