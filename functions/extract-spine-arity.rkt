#lang racket

(require "../data-definitions/data-definitions.rkt"
         "../../abstract-fns/functions/functions.rkt")

(provide (all-defined-out))

; BASE CASE:  a list of only one record, the exclusive interpretation record
; ASSUMPTION: the first record must be the exclusive interpretation record,
;             otherwise is humdrum syntax error

; TODO: test
; extract-spine-arity
; (listof Record) -> SpineArity
; produces the spine arity from a list of token records

(define (extract-spine-arity records)
  (make-spine-arity (length (record-split (first records)))
                    (lolon records)))

; lolon
; (listof Record) -> (listof (listof Natural))
; produces the lolon field of the spine arity struct

(define (lolon records)
  (local [(define (iterator records lolon previous)
            (cond [(empty? records) (reverse lolon)]
                  [else
                    (iterator (rest records)
                              (cons (lon-caller previous (first records) (first lolon)) lolon)
                              (first records))]))]
    (if (= (length records) 1)
        (list (one-per-spine (length (record-split (first records)))))
        (iterator (rest records)
                  (list (one-per-spine (length (record-split (first records)))))
                  (first records)))))

; lon-caller
; Record Record (listof Natural) -> (listof Natural)
; if first record is spine structure, call struct-lon helper, just return previous lon

(define (lon-caller previous record prev-lon)
  (cond [(previous-spine-struct? previous) (struct-lon previous record prev-lon)]
        [else
          prev-lon]))

; previous-spine-struct?
; Record -> Boolean
; produces true if the previous record has a spine-split token or spine-join token

(define (previous-spine-struct? previous)
  (local [(define tokens (record-split previous))

          (define (spine-struct? lot)
            (cond [(empty? lot) #f]
                  [(not (false? (split-or-join-token (first lot)))) #t]
                  [else
                    (spine-struct? (rest lot))]))]
    (spine-struct? tokens)))

; split-or-join-token?
; Token -> Boolean
; produces true if type of token is SpineSplit or SpineJoin

(define (split-or-join-token token)
  (cond [(false? (token-type token)) #f]
        [(string=? (token-type token) SPINE-SPLIT) #t]
        [(string=? (token-type token) SPINE-JOIN) #t]
        [else
          #f]))

; split-or-join-record
; Record -> SpineSplit or SpineJoin or false
; produces type if SpineSplit or SpineJoin, else false

(define (split-or-join-record record)
  (local [(define tokens (record-split record))

          (define (split-or-join tokens)
            (cond [(empty? tokens) #f]
                  [(false? (token-type (first tokens))) (split-or-join (rest tokens))]
                  [(string=? (token-type (first tokens)) SPINE-SPLIT) SPINE-SPLIT]
                  [(string=? (token-type (first tokens)) SPINE-JOIN) SPINE-JOIN]
                  [else
                    (split-or-join (rest tokens))]))]
    (split-or-join tokens)))

; struct-lon
; Record Record (listof Natural) -> (listof Natural)
; produces the lon for the second record, which follows a spine structure record
; TODO: should be this record, which is AFTER structure

(define (struct-lon previous record prev-lon)
  (local [(define prev-tokens (record-split previous))

          (define (caller tokens)
            (cond [(string=? (split-or-join-record previous) SPINE-SPLIT) (split previous)]
                  [(string=? (split-or-join-record previous) SPINE-JOIN) (join previous)]
                  [else
                    (caller (rest tokens))]))

          (define (split previous)
            ; num-tokens: Natural. Number of tokens w/in a spine processed so far.
            ; num-spine: Natural. Number of tokens in this spine.
            ; prev: (listof Natural). The list of naturals for the previous record.
            ; current: (listof Natural). The list to be returned when no tokens left.
            ;
            (local [(define (split tokens num-tokens num-spine prev current)
                      (cond [(empty? tokens) (reverse current)]
                            [(string=? (token-type (first tokens)) SPINE-SPLIT)
                             
                             (if (= (add1 num-tokens) (first prev))
                                 (split (rest tokens) 0  1 (rest prev) (cons (add1 num-spine) current))
                                 (split (rest tokens) (add1 num-tokens) (add1 num-spine) prev current))]
                            [(= (add1 num-tokens) (first prev))

                             (split (rest tokens) 0 1 (rest prev) (cons num-spine current))]
                            [else
                              (split (rest tokens) (add1 num-tokens) num-spine prev current)]))]
              (split prev-tokens 0  1 prev-lon empty)))

          ; previous should only have one join
          ; TODO: preprocessor
          (define (join previous)
            ; num-tokens: Natural. Number of tokens w/in a spine processed so far.
            ; num-spine: Natural. Number of tokens in this spine.
            ; prev: (listof Natural). The list of naturals for the previous record.
            ; current: (list of Natural). The list to be returned when no tokens left.
            ;
            (local [(define (join tokens num-tokens num-spine prev current)
                      (cond [(empty? tokens) (reverse current)]
                            [(string=? (token-type (first tokens)) SPINE-JOIN)

                             (if (= (+ 2 num-tokens) (first prev))
                                 (join (shift (rest tokens)) 0 1 (rest prev) (cons num-spine current))
                                 (join (shift (rest tokens)) (+ 2 num-tokens) (add1 num-spine) prev current))]
                            [(= (add1 num-tokens) (first prev))

                             (join (rest tokens) 0 1 (rest prev) (cons num-spine current))]
                            [else
                              (join (rest tokens) (add1 num-tokens) (add1 num-spine) prev current)]))]
              (join prev-tokens 0 1 prev-lon empty)))]
    (caller prev-tokens)))

; one-per-spine
; Natural -> (listof Natural)
; produces a list of 1s, with length of the global number of spines

(define (one-per-spine number-global-spines)
  (local [(define (one-per-spine counter)
            (cond [(= counter number-global-spines) empty]
                  [else
                    (cons 1 (one-per-spine (add1 counter)))]))]
    (one-per-spine 0)))
