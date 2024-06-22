#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hum-parser: tools: hum-type
;;    type a humdrum file's records
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require "../../parser/data-definitions/data-definitions.rkt"
         (only-in "../../parser/functions/file.rkt" read-file los->hfile)
         racket/cmdline)

(define record (make-parameter #f))
(define token  (make-parameter #f))
(define SPACES 25)

(define (type filename)
  (local [(define records (hfile-records (los->hfile (read-file filename))))

          (define (get-type record)
            (local [(define f (first (record-split record)))]
              (cond [(token? f) (token-type f)]
                    [else
                      (record-type record)])))

          (define (display-with-record records type-getter)
              (local [(define (display-proc f)
                        (local [(define type (type-getter f))]
                          (displayln (if (false? type)
                                         (string-append "Unknown"
                                                        (make-string (- SPACES (string-length "Unknown")) #\space)
                                                        (record-record f))
                                         (string-append type
                                                        (make-string (- SPACES (string-length type)) #\space)
                                                        (record-record f))))))]
                (foldl (λ (f rnr) (display-proc f)) (void) records)))

          (define (display-type-only records type-getter)
            (foldl (λ (f rnr) (displayln (if (false? (type-getter f))
                                             "Unkown"
                                             (type-getter f)))) (void) records))]

    (cond [(record) (display-with-record records (if (token)
                                                     get-type
                                                     record-type))]
          [else
            (display-type-only records (if (token)
                                           get-type
                                           record-type))])))

(define hum-type
  (command-line
    #:once-each
    [("-r" "--record") "Print type followed by record" (record #t)]
    [("-t" "--token")  "For token records, print type of first token" (token #t)]
    #:args (filename)
    (type filename)))
