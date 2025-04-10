#lang racket/base

#|
	Enumeration of known exclusive interpretations.

	Implemented as (hash Symbol RegularExpression ...)
|#

(require (only-in "abstract-fn.rkt" hash-match? hash-member?)
         racket/list
         racket/local)

(provide ExclusiveInterpretation
         exclusive-interpretation?
         exclusive-interpretation-match?)

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

; type-spine
; (listof (listof Token)) -> SpineType or false
; produce the type of the spine or false if unknown
(define (type-spine lolot)
  (local
    [(define first-token (begin (cond [(not (= 1 (length (first lolot))))
                                       (raise-argument-error 'type-spine
                                                             "only 1 exclusive interpretation"
                                                             (first lolot))]
                                      [(not (exclusive-interpretation? (token-token
                                                                        (first (first lolot)))))
                                       (raise-argument-error 'type-spine
                                                             "first token must start with **"
                                                             (first (first lolot)))])
                                     (first (first lolot))))]
    (cond [(kern? first-token) KERN]
          [(dynam? first-token) DYNAM]
          [else
            #f])))
