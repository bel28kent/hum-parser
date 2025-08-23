#lang racket/base

#|
	Function to simply display HumdrumGraph to screen.
|#

(require racket/bool
         racket/contract
         racket/list
         racket/local
         "../HumdrumSyntax.rkt"
         "HumdrumGraph.rkt")

(provide display-hgraph)

