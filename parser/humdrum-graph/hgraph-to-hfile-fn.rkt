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

