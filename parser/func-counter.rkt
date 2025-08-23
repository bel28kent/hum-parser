#lang racket/base

#|
	Functions for counting HumdrumGraph structures.
|#

(require racket/contract
         racket/list
         racket/local
         "HumdrumGraph.rkt")

(define/contract (abstract-counter hgraph comb1 comb2 comb3 base depth?)
  (-> humdrum-graph? (-> natural-number/c natural-number/c)
                     (-> natural-number/c any/c natural-number/c)
                     (-> natural-number/c natural-number/c natural-number/c)
                     natural-number/c
                     boolean?
      (listof natural-number/c))
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
(define (node-counter hgraph)
  (abstract-counter hgraph add1 (λ (comb3 right) (+ 1 comb3 right)) + 0 #t))

; TODO: test
(define (branch-depths hgraph)
  (abstract-counter hgraph add1 (λ (comb3 right) (+ 1 comb3 right)) + 0 #f))
