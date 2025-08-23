#lang racket/base

#|
	Humdrum token types.

	Implemented as (hash Symbol RegularExpression ...)

	To treat as an (unordered) enumeration:
		(hash-keys HumdrumToken)
|#

(provide HumdrumToken)

(define HumdrumToken (hash 'ExclusiveInterpretation "^\\*\\*\\w+$"
                           'LocalComment            "^!{1}.*$"
                           'Measure                 "^=[^\\s]*$"
                           'NullSpineData           "^\\.$"
                           'SpineData               "^[^\\*!=\\.].*$"
                           'TandemInterpretation    "^\\*[^\\*]*$"
))
