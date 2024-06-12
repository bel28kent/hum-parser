#lang racket

(require "../data-definitions/data-definitions.rkt"
         "../../abstract-fns/functions/functions.rkt"
         test-engine/racket-tests)

(define TEST-TOKEN-1 (make-token "**kern" EXCLUSIVE-INTERPRETATION 3))
(define TEST-TOKEN-2 (make-token "*^"     SPINE-SPLIT 3))
(define TEST-TOKEN-3 (make-token "*v"     SPINE-JOIN 3))
(define TEST-TOKEN-4 (make-token "4a"     SPINE-DATA 3))
(define TEST-RECORD-1 (make-record "**kern" TOKEN (list TEST-TOKEN-1) 3))
(define TEST-RECORD-2 (make-record "*^"     TOKEN (list TEST-TOKEN-2) 3))
(define TEST-RECORD-3 (make-record "*v"     TOKEN (list TEST-TOKEN-3) 3))
(define TEST-RECORD-4 (make-record "4a"     TOKEN (list TEST-TOKEN-4) 3))

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
  (local [(define (iterator records lolon previous)
            (cond [(empty? records) lolon]
                  [else
                    (iterator (rest records)
                              (cons (lon-caller (first records) lolon) lolon)
                              (first records))]))]
    (iterator (rest tokens)
              (one-per-spine (length (first tokens)))
              (first tokens))))

; lon-caller
; Record Record (listof (listof Natural)) -> (listof Natural)
; if first record is spine structure, call struct-lon helper, else call lon helper
(define (lon-caller previous record lolon)
  (cond [(previous-spine-struct? previous) (struct-lon previous record lolon)]
        [else
          (lon record lolon)]))

; previous-spine-struct?
; Record -> Boolean
; produces true if the previous record has a spine-split token or spine-join token
(check-expect (previous-spine-struct? TEST-RECORD-1) #f)
(check-expect (previous-spine-struct? TEST-RECORD-2) #t)
(check-expect (previous-spine-struct? TEST-RECORD-3) #t)
(check-expect (previous-spine-struct? TEST-RECORD-4) #f)

(define (previous-spine-struct? previous)
  (local [(define tokens (record-split previous))

          (define (spine-struct? lot)
            (cond [(empty? lot) #f]
                  [(not (false? (split-or-join (first lot)))) #t]
                  [else
                    (spine-struct? (rest lot))]))]
    (spine-struct? tokens)))

; split-or-join
; Token -> SpineSplit or SpineJoin or false
; produces type if SpineSplit or SpineJoin, else false
(check-expect (split-or-join TEST-TOKEN-1) #f)
(check-expect (split-or-join TEST-TOKEN-2) SPINE-SPLIT)
(check-expect (split-or-join TEST-TOKEN-3) SPINE-JOIN)
(check-expect (split-or-join TEST-TOKEN-4) #f)

(define (split-or-join token)
  (cond [(string=? (token-type token) SPINE-SPLIT) SPINE-SPLIT]
        [(string=? (token-type token) SPINE-JOIN) SPINE-JOIN]
        [else
          #f]))

; split-or-join-record
; Record -> SpineSplit or SpineJoin or false
; produces type if SpineSplit or SpineJoin, else false

(define (split-or-join-record record)
  (local [(define tokens (record-split record))

          (define (split-or-join tokens)
            (cond [(empty? tokens) #f]
                  [(string=? (token-type (first tokens))) SPINE-SPLIT]
                  [(string=? (token-type (first tokens))) SPINE-JOIN]
                  [else
                    (split-or-join (rest tokens))]))]
    (split-or-join tokens)))

; struct-lon
; Record Record (listof Natural) -> (listof Natural)
; produces the lon for the second record
; TODO: should be this record, which is AFTER structure
(define SPLIT (make-record "*\t*^\t*" TOKEN (list (make-token "*" NULL-INTERPRETATION 3)
                                                  (make-token "*^" SPINE-SPLIT 3)
                                                  (make-token "*" NULL-INTERPRETATION 3))
                                            3))
(define AFTER-SPLIT (make-record "4A\t4a\t4aa\t4aaa" TOKEN (list (make-token "4A" SPINE-DATA 4)
                                                                 (make-token "4a" SPINE-DATA 4)
                                                                 (make-token "4aa" SPINE-DATA 4)
                                                                 (make-token "4aaa" SPINE-DATA 4))
                                                            4))
(check-expect (struct-lon SPLIT AFTER-SPLIT (list 1 1 1)) (list 1 2 1)) ; split case
;(check-expect (struct-lon ) ) ; join case

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
                      (cond [(empty? tokens) current]
                            [(string=? (token-type (first tokens)) SPINE-SPLIT)
                             
                             (if (= (add1 num-tokens) (first prev))
                                 (split (rest tokens) 0  1 (rest prev) (cons (add1 num-spine) current))
                                 (split (rest tokens) (add1 num-tokens) (add1 num-spine) prev current))]
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
                      (cond [(empty? tokens) current]
                            [(string=? (token-type (first tokens)) SPINE-JOIN)

                             (if (= (+ 2 num-tokens) (first prev))
                                 (join (shift (rest tokens)) 0 1 (rest prev) (cons (add1 num-spine) current))
                                 (join (shift (rest tokens)) (+ 2 num-tokens) (add1 (num-spine) prev current)))]
                            [else
                              (join (rest tokens) (add1 num-tokens) num-spine prev current)]))]
              (join prev-tokens 0 1 prev-lon empty)))]
    (caller prev-tokens)))

; lon
; Record (listof (listof Natural)) Natural -> (listof Natural)
; produces the lon for this record, which is not after a structure
(check-expect (lon TEST-RECORD-1 empty 1) (list 1))
(check-expect (lon TEST-RECORD-2 (list (list 1)) 1) (list 1))

(define (lon record lolon number-global-spines)
  (local [(define tokens (record-split record))

          (define (lon lot)
            (cond [(string=? (token-type (first lot)) EXCLUSIVE-INTERPRETATION) (one-per-spine number-global-spines)]
                  [else
                    (copy-previous (sub1 (record-record-number record)) lolon)]))]
    (lon tokens)))

; one-per-spine
; Natural -> (listof Natural)
; produces a list of 1s, with length of the global number of spines
(check-expect (one-per-spine 5) (list 1 1 1 1 1))

(define (one-per-spine number-global-spines)
  (local [(define (one-per-spine counter)
            (cond [(= counter number-global-spines) empty]
                  [else
                    (cons 1 (one-per-spine (add1 counter)))]))]
    (one-per-spine 0)))

; copy-previous
; Natural (listof (listof Natural)) -> (listof Natural)
; copies the previous lon
(check-expect (copy-previous 1 (list (list 1)))
              (list 1))
(check-expect (copy-previous 1 (list (list 1 1 1)
                                     (list 1 2 1)))
              (list 1 2 1))

(define (copy-previous record-number lolon)
  (local [(define (iterator counter lolon)
            (cond [(= counter record-number) (first lolon)]
                  [else
                    (iterator (add1 counter) (rest lolon))]))]
    (if (= 1 (length lolon))
      (first lolon)
      (iterator 0 lolon))))

(test)
