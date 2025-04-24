#lang racket

#|
	Tests for abstract functions.
|#

(require "../../parser/abstract-fn.rkt"
         "../../parser/HumdrumSyntax.rkt"
         test-engine/racket-tests
         (only-in rackunit check-exn))

(define KernRecord
        (record "**kern\t**dynam"
                'ExclusiveInterpretation
                (list (token "**kern" 'ExclusiveInterpretation 0 0)
                      (token "**dynam" 'ExclusiveInterpretation 0 1))
                0))
(define TokenRecord
        (record "4a\tpp"
                'Token
                (list (token "4a" 'SpineData 1 0)
                      (token "pp" 'SpineData 1 1))
                1))
(define SpineTerminatorRecord
        (record "*-\t*-"
                'TandemInterpretation
                (list (token "*-" 'SpineTerminator 2 0)
                      (token "*-" 'SpineTerminator 2 1))
                2))
(define TestingListOfStruct (list KernRecord TokenRecord SpineTerminatorRecord))

(define TestingTypeHash (hash 'Letter "[a-zA-Z]"
                              'Number "\\d"))

; filter-type
(check-expect (filter-type record-type 'ExclusiveInterpretation TestingListOfStruct) (list KernRecord))
(check-expect (filter-type record-type 'Token TestingListOfStruct) (list TokenRecord))
(check-expect (filter-type record-type 'TandemInterpretation TestingListOfStruct) (list SpineTerminatorRecord))
(check-expect (filter-type record-type 'Measure TestingListOfStruct) empty)

; hash-match?
(check-expect (hash-match? TestingTypeHash 'Letter "a") #t)
(check-expect (hash-match? TestingTypeHash 'Number "1") #t)
(check-expect (hash-match? TestingTypeHash 'Letter "1") #f)
(check-expect (hash-match? TestingTypeHash 'Number "a") #f)

; hash-member?
(check-expect (hash-member? TestingTypeHash "a") #t)
(check-expect (hash-member? TestingTypeHash "1") #t)
(check-expect (hash-member? TestingTypeHash "_") #f)

; get-type
(check-expect (get-type "a" TestingTypeHash 'Unknown) 'Letter)
(check-expect (get-type "1" TestingTypeHash 'Unknown) 'Number)
(check-expect (get-type "_" TestingTypeHash 'Unknown) 'Unknown)
(check-exn #rx"syntax-error: could not match a"
           (λ ()
              (get-type "!" TestingTypeHash 'error)))

(test)
