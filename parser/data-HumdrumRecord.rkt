#lang racket/base

#|
	Humdrum record types.

	Implemented as (hash Symbol RegularExpression ...)

	To treat as an (unordered) enumeration:
		(hash-keys HumdrumRecord)
|#

(provide HumdrumRecord)

(define HumdrumRecord (hash 'ExclusiveInterpretation "^\\*\\*.*$"
                            'GlobalComment           "^!![^!].*$"
                            'LocalComment            "^![^!].*$"
                            'Measure                 "^="
                            'Reference               "^!!!.*$"
                            'TandemInterpretation    "^\\*[^\\*].*$"
                            'Token                   "^[^\\*!=].*"
))
