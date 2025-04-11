#lang racket/base

#|
	Spine parsing functions.
|#

(require racket/list
         racket/local
         "ExclusiveInterpretation.rtk"
         "HumdrumSyntax.rkt"
         "TandemInterpretation.rkt"
         "abstract-fn.rkt"
         "string-fn.rkt")

(provide (all-defined-out))

; HumdrumFile -> (listof GlobalSpine)
; produces a list of global spines from the HumdrumFile

(define (spine-parser hfile)
  (local [(define spine-arity (extract-spine-arity hfile))]
    (lololot->logs (tokens-by-spine (unwrap hfile)
                                    (byrecord->byspine spine-arity)))))

; unwrap
; HumdrumFile -> (listof (listof Token))
; produces the list of each record's list of tokens

(define (unwrap hfile)
  (local [(define records (hfile-records hfile))

          (define token-records (filter (λ (r) (or (string=? TOKEN (record-type r))
                                                   (string=? LOCAL-COMMENT (record-type r))))
                                        records))]
    (foldr (λ (f r) (cons (record-split f) r)) empty token-records)))

; byrecord->byspine
; SpineArity -> (listof (listof Natural))
; produces lolon of spine arity, but numbers grouped by spine instead of record

(define (byrecord->byspine spine-arity)
  (local [(define number-global-spines (spine-arity-global spine-arity))

          (struct acc (spine-list remaining))

          ; (listof (listof Natural)) -> (listof (listof Natural))
          (define (spine-iterator lolon)
            ; num-spine: Natural. Number of spines processed so far.
            ; spine-lists: lolon. list of spine-list fields from byspine
            ;
            (local [(define (iterator num-spine spine-lists acc)
                      (cond [(= num-spine number-global-spines)
                             (reverse (cons (acc-spine-list acc) spine-lists))]
                            [else
                             (iterator (add1 num-spine)
                                       (cons (acc-spine-list acc) spine-lists)
                                       (byspine (acc-remaining acc)))]))]
              (local [(define first-spine (byspine lolon))]
                (iterator 1 empty (acc (acc-spine-list first-spine)
                                       (acc-remaining  first-spine))))))

          ; (listof (listof Natural)) -> acc
          (define (byspine lolon)
            ; spine-list: (listof Natural). list of number tokens for a spine.
            ; remaining: (listof (listof Natural)). remaining spine numbers.
            ;
            (local [(define (iterator arity spine-list remaining)
                      (cond [(empty? arity) (acc (reverse spine-list)
                                                 (reverse remaining))]
                            [else
                             (iterator (rest arity)
                                       (cons (first (first arity))
                                             spine-list)
                                       (cons (rest (first arity))
                                             remaining))]))]
              (iterator lolon empty empty)))]
    (spine-iterator (spine-arity-lolon spine-arity))))

; tokens-by-spine
; (listof (listof Token)) (listof (listof Natural)) ->
; (listof (listof (listof Token)))
; produces the list of lot, separated by spine.

