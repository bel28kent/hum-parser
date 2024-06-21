#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  hum-parser: functions: file
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require "../data-definitions/data-definitions.rkt"
         "predicates.rkt"
         "split-and-gather.rkt"
         "type.rkt"
         "../../../abstract-fns/functions/functions.rkt")

(provide (all-defined-out))

; read-file
; String -> (listof String)
; reads in a file at given path and produces a list of its records split into fields

(define (read-file path)
  (local [(define (read-file lolos in)
            (local [(define next-line (read-line in))]
              (if (eof-object? next-line)
                  (reverse lolos)
                  (read-file (cons next-line lolos) in))))]
  (call-with-input-file path
                        (λ (in) (read-file empty in)))))

; los->hfile
; (listof String) -> HumdrumFile
; produces the given los as a HumdrumFile

(define (los->hfile los)
  (local [(define (los->lor los record-number)
            (cond [(empty? los) empty]
                  [else
                    (cons (str->record (first los) record-number)
                          (los->lor (rest los) (add1 record-number)))]))

          (define (str->record str record-number)
            (make-record str
                         (type-record str)
                         (if (metadata? str)
                             (list str)
                             (los->lot (split str) record-number))
                         record-number))

          (define (los->lot los record-number)
            (cond [(empty? los) empty]
                  [else
                    (cons (str->token (first los) record-number)
                          (los->lot (rest los) record-number))]))

          (define (str->token str record-number)
            (make-token str (type-token str) record-number))]
    (make-hfile (los->lor los 0))))

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
