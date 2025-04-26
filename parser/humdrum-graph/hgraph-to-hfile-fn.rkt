#lang racket/base

#|
	Function to convert a HumdrumGraph to a HumdrumFile.

	N.B.:
	This function only assembles data in the given HumdrumGraph. Non-token records filtered
	out when the HumdrumGraph was created are not inserted, so resultant HumdrumFile may be
	smaller than original.
|#

(require racket/contract
         racket/list
         racket/local
         "HumdrumGraph.rkt"
         "../HumdrumSyntax.rkt"
         "../string-fn.rkt")

(provide (all-defined-out))

(define/contract (hgraph->hfile hgraph)
  (-> humdrum-graph? humdrum-file?)
  (hfile
    (tokens->records
      (hgraph->tokens hgraph))))

(define/contract (tokens->records tokens)
  (-> (listof (listof token?)) (listof record?))
  (local [(define (tokens->record tokens)
            (local [(define r (gather (map token-token tokens) TokenSeparator))]
              (record r
                      (type-humdrum-record r)
                      tokens
                      (token-record-index (first tokens)))))]
    (map tokens->record tokens)))

(define/contract (hgraph->tokens hgraph)
  (-> humdrum-graph? (listof (listof token?)))
  (local [(define (fn-for-root root)
            (local [(define (iterator branches acc rec lolot)
                      (cond [(and (empty? branches) (empty? acc)) (reverse
                                                                    (cons (reverse rec) lolot))]
                            [(and (empty? branches)
                                  (not (empty? acc))) (iterator (reverse acc)
                                                                empty
                                                                empty
                                                                (cons (reverse rec) lolot))]
                            [else
                              (local [(define fof (first (first branches)))
                                      (define t (cond [(leaf? fof) (leaf-token fof)]
                                                      [(parent-token fof)]))
                                      (define rof (rest (first branches)))]
                                (iterator (rest branches)
                                          (cond [(parent? fof) (cons (parent-right fof)
                                                                 (cons (append (parent-left fof)
                                                                               rof)
                                                                   acc))]
                                                [(not (empty? rof)) (cons rof acc)]
                                                [acc])
                                          (cons t rec)
                                          lolot))]))]
              (iterator (root-branches root) empty empty empty)))]
    (fn-for-root (humdrum-graph-root hgraph))))
