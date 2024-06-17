#lang racket

(require "../data-definitions/data-definitions.rkt"
         "../functions/abstract.rkt"
         test-engine/racket-tests)

(provide (all-defined-out))

; TODO: spine-parser
; HumdrumFile SpineArity -> (listof GlobalSpine)
; produces a list of global spines from the HumdrumFile

(define (spine-parser hfile spine-arity) (void))

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

; lololot->logs
; (listof (listof (listof Token))) -> (listof GlobalSpine)
; produces a list of global spines

(define (lololot->logs lololot)
  ; logs: (listof GlobalSpine). list of accumulated global spines
  ;
  (local [(define (lololot->logs lololot logs counter)
            (cond [(empty? lololot) (reverse logs)]
                  [else
                    (lololot->logs (rest lololot)
                                   (cons (make-global-spine (first lololot) counter) logs)
                                   (add1 counter))]))]
    (lololot->logs lololot empty 0)))

; logs->lolos
; (listof GlobalSpine) -> (listof (listof String))
; Converts each GlobalSpine to a (listof String)

(define (logs->lolos logs)
  (local [(define (logs-iterator logs)
            ; lolos: (listof (listof String)). Accumulates los for each global spine.
            ;
            (local [(define (logs-iterator logs lolos)
                      (cond [(empty? logs) (reverse lolos)]
                            [else
                              (logs-iterator (rest logs)
                                             (cons (gs->los (first logs)) lolos))]))]
              (logs-iterator logs empty)))

          (define (gs->los gs)
            (local [(define lolot (global-spine-tokens gs))

                    (define (lolot-iterator lolot)
                      (local [(define (lolot-iterator lolot los)
                                ; los: (listof String). list of strings accumulated so far.
                                ;
                                (cond [(empty? lolot) (reverse los)]
                                      [else
                                        (lolot-iterator (rest lolot)
                                                        (cons (lot->s (first lolot)) los))]))]
                        (lolot-iterator lolot empty)))

                    (define (lot->s lot)
                      (cond [(empty? lot) ""]
                            [else
                              (if (empty? (rest lot))
                                  (string-append (token-token (first lot)) (lot->s (rest lot)))
                                  (string-append (token-token (first lot)) "\t" (lot->s (rest lot))))]))]
              (lolot-iterator lolot)))]
    (logs-iterator logs)))






