(define (tokens-by-spine unwrapped byspine)
  (local [(struct acc (spine-list remaining))

          ; (listof (listof Token)) (listof (listof Natural)) ->
          ; (listof (listof (listof Token)))
          (define (lolo-iterator lolot lolon)
            ; spine-list: (listof (listof Token)). Output of lon-iterator calls.
            ;
            (local [(define (lolo-iterator lolot lolon spine-list)
                      (cond [(andmap empty? lolot) (reverse spine-list)]
                            [else
                             (local [(define output
                                       (lon-iterator lolot
                                                     (first lolon)))]
                               (lolo-iterator (acc-remaining output)
                                              (rest lolon)
                                              (cons (acc-spine-list output)
                                                    spine-list)))]))]
              (lolo-iterator lolot lolon empty)))

          ; (listof (listof Token)) (listof Natural) -> acc
          (define (lon-iterator lolot lon)
            ; spine-list: (listof (listof Token)). Output of lot-iterator calls.
            ; remaining-acc: (listof (listof Token)). Remaining tokens.
            ;
            (local [(define (lon-iterator lolot lon spine-list remaining-acc)
                      (cond [(empty? lolot) (acc (reverse spine-list)
                                                 (reverse remaining-acc))]
                            [else
                             (local [(define output
                                       (lot-iterator (first lolot)
                                                     (first lon)))]
                               (lon-iterator (rest lolot)
                                             (rest lon)
                                             (cons (acc-spine-list output)
                                                   spine-list)
                                             (cons (acc-remaining output)
                                                   remaining-acc)))]))]
              (lon-iterator lolot lon empty empty)))

          ; (listof Token) Natural -> acc
          (define (lot-iterator lot number-tokens)
            ; counter: Natural. Number of tokens added to accumulator.
            ; spine-list: (listof Token). List of tokens accumulated so far.
            ;
            (local [(define (lot-iterator lot counter spine-list)
                      (cond [(= number-tokens counter) (acc (reverse spine-list)
                                                            lot)]
                            [else
                             (lot-iterator (rest lot)
                                           (add1 counter)
                                           (cons (first lot) spine-list))]))]
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
                                  (cons (global-spine
                                          (type-spine (first lololot))
                                          (first lololot)
                                          counter)
                                        logs)
                                  (add1 counter))]))]
    (lololot->logs lololot empty 0)))

; logs->lolos
; (listof GlobalSpine) -> (listof (listof String))
; Converts each GlobalSpine to a (listof String)

