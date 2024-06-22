#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hum-parser: tools: hum-type
;;    type a humdrum file's records
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require "../../parser/data-definitions/data-definitions.rkt"
         (only-in "../../parser/functions/file.rkt" read-file los->hfile)
         racket/cmdline)

(define record (make-parameter #f))

; printf
(define (type filename)
  (local [(define hum-file (los->hfile (read-file filename)))

          (define records (hfile-records hum-file))]
    (if (record)
        (foldl (λ (f rnr) (displayln (string-append (record-type f)
                                                    "\t\t"
                                                    (record-record f)))) (void) records)
        (foldl (λ (f rnr) (displayln (record-type f))) (void) records))))

(define hum-type
  (command-line
    #:once-each
    [("-r" "--record") "Print record along with type" (record #t)]
    #:args (filename)
    (type filename)))
