#lang racket/base

#|
	Enumeration of known exclusive interpretations.

	Implemented as (hash Symbol RegularExpression ...)
|#

(require racket/list
         racket/local
         (only-in "abstract-fn.rkt" get-type hash-match? hash-member?))

(provide ExclusiveInterpretation
         exclusive-interpretation?
         exclusive-interpretation-match?
         type-exclusive)

(define ExclusiveInterpretation (hash 'Dynam "^\\*{2}dynam"
                                      'Kern  "^\\*{2}kern"
                                      'MIDI  "^\\*{2}MIDI"
                                      'Neume "^\\*{2}neume"
                                      'Solfa "^\\*{2}solfa"
                                      'Text  "^\\*{2}text"
))

(define (exclusive-interpretation? str)
  (hash-member? ExclusiveInterpretation str))

(define (exclusive-interpretation-match? interp str)
  (hash-match? ExclusiveInterpretation interp str))

(define (type-exclusive str)
  (get-type str ExclusiveInterpretation 'Unknown))
