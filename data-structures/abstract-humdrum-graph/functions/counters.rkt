#lang racket/base

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hum-parser: data structures: AbstractHumdrumGraph
;;     counters: provides functions for counting tree structures
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require racket/list
         racket/local
         "../data-definitions/data-definitions.rkt")

; abstract-counter
; AbstractHumdrumGraph
; (Natural -> Natural) (Natural ... -> Natural) (Natural Natural -> Natural) Natural Boolean
; -> (listof Natural)
; produces a list of the number of X in the ab-hgraph

(define (abstract-counter ab-hgraph comb1 comb2 comb3 base depth?)
  (local [(define (fn-for-root root)
            (foldr (λ (f rnr) (cons (fn-for-lon f) rnr)) empty (root-branches root)))

          (define (fn-for-lon branch)
            (cond [(empty? branch) base]
                  [(leaf? (first branch)) (comb1 fn-for-lon (rest branch))]
                  [else ; parent case
                    (comb2 ; "*^"
                           (comb3 (fn-for-lon (parent-left (first branch)))
                                  (fn-for-lon (rest branch)))
                           (if depth?
                               (fn-for-lon (parent-right first branch))
                               0))]))]
    (fn-for-root (abstract-humdrum-graph-root ab-hgraph))))

; TODO: test
; node-counter
; AbstractHumdrumGraph -> (listof Natural)
; produces a list of the number of nodes in each branch

(define (node-counter ab-hgraph)
  (abstract-counter ab-hgraph add1 (λ (comb3 right) (+ 1 comb3 right)) + 0 #t))

; TODO: test
; branch-depths
; AbstractHumdrumGraph -> (listof Natural)
; produces a list of the number of nodes in each branch

(define (branch-depths ab-hgraph)
  (abstract-counter ab-hgraph add1 (λ (comb3 right) (+ 1 comb3 right)) + 0 #f))
