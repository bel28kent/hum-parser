#lang racket/base

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hum-parser: data-structures: LinkedSpine
;;    Function templates
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require "../data-definitions/data-definitions.rkt")

(define (fn-for-linked-spine linked-spine)
  (local [(define (fn-for-node node)
            (cond [(token-node?) (fn-for-token-node node)]
                  [(split-node?) (fn-for-split-node node)]
                  [else
                    (fn-for-terminator-node node)]))

          (define (fn-for-token-node node)
            (... (fn-for-token (token-node-token node))
                 (fn-for-node-box (token-node-next node))))

          (define (fn-for-split-node node)
            (... (fn-for-token (split-node-token node))
                 (fn-for-node-box (split-node-left-next node))
                 (fn-for-node-box (split-node-right-next node))))

          (define (fn-for-terminator-node node)
            (... (fn-for-node-box (terminator-node-token node))))

          (define (fn-for-node-box node-box)
            (fn-for-node (unbox (node-box-box node-box))))

          (define (fn-for-token token)
            (... (token-token token)
                 (token-type token)
                 (token-record-number token)
                 (token-field-index token)))]
    (fn-for-node (linked-spine-first-node linked-spine))))
