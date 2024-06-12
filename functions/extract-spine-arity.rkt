#lang racket

(require "../data-definitions/data-definitions.rkt"
         "../../abstract-fns/functions/functions.rkt"
         test-engine/racket-tests)

;(provide extract-spine-arity)

; TODO: test
; extract-spine-arity
; (listof Record) -> SpineArity
; produces the spine arity from a list of token records

;(define (extract-spine-arity records)
;  (local [; first record must be exclusive interpretation, otherwise is humdrum syntax error
;          (define number-global-spines (length (first records)))]
;    (make-spine-arity number-global-spines ???)))

; lolon
; (listof Record) -> (listof (listof Natural))
; produces the lolon field of the spine arity struct
(define (lolon tokens)
  (local [(define (??? records lolon)
            (cond [(empty? records) lolon]
                  [else
                    (??? (rest records) (cons (!!! (first records) lolon) lolon))]))]
    (??? tokens empty)))

; !!!
; Record (listof (listof Natural)) -> (listof Natural)
; if record is spine structure, call struct-lon helper, else call lon helper
; TODO: should be if PREVIOUS record is spine structure
(define (!!! record lolon)
  (cond [(spine-struct? record) (struct-lon record lolon)]
        [else
          (lon record lolon)]))

; spine-struct?
; Record -> Boolean
; produces true if record has a spine-split token or spine-join token
(define (spine-struct? record)
  (local [(define tokens (record-split record))

          (define (spine-struct? lot)
            (cond [(empty? lot) #f]
                  [(or (string=? (split-or-join (first lot)) SPINE-SPLIT)
                       (string=? (split-or-join (first lot)) SPINE-JOIN)) #t]
                  [else
                    (spine-struct? (rest lot))]))]
    (spine-struct? tokens)))

; split-or-join
; Token -> SpineSplit or SpineJoin or false
; produces true if token is a spine-split or spine-join
(define (split-or-join token)
  (cond [(string=? (token-type token) SPINE-SPLIT) SPINE-SPLIT]
        [(string=? (token-type token) SPINE-JOIN) SPINE-JOIN]
        [else
          #f]))

; struct-lon
; Record (listof (listof Natural)) -> (listof Natural)
; produces the lon for this structure record
; TODO: should be this record, which is AFTER structure
(define (struct-lon record lolon)
  (local [(define tokens (record-split record))
;
;          (define (caller token)
;            (cond [(string=? (split-or-join token) SPINE-SPLIT) (split record)]
;                  [else
;                    (join record)]))

          ;(define (split record)
          ;  (local [(define previous (copy-previous (record-record-number record) lolon))]
          ;    ()))

          ;(define (join record)
          ;  ())
          ]
    (tokens)))

; lon
; Record (listof (listof Natural)) Natural -> (listof Natural)
; produces the lon for this record, which is not after a structure
(define (lon record lolon number-global-spines)
  (local [(define tokens (record-split record))

          (define (lon lot)
            (cond [(string=? (token-type (first lot)) EXCLUSIVE-INTERPRETATION) (one-per-spine 0)]
                  [else
                    (copy-previous (sub1 (record-record-number record)) lolon)]))

          (define (one-per-spine counter)
            (cond [(= counter number-global-spines) empty]
                  [else
                    (cons 1 (one-per-spine (add1 counter)))]))]
    (lon tokens)))

; copy-previous
; Natural (listof (listof Natural)) -> (listof Natural)
; copies the previous lon
(define (copy-previous record-number lolon)
  (local [(define (iterator counter lolon)
            (cond [(= counter record-number) (first lolon)]
                  [else
                    (iterator (add1 counter) (rest lolon))]))]
    (iterator 0 lolon)))




























