#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  hum-parser: functions: abstract
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require "../data-definitions/data-definitions.rkt")

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

; shift
; (listof X) -> (listof X)
; Removes the first element and produces the resultant list

(define (shift lox)
  (cond [(empty? lox) empty]
        [else
          (rest lox)]))

; valmap
; X (listof proc) -> (listof Y)
; produce the list of results of calling each procedure on X
; CONSTRAINT: X is a valid parameter type to each procedure

(define (valmap val lop)
  (local [(define (valmap lop)
            (cond [(empty? lop) empty]
                  [else
                    (cons ((first lop) val) (valmap (rest lop)))]))]
    (valmap lop)))

; true?
; Boolean -> Boolean
; produce true if true

(define (true? bool)
  (not (false? bool)))
