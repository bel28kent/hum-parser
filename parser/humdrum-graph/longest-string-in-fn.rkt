#lang racket/base

#|
	Function to find the longest string in a HumdrumGraph.
|#

(require racket/contract
         racket/list
         racket/local
         "../HumdrumSyntax.rkt"
         "HumdrumGraph.rkt")

(provide longest-string-in)

