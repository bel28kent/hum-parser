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

; write-file
; (listof String) String -> #<void>
; writes list to file at given path

(define (write-file los path)
  (local [(define (write-file los out)
            (foldl (λ (f r) (displayln f out)) (void) los))]
    (call-with-output-file path (λ (out) (write-file los out)))))

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
            (local [(define (los->lot los field-index)
                      (cond [(empty? los) empty]
                            [else
                             (cons (str->token (first los) record-number field-index)
                                   (los->lot (rest los) (add1 field-index)))]))]
              (los->lot los 0)))

          (define (str->token str record-number field-index)
            (token str (type-token str) record-number field-index))]
    (hfile (los->lor los 0))))

; hfile->los
; HumdrumFile -> (listof String)
; produces the unwrapped list of records (strings) from the humdrumfile

(define (hfile->los hfile)
  (local [(define records (hfile-records hfile))]
    (foldr (λ (f r) (cons (record-record f) r)) empty records)))

; hfile-hash-join
; HumdrumFile HumdrumFile -> HumdrumFile
; produces a composite of the two HumdrumFiles
; CONSTRAINT: Assumes that composite will have the dimensions as the output of path->hfile

(define (hfile-hash-join pre-hfile post-hfile)
  (local [(define pre (hfile-records pre-hfile))
          (define post (hfile-records post-hfile))

          (define (not-token-record r)
            (cond [(string=? TOKEN (record-type r))
                   (raise-argument-error 'hfile-hash-join "not a token record" 0 r)]))

          (define (token-record r)
            (cond [(not (string=? TOKEN (record-type r)))
                   (raise-argument-error 'hfile-hash-join "token record" 1 r)]))

          (define (hash-join records)
            (local [(define records-hash (apply hash
                                                (foldr (λ (f rnr) (cons (record-record-number f)
                                                                    (cons f rnr)))
                                                       empty
                                                       records)))]
              (build-list (length records) (λ (n) (hash-ref records-hash n)))))]
    (begin (for-each not-token-record pre)
           (for-each token-record post)
           (hfile (hash-join (append pre post))))))

; build-filenames
; String String Natural -> (listof String)
; produces a list of numbered filenames

(define (build-filenames start extension number)
  (local [(define number-str-length (string-length
                                      (number->string number)))

          (define (strings->filename n)
            (string-append start
                           (match-number-str-length
                             (number->string (add1 n)))
                           extension))

          (define (match-number-str-length str)
            (local [(define str-length (string-length str))]
              (if (= number-str-length str-length)
                  str
                  (string-append (zeros (- number-str-length
                                           str-length))
                                 str))))

          (define (zeros repeat)
            (make-string repeat #\0))]
    (build-list number strings->filename)))

; build-paths
; String (listof String) -> (listof String)
; produces a list of paths

(define (build-paths path filenames)
  (map (λ (filename) (string-append path filename)) filenames))
