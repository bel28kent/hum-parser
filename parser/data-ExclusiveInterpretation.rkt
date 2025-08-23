#lang racket/base

#|
	Known exclusive interpretations.

	Implemented as (hash Symbol RegularExpression ...)

	To treat as an (unordered) enumeration:
		(hash-keys ExclusiveInterpretation)
|#

(provide ExclusiveInterpretation)

(define ExclusiveInterpretation (hash 'Dynam "^\\*{2}dynam$"
                                      'Kern  "^\\*{2}kern$"
                                      'MIDI  "^\\*{2}MIDI$"
                                      'Neume "^\\*{2}neume$"
                                      'Solfa "^\\*{2}solfa$"
                                      'Text  "^\\*{2}text$"
))
