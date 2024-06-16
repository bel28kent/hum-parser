#lang racket

(require "../data-definitions/data-definitions.rkt"
         "../functions/abstract.rkt"
         test-engine/racket-tests)

(provide (all-defined-out))

; TODO: spine-parser
; HumdrumFile SpineArity -> (listof GlobalSpine)
; produces a list of global spines from the HumdrumFile

(define (spine-parser hfile spine-arity) (void))

; 0. Unwrap tokens from records to create (listof (listof Token))
; 1. For each global spine, make a lon from spine-arity for that spine:
;        (spine-arity 2 (list (list 1 2)
;                             (list 1 2))
;    Becomes:
;        (list (list 1 1)
;              (list 2 2))
; 2. a. For each new lon, take off the first number.
;    b. Until a counter eq the first, copy first of lot off first record on to an accumulator
;    c. Once counter eq the first, put the rest of lot on to an accumulator for the next spine
;    d. Recurse with the rest of lon and rest of lolot
; 3. With accumulator of 2b, make-global-spine for each lot

; unwrap
; HumdrumFile -> (listof (listof Token))
; produces the list of each record's list of tokens

(define (unwrap hfile)
  (local [(define records (hfile-records hfile))

          (define token-records (filter-type record-type TOKEN records))]
    (foldr (λ (f r) (cons (record-split f) r)) empty token-records)))

; byrecord->byspine
; SpineArity -> (listof (listof Natural))
; produces the lolon of the spine arity, but numbers grouped by spine instead of record

(define (byrecord->byspine spine-arity)
  (local [(define number-global-spines (spine-arity-global spine-arity))

          (define-struct acc (spine-list remaining))

          ; (listof (listof Natural)) -> (listof (listof Natural))
          (define (spine-iterator lolon)
            ; num-spine: Natural. Number of spines processed so far.
            ; spine-lists: (listof (listof Natural)). list of spine-list fields from byspine
            ;
            (local [(define (iterator num-spine spine-lists acc)
                      (cond [(= num-spine number-global-spines) (reverse (cons (acc-spine-list acc) spine-lists))]
                            [else
                              (iterator (add1 num-spine)
                                        (cons (acc-spine-list acc) spine-lists)
                                        (byspine (acc-remaining acc)))]))]
              (local [(define first-spine (byspine lolon))]
                (iterator 1 empty (make-acc (acc-spine-list first-spine)
                                            (acc-remaining  first-spine))))))

          ; (listof (listof Natural)) -> acc
          (define (byspine lolon)
            ; spine-list: (listof Natural). list of number of tokens for a spine.
            ; remaining: (listof (listof Natural)). list of remaining spine numbers.
            ;
            (local [(define (iterator arity spine-list remaining)
                      (cond [(empty? arity) (make-acc (reverse spine-list) (reverse remaining))]
                            [else
                              (iterator (rest arity)
                                        (cons (first (first arity)) spine-list)
                                        (cons (rest (first arity)) remaining))]))]
              (iterator lolon empty empty)))]
    (spine-iterator (spine-arity-lolon spine-arity))))

; tokens-by-spine
; (listof (listof Token)) (listof (listof Natural)) -> (listof (listof (listof Token)))
; produces the list of lot, separated by spine.

(define (tokens-by-spine unwrapped byspine)
  (local [(define-struct acc (spine-list remaining))

          ; (listof (listof Token)) (listof (listof Natural)) -> (listof (listof (listof Token)))
          (define (lolo-iterator lolot lolon)
            ; spine-list: (listof (listof Token)). Accumulates the output of lon-iterator calls.
            ;
            (local [(define (lolo-iterator lolot lolon spine-list)
                      (cond [(andmap empty? lolot) (reverse spine-list)]
                            [else
                              (local [(define output (lon-iterator lolot (first lolon)))]
                                (lolo-iterator (acc-remaining output)
                                               (rest lolon)
                                               (cons (acc-spine-list output) spine-list)))]))]
              (lolo-iterator lolot lolon empty)))

          ; (listof (listof Token)) (listof Natural) -> acc
          (define (lon-iterator lolot lon)
            ; spine-list: (listof (listof Token)). Accumulates output of lot-iterator calls.
            ; remaining-acc: (listof (listof Token)). Accumulates the remaining tokens after lot-iterator calls.
            ;
            (local [(define (lon-iterator lolot lon spine-list remaining-acc)
                      (cond [(empty? lolot) (make-acc (reverse spine-list) (reverse remaining-acc))]
                            [else
                              (local [(define output (lot-iterator (first lolot) (first lon)))]
                                (lon-iterator (rest lolot)
                                              (rest lon)
                                              (cons (acc-spine-list output) spine-list)
                                              (cons (acc-remaining output) remaining-acc)))]))]
              (lon-iterator lolot lon empty empty)))

          ; (listof Token) Natural -> acc
          (define (lot-iterator lot number-tokens)
            ; counter: Natural. Number of tokens added to accumulator.
            ; spine-list: (listof Token). List of tokens accumulated so far.
            ;
            (local [(define (lot-iterator lot counter spine-list)
                      (cond [(= number-tokens counter) (make-acc (reverse spine-list) lot)]
                            [else
                              (lot-iterator (rest lot) (add1 counter) (cons (first lot) spine-list))]))]
              (lot-iterator (rest lot) 1 (list (first lot)))))]
    (lolo-iterator unwrapped byspine)))












































