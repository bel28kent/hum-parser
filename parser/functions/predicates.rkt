#lang racket/base

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  hum-parser: functions: predicates
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require racket/bool
         racket/list
         racket/local
         "../data-definitions/data-definitions.rkt"
         "abstract.rkt")

(provide (all-defined-out))

; reference?
; String -> Boolean
; produce true if string starts with REFERENCE-TAG

(define (reference? string)
  (tag=? string 3 REFERENCE-TAG))

; global-comment?
; String -> Boolean
; produce true if string starts with GLOBAL-COMMENT-TAG

(define (global-comment? string)
  (and (tag=? string 2 GLOBAL-TAG)
       (not (reference? string))))

; local-comment?
; String -> Boolean
; produce true if string starts with LOCAL-COMMENT-TAG

(define (local-comment? string)
  (and (tag=? string 1 LOCAL-TAG)
       (andmap not (valmap string (list reference? global-comment?)))))

; metadata?
; String -> Boolean
; produce true if string is a type of metadata

(define (metadata? string)
  (ormap true?
         (valmap string (list reference? global-comment? local-comment?))))

; exclusive-interpretation?
; String -> Boolean
; produce true if string starts with EXCLUSIVE-TAG

(define (exclusive-interpretation? token)
  (tag=? token 2 EXCLUSIVE-TAG))

; tandem-interpretation?
; String -> Boolean
; produce true if string starts with TANDEM-TAG

(define (tandem-interpretation? token)
  (and (tag=? token 1 TANDEM-TAG)
       (> (string-length token) 1)
       (not (exclusive-interpretation? token))))

; null-interpretation?
; String -> Boolean
; produce true if string exactly matches TANDEM-TAG

(define (null-interpretation? token)
  (and (tag=? token 1 TANDEM-TAG)
       (= 1 (string-length token))))

; interpretation?
; String -> Boolean
; produce true if string is exclusive or tandem interpretation

(define (interpretation? token)
  (ormap true? (valmap token (list exclusive-interpretation?
                                   tandem-interpretation?
                                   null-interpretation?))))

; spine-split?
; String -> Boolean
; produce true if string equals SPLIT-TOKEN

(define (spine-split? token)
  (string=? token SPLIT-TOKEN))

; spine-join?
; String -> Boolean
; produce true if string equals JOIN-TOKEN

(define (spine-join? token)
  (string=? token JOIN-TOKEN))

; spine-terminator?
; String -> Boolean
; produce true if string equals TERMINATOR

(define (spine-terminator? token)
  (string=? token TERMINATOR))

; spine-structure?
; String -> Boolean
; produce true if string is spine split, spine join, or terminator

(define (spine-structure? token)
  (ormap true?
         (valmap token (list spine-split? spine-join? spine-terminator?))))

; measure?
; String -> Boolean
; produce true if string starts with MEASURE-TAG

(define (measure? token)
  (tag=? token 1 MEASURE-TAG))

; clef?
; String -> Boolean
; produce true if string starts with "*clef"

(define (clef? token)
  (not (false? (regexp-match #px"\\*clef" token))))

; time-sig?
; String -> Boolean
; produce true if string starts with "*M" or *met"

(define (time-sig? token)
  (not (false? (regexp-match #px"\\*(M|met)" token))))

; key-sig?
; String -> Boolean
; produce true if string matches "\\*k\\[.*\\]"

(define (key-sig? token)
  (not (false? (regexp-match #px"\\*k\\[.*\\]" token))))

; key-label?
; String -> Boolean
; produce true if string matches "\\*[a-gA-G](-|#)?:"

(define (key-label? token)
  (local [(define matches (regexp-match* #px"\\*([a-gA-G]|X)(-|#)?:" token))]
    (not (empty? matches))))

; staff-number?
; String -> Boolean
; produce true if string matches "\\*staff[0-9]+"

(define (staff-number? token)
  (not (false? (regexp-match #px"\\*staff[0-9]+" token))))

; instrument-class?
; String -> Boolean
; produce true if string matches "\\*I[[:alpha:]]+"

(define (instrument-class? token)
  (not (false? (regexp-match #px"\\*I[[:alpha:]]+" token))))

; spine-data?
; String -> Boolean
; produce true if string is not METADATA and is not another TOKEN type

(define (spine-data? token)
  (andmap not
          (valmap token (list metadata?
                              interpretation?
                              spine-structure?
                              measure?
                              null-spine-data?))))

; null-spine-data?
; String -> Boolean
; produce true if string equals "."

(define (null-spine-data? token)
  (string=? "." token))

; local-comment-token?
; String -> Boolean
; produce true if string starts with "!"

(define (local-comment-token? token)
  (not (false? (regexp-match #px"!.*" token))))
