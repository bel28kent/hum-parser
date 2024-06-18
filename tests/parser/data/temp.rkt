#lang racket

(require "../../data-definitions/data-definitions.rkt"
         test-engine/racket-tests)

(define (tokens-by-spine unwrapped byspine)
    (lolo-iterator unwrapped byspine))

(define-struct acc (spine-list remaining) #:transparent)

(check-expect (lolo-iterator (list (list (make-token "**kern" "ExclusiveInterpretation" 0)))
                             (list (list 1)))
              (list (list (list (make-token "**kern" "ExclusiveInterpretation" 0)))))
; (listof (listof Token)) (listof (listof Natural)) -> (listof (listof (listof Token)))
(define (lolo-iterator lolot lolon)
  ; spine-list: (listof (listof Token)). Accumulates the output of lon-iterator calls.
  ;
  (local [(define (lolo-iterator lolot lolon spine-list counter)
            (cond [(andmap empty? lolot) (reverse spine-list)]
                  [(or (empty? lolot) (empty? lolon)) (if (empty? lolot)
                                                          (error (string-append "lolot is empty but not lolon; recursion depth: " (number->string counter)))
                                                          (error (string-append "lolon is empty but not lolot; recursion depth: " (number->string counter))))]
                  [else
                    (local [(define output (lon-iterator lolot (first lolon)))]
                      (lolo-iterator (acc-remaining output)
                                     (rest lolon)
                                     (cons (acc-spine-list output) spine-list)
                                     (add1 counter)))]))]
    (lolo-iterator lolot lolon empty 1)))

(check-expect (lon-iterator (list (list (make-token "**kern" "ExclusiveInterpretation" 0)))
                            (list 1))
              (make-acc (list (list (make-token "**kern" "ExclusiveInterpretation" 0)))
                        (list empty)))
(check-expect (lon-iterator (list (list (make-token "**kern" "ExclusiveInterpretation" 0)
                                        (make-token "**kern" "ExclusiveInterpretation" 0)))
                            (list 1))
              (make-acc (list (list (make-token "**kern" "ExclusiveInterpretation" 0)))
                        (list (list (make-token "**kern" "ExclusiveInterpretation" 0)))))
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

(check-expect (lot-iterator (list (make-token "**kern" "ExclusiveInterpretation" 0)) 1)
              (make-acc (list (make-token "**kern" "ExclusiveInterpretation" 0)) empty))
(check-expect (lot-iterator (list (make-token "**kern" "ExclusiveInterpretation" 0)
                                  (make-token "**kern" "ExclusiveInterpretation" 0))
                            1)
              (make-acc (list (make-token "**kern" "ExclusiveInterpretation" 0))
                        (list (make-token "**kern" "ExclusiveInterpretation" 0))))
; (listof Token) Natural -> acc
(define (lot-iterator lot number-tokens)
  ; counter: Natural. Number of tokens added to accumulator.
  ; spine-list: (listof Token). List of tokens accumulated so far.
  ;
  (local [(define (lot-iterator lot counter spine-list)
            (cond [(= number-tokens counter) (make-acc (reverse spine-list) lot)]
                  [else
                    (lot-iterator (rest lot) (add1 counter) (cons (first lot) spine-list))]))]
    (lot-iterator (rest lot) 1 (list (first lot)))))

(test)
