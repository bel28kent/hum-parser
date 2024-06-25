#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hum-parser: data structures: HumdrumTree
;;    Template
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require "../data-definitions/data-definitions.rkt")

(define (fn-for-htree htree)
  (local [(define (fn-for-root root)
            (cond [(empty? (root-branches root)) ...]
                  [else
                    (... (fn-for-node (first (root-branches root)))
                         (fn-for-root (rest (root-branches root))))]))

          (define (fn-for-node node)
            (cond [(false? node) ...]
                  [(leaf? node) (fn-for-leaf node)]
                  [else
                    (fn-for-parent node)]))

          (define (fn-for-leaf leaf)
            (... (fn-for-token (leaf-token leaf))
                 (fn-for-node (leaf-node leaf))))

          (define (fn-for-parent parent)
            (... (fn-for-token (parent-token parent))
                 (fn-for-node (parent-left parent))
                 (fn-for-node (parent-right parent))))

          (define (fn-for-token token)
            (... (token-token token)
                 (token-type token)
                 (token-record-number token)))]
    (fn-for-root (htree-root htree))))
