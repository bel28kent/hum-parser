#lang racket/base

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
