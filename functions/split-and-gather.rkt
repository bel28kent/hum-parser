#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  hum-parser: FUNCTIONS: SPLIT & GATHER
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require "../data-definitions/data-definitions.rkt"
         "../../abstract-fns/functions/functions.rkt")

(provide (all-defined-out))

; split
; String -> (listof String)
; splits the string around SEPARATOR

(define (split string)
  (local [(define (splitter string los)
            (cond [(string=? string "") los]
                  [else
                   (splitter
                    (substring string (pos-after-separator string))
                    (append los (list (next-field string))))]))

          ;; pos-after-separator
          ;; String -> Integer
          ;; produces the index of the character after the first instance of SEPARATOR in string
          (define (pos-after-separator string)
            (local [(define (pos string position)
                      (cond [(string=? string "") position]
                            [(string=? (substring string 0 1) SEPARATOR) (+ 1 position)]
                            [else
                             (pos (substring string 1) (+ 1 position))]))]
              (pos string 0)))

          ;; next-field
          ;; String -> String
          ;; produce the substring of string from the first character up to SEPARATOR
          (define (next-field string)
            (cond [(string=? string "") string]
                  [else
                   (if (string=? (substring string 0 1) SEPARATOR)
                       ""
                       (string-append (substring string 0 1) (next-field (substring string 1))))]))]
    (splitter string empty)))

; TODO
; gather
; (listof String) -> String
; concatenates each of los together, separated by SEPARATOR

(define (gather los) empty)
