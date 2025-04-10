#lang racket/base

#|
	String functions.
|#

(require racket/list
         racket/local
         "../data-definitions/data-definitions.rkt")

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
          ;; produces index of character after first instance of SEPARATOR
          (define (pos-after-separator string)
            (local [(define (pos string position)
                      (cond [(string=? string "") position]
                            [(string=? (substring string 0 1) SEPARATOR)
                             (+ 1 position)]
                            [else
                             (pos (substring string 1) (+ 1 position))]))]
              (pos string 0)))

          ;; next-field
          ;; String -> String
          ;; produces substring of string from first character up to SEPARATOR
          (define (next-field string)
            (cond [(string=? string "") string]
                  [(string=? (substring string 0 1) SEPARATOR) ""]
                  [else
                    (string-append (substring string 0 1)
                                   (next-field (substring string 1)))]))]
    (splitter string empty)))

; gather
; (listof String) -> String
; concatenates each of los together, separated by SEPARATOR

(define (gather los)
  (cond [(empty? los) ""]
        [(empty? (rest los)) (string-append (first los) (gather (rest los)))]
        [else
          (string-append (first los) SEPARATOR (gather (rest los)))]))
