#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  hum-parser: FUNCTIONS: ABSTRACT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require "../data-definitions/data-definitions.rkt"
         "../../abstract-fns/functions/functions.rkt")

(provide (all-defined-out))

; tag=?
; String Natural String -> Boolean 
; produce true if first string starts with second string

(define (tag=? string upto constant)
  (and (>= (string-length string) upto)
       (string=? (substring string 0 upto) constant)))

; filter-type
; proc String (listof X) -> (listof X)
; produces listof X whose type matches String
; CONSTRAINT: proc is a selector that selects the type field of X

(define (filter-type proc str lox)
  (local [(define (is-type x)
            (string=? (proc x) str))]
    (filter is-type lox)))
