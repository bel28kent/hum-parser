#lang racket

(require "../data-definitions/data-definitions.rkt"
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
