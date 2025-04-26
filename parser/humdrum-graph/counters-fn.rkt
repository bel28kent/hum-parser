#lang racket/base

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hum-parser: data structures: HumdrumGraph
;;     counters: provides functions for counting graph structures
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require racket/list
         racket/local
         "../data-definitions/data-definitions.rkt")

; abstract-counter
; HumdrumGraph
; (Natural -> Natural) (Natural ... -> Natural) (Natural Natural -> Natural) Natural Boolean
; -> (listof Natural)
; produces a list of the number of X in the hgraph

(define (abstract-counter hgraph comb1 comb2 comb3 base depth?)
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
    (fn-for-root (humdrum-graph-root hgraph))))

; TODO: test
; node-counter
; HumdrumGraph -> (listof Natural)
; produces a list of the number of nodes in each branch

(define (node-counter hgraph)
  (abstract-counter hgraph add1 (λ (comb3 right) (+ 1 comb3 right)) + 0 #t))

; TODO: test
; branch-depths
; HumdrumGraph -> (listof Natural)
; produces a list of the number of nodes in each branch

(define (branch-depths hgraph)
  (abstract-counter hgraph add1 (λ (comb3 right) (+ 1 comb3 right)) + 0 #f))
