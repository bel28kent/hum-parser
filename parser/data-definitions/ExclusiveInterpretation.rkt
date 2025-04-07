#lang racket/base

#|
	Enumeration of known exclusive interpretations.

	Implemented as (hash Symbol RegularExpression ...)
|#

(define ExclusiveInterpretation (hash 'Dynam "^\\*{2}dynam"
                                      'Kern  "^\\*{2}kern"
))
