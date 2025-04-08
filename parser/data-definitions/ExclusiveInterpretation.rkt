#lang racket/base

#|
	Enumeration of known exclusive interpretations.

	Implemented as (hash Symbol RegularExpression ...)
|#

(require racket/contract
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

; TODO: abstract here and in TandemInterpretation
(define/contract (exclusive-interpretation? str)
  (-> string? boolean?)
  (local [(define (exclusive-interpretation? keys)
            (cond [(empty? keys) #f]
                  [(exclusive-interpretation-match? (first keys) str) #t]
                  [else
                    (exclusive-interpretation? (rest keys))]))]
    (exclusive-interpretation? (hash-keys ExclusiveInterpretation))))

; TODO: abstract here and in TandemInterpretation
(define/contract (exclusive-interpretation-match? interp str)
  (-> symbol? string? boolean?)
  (regexp-match? (pregexp
                   (hash-ref ExclusiveInterpretation interp))
                 str))
