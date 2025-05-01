#lang racket/base

#|
	Function to convert a HumdrumFile to a HumdrumGraph.
|#

(require racket/contract
         racket/list
         racket/local
         "../ExclusiveInterpretation.rkt"
         "../HumdrumSyntax.rkt"
         "../TandemInterpretation.rkt"
         "../linked-spine/LinkedSpine.rkt"
         "../linked-spine/gspines-to-linked-spines-fn.rkt"
         "../spine-parsing-fn.rkt"
         "HumdrumGraph.rkt")

(provide hfile->hgraph)

(define/contract (hfile->hgraph hfile)
  (-> humdrum-file? humdrum-graph?)
  (hgraph
    (root empty)))
