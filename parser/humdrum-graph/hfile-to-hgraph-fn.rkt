#lang racket/base

#|
	Function to convert a HumdrumFile to a HumdrumGraph.
|#

(require racket/bool
         racket/contract
         racket/local
         racket/list
         "../linked-spine/LinkedSpine.rkt"
         "../linked-spine/gspines-to-linked-spines-fn.rkt"
         "../spine-parsing-fn.rkt"
         "../HumdrumSyntax.rkt"
         "../TandemInterpretation.rkt"
         "HumdrumGraph.rkt")

(provide hfile->hgraph)

#|
	ENDING A PARENT:
	The join and terminator cases that end parents are conflicting because the
	join case ends the split-node recursion, but not the overall recursion,
	while the terminator case ends the parent and overall recursion.

	MAYBE:
		(split-result (parent ...)
                              (if (terminator-node? node)
                                  node
                                  (unbox (token-node-next node))))

	Though if the above is done, then terminators that end parents will be outside
	of the parent wrapper.

	I think this gets back to the join problem . . .
|#
(define (hfile->hgraph hfile)
  (-> humdrum-file? humdrum-graph?)
  (local [(define (linked-spine->nodes linked-spine)
            (local [(struct split-result (parent next-after-parent))

                    (define (join? node)
                      (if (token-node? node)
                          (symbol=? 'SpineJoin (token-type (token-node-token node)))
                          #f))

                    (define (fn-for-node node)
                      (cond [(token-node? node) (append (fn-for-token-node node))]
                            [(split-node? node)
                             (local [(define result (fn-for-split-node node))]
                               (append (list (split-result-parent result))
                                       (fn-for-node (split-result-next-after-parent result))))]
                            [else
                              (append (fn-for-terminator-node node))]))

                    (define (fn-for-token-node node)
                      (append (fn-for-token (token-node-token node))
                              (fn-for-node (unbox (token-node-next node)))))

                    (define (fn-for-split-node node)
                      ...)

                    (define (fn-for-terminator-node node)
                      (fn-for-token (terminator-node-token node)))

                    (define (fn-for-token token)
                      (list (leaf token)))]
              (fn-for-node (linked-spine-first-node linked-spine))))]
    (hgraph
      (root
        (map linked-spine->nodes
             (gspines->linked-spines
               (spine-parser hfile)
               hfile))))))