(define (logs->lolos logs)
  (local [(define (logs-iterator logs)
            ; lolos: (listof (listof String)). los for each global spine.
            ;
            (local [(define (logs-iterator logs lolos)
                      (cond [(empty? logs) (reverse lolos)]
                            [else
                             (logs-iterator (rest logs)
                                            (cons (gs->los (first logs))
                                                  lolos))]))]
              (logs-iterator logs empty)))

          (define (gs->los gs)
            (local [(define lolot (global-spine-tokens gs))

                    (define (lolot-iterator lolot)
                      (local [(define (lolot-iterator lolot los)
                                ; los: (listof String). list of strings so far.
                                ;
                                (cond [(empty? lolot) (reverse los)]
                                      [else
                                       (lolot-iterator (rest lolot)
                                                       (cons (gather (map token-token (first lolot)))
                                                             los))]))]
                        (lolot-iterator lolot empty)))]
              (lolot-iterator lolot)))]
    (logs-iterator logs)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hum-parser: functions: extract-spine-arity
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require racket/bool
         racket/list
         racket/local
         "../data-definitions/data-definitions.rkt"
         "abstract-fn.rkt")

(provide (all-defined-out))

; BASE CASE:  a list of only one record, the exclusive interpretation record
; ASSUMPTION: the first record must be the exclusive interpretation record,
;             otherwise is humdrum syntax error

; extract-spine-arity
; HumdrumFile -> SpineArity
; produces the spine arity from a list of token records

(define (extract-spine-arity hfile)
  (local [(define token-records (filter (λ (r) (or (string=? TOKEN (record-type r))
                                                   (string=? LOCAL-COMMENT (record-type r))))
                                        (hfile-records hfile)))]
    (spine-arity (length (record-split (first token-records)))
                 (lolon token-records))))

; lolon
; (listof Record) -> (listof (listof Natural))
; produces the lolon field of the spine arity struct

(define (lolon records)
  (local [(define (iterator records lolon previous)
            (cond [(empty? records) (reverse lolon)]
                  [else
                   (iterator (rest records)
                             (cons (lon-caller previous (first lolon)) lolon)
                             (first records))]))]
    (if (= (length records) 1)
        (list (one-per-spine (length (record-split (first records)))))
        (iterator (rest records)
                  (list (one-per-spine (length (record-split (first records)))))
                  (first records)))))

; lon-caller
; Record (listof Natural) -> (listof Natural)
; if record is spine structure, call struct-lon helper, else return previous lon

(define (lon-caller previous prev-lon)
  (cond [(previous-spine-struct? previous) (struct-lon previous prev-lon)]
        [else
         prev-lon]))

; previous-spine-struct?
; Record -> Boolean
; produces true if previous record has a spine-split token or spine-join token

(define (previous-spine-struct? previous)
  (local [(define tokens (record-split previous))

          (define (spine-struct? lot)
            (cond [(empty? lot) #f]
                  [(not (false? (split-or-join-token? (first lot)))) #t]
                  [else
                   (spine-struct? (rest lot))]))]
    (spine-struct? tokens)))

; split-or-join-token?
; Token -> Boolean
; produces true if type of token is SpineSplit or SpineJoin

(define (split-or-join-token? token)
  (local [(define type (token-type token))]
    (and (string? type)
         (or (string=? type SPINE-SPLIT)
             (string=? type SPINE-JOIN)))))

; struct-lon
; Record (listof Natural) -> (listof Natural)
; produces the lon for the next record, which follows the given record

(define (struct-lon previous prev-lon)
  (local [(define prev-tokens (record-split previous))

          (define (get-num-joins tokens)
            (cond [(empty? tokens) 0]
                  [(not (string=? (token-type (first tokens)) SPINE-JOIN)) 0]
                  [else
                   (add1 (get-num-joins (rest tokens)))]))

          (define (remove-joins tokens num-joins)
            (local [(define (remove-joins lot counter)
                      (cond [(= counter num-joins) lot]
                            [else
                              (remove-joins (rest lot) (add1 counter))]))]
              (remove-joins tokens 0)))

          (define (next-lon previous)
            ; num-tokens: Natural. Number tokens w/in a spine processed so far.
            ; num-spine: Natural. Number tokens in this spine.
            ; prev: (listof Natural). List of naturals for the previous record.
            ; current: (listof Natural). List returned when no tokens left.
            ;
            (local [(define (next-lon tokens num-tokens num-spine prev current)
                      (cond [(empty? tokens) (reverse current)]
                            [(string=? (token-type (first tokens)) SPINE-SPLIT)
                             (if (= (add1 num-tokens) (first prev))
                                 (next-lon (rest tokens)
                                           0 0
                                           (rest prev)
                                           (cons (+ 2 num-spine) current))
                                 (next-lon (rest tokens)
                                           (add1 num-tokens)
                                           (+ 2 num-spine)
                                           prev
                                           current))]
                            [(string=? (token-type (first tokens)) SPINE-JOIN)
                             (local [(define num-joins (get-num-joins tokens))
                                     (define joins-removed (remove-joins tokens num-joins))]
                               (if (= (+ num-joins num-tokens) (first prev))
                                   (next-lon joins-removed
                                             0 0
                                             (rest prev)
                                             (cons (add1 num-spine) current))
                                   (next-lon joins-removed
                                             (+ num-joins num-tokens)
                                             (add1 num-spine)
                                             prev
                                             current)))]
                            [(= (add1 num-tokens) (first prev))
                             (next-lon (rest tokens)
                                       0 0
                                       (rest prev)
                                       (cons (add1 num-spine) current))]
                            [else
                             (next-lon (rest tokens)
                                       (add1 num-tokens)
                                       (add1 num-spine)
                                       prev
                                       current)]))]
              (next-lon prev-tokens 0 0 prev-lon empty)))]
    (next-lon prev-tokens)))

; one-per-spine
; Natural -> (listof Natural)
; produces a list of 1s, with length of the global number of spines

(define (one-per-spine number-global-spines)
  (local [(define (one-per-spine counter)
            (cond [(= counter number-global-spines) empty]
                  [else
                   (cons 1 (one-per-spine (add1 counter)))]))]
    (one-per-spine 0)))
