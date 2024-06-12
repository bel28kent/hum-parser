#lang racket

(require "../data-definitions/data-definitions.rkt"
         "../../abstract-fns/functions/functions.rkt")

(provide extract-spine-arity)

; TODO: test
; extract-spine-arity
; (listof Record) -> SpineArity
; produces the spine arity from a list of token records

(define (extract-spine-arity records)
  (local [; first record must be exclusive interpretation, otherwise is humdrum syntax error
          (define number-global-spines (length (first records)))

          ; (listof Record) -> (listof (listof Natural))
          (define (lolon tokens)
            (local [(define (??? records lolon)
                      (cond [(empty? records) lolon]
                            [else
                               (??? (rest records) (cons (!!! (first records)) lolon))]))]
              (??? tokens empty)))

          ; Record -> (listof Natural)
          (define (!!! record)
            (cond [(spine-struct? record) (struct-lon record)]
                  [else
                     (lon record)]))

          ; Record -> Boolean
          (define (spine-struct? record)
            (local [(define tokens (record-split record))

                    (define (spine-struct? lot)
                      (cond [(empty? lot) #f]
                            [(or (string=? (token-type (first lot)) SPINE-SPLIT)
                                 (string=? (token-type (first lot)) SPINE-JOIN)) #t]
                            [else
                               (spine-struct? (rest lot))]))]
              (spine-struct? tokens)))

          ; Record -> (listof Natural)
          (define (struct-lon record)
            ())

          ; Record -> (listof Natural)
          (define (lon record)
            (local [(define tokens (record-split record))

                    (define (lon ___)
                      (cond [(string=? (token-type (first lot)) EXCLUSIVE-INTERPRETATION) (one-per-spine 0)]
                            [else
                               ___]))]
              ()))]
    (make-spine-arity number-global-spines ???)))
