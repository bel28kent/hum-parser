#lang racket/base

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  hum-parser: functions: file
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require racket/list
         racket/local
         "../data-definitions/data-definitions.rkt"
         "predicates.rkt"
         "split-and-gather.rkt"
         "type.rkt")

(provide (all-defined-out))

; read-file
; String -> (listof String)
; produces list of records split into fields from file at path

(define (read-file path)
  (local [(define (read-file lolos in)
            (local [(define next-line (read-line in))]
              (if (eof-object? next-line)
                  (reverse lolos)
                  (read-file (cons next-line lolos) in))))]
  (call-with-input-file path
                        (λ (in) (read-file empty in)))))

; path->hfile
; String -> HumdrumFile
; produces the HumdrumFile at the given path

(define (path->hfile path)
  (local [(define los (read-file path))

          (define (los->lor los record-number)
            (cond [(empty? los) empty]
                  [else
                    (cons (str->record (first los) record-number)
                          (los->lor (rest los) (add1 record-number)))]))

          (define (str->record str record-number)
            (record str
                    (type-record str)
                    (if (or (reference? str) (global-comment? str))
                            (list str)
                            (los->lot (split str) record-number))
                    record-number))

          (define (los->lot los record-number)
            (cond [(empty? los) empty]
                  [else
                    (cons (str->token (first los) record-number)
                          (los->lot (rest los) record-number))]))

          (define (str->token str record-number)
            (token str (type-token str) record-number))]
    (hfile (los->lor los 0))))

; hfile->los
; HumdrumFile -> (listof String)
; produces the unwrapped list of records (strings) from the humdrumfile

(define (hfile->los hfile)
  (local [(define records (hfile-records hfile))]
    (foldr (λ (f r) (cons (record-record f) r)) empty records)))

; write-file
; (listof String) String -> #<void>
; writes list to file at given path

(define (write-file los path)
  (local [(define (write-file los out)
            (foldl (λ (f r) (displayln f out)) (void) los))]
    (call-with-output-file path (λ (out) (write-file los out)))))
