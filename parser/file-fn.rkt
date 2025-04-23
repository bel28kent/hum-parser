#lang racket/base

#|
	File and IO functions.
|#

(require racket/contract
         racket/list
         racket/local
         (only-in "HumdrumSyntax.rkt" humdrum-file
                                      humdrum-record-type-match?
                                      record
                                      token))

(provide build-filenames
         build-paths
         hfile->strings
         path->hfile
         read-file
         write-file)

(define/contract (read-file path)
  (-> string? (listof string?))
  (local [(define (read-file los in)
            (local [(define next-line (read-line in))]
              (if (eof-object? next-line)
                  (reverse los)
                  (read-file (cons next-line los) in))))]
    (call-with-input-file path
                          (λ (in) (read-file empty in)))))

(define/contract (write-file los path)
  (-> (listof string?) string? void?)
  (local [(define (write-file los out)
            (foldl (λ (f r) (displayln f out)) (void) los))]
    (call-with-output-file path (λ (out) (write-file los out)))))

(define/contract (path->hfile path)
  (-> string? humdrum-file?)
  (local [(define (los->lor los record-index)
            (local [(define (str->record str)
                      (record str
                              (type-record str)
                              (if (or (humdrum-record-type-match? 'Reference str)
                                      (humdrum-record-type-match? 'GlobalComment str))
                                  (list str)
                                  (los->lot (split str)))
                              record-index))

                    (define (los->lot los)
                      (local [(define (los->lot los field-index)
                                (cond [(empty? los) empty]
                                      [else
                                        (cons (str->token (first los) field-index)
                                              (los->lot (rest los) (add1 field-index)))]))]
                        (los->lot los 0)))


                    (define (str->token str field-index)
                      (token str (type-token str) record-index field-index))]
              (cond [(empty? los) empty]
                    [else
                      (cons (str->record (first los))
                            (los->lor (rest los) (add1 record-index)))])))]
    (hfile
      (los->lor
        (read-file path) 0))))

(define/contract (hfile->strings hfile)
  (-> humdrum-file? (listof string?))
  (local [(define records (humdrum-file-records hfile))]
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

(define/contract (build-filenames start extension number)
  (-> string? string? natural-number/c (listof string?))
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

(define/contract (build-paths path filenames)
  (-> string? (listof string?) (listof string?))
  (map (λ (filename) (string-append path filename)) filenames))
