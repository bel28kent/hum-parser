#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hum-parser: tools: ridkt
;;    eliminate specified humdrum record types
;;    emulates humdrum-tools rid
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require "../../parser/data-definitions/data-definitions.rkt"
         "../../parser/functions/abstract.rkt"
         (only-in "../../parser/functions/file.rkt"
                  path->hfile)
         "../../parser/functions/predicates.rkt"
         racket/cmdline)

(define references      (make-parameter #f))
(define global          (make-parameter #f))
(define Global          (make-parameter #f))
(define l               (make-parameter #f))
(define Local           (make-parameter #f))
(define interpretations (make-parameter #f))
(define duplicates      (make-parameter #f))
(define tandem          (make-parameter #f))
(define e               (make-parameter #f))
(define spine           (make-parameter #f))
(define n               (make-parameter #f))

; composition
; String -> (listof Record)
; executes command

(define (composition filename)
          (output (rid-reference-records
                    (rid-global-comments
                      (rid-empty-global-comments
                        (rid-local-comments
                          (rid-empty-local-comments
                            (rid-interpretations
                              (rid-duplicate-exclusive-interpretations
                                (rid-tandem-interpretations
                                  (rid-empty-interpretations
                                    (rid-data-records
                                      (rid-null-data-records (hfile-records
                                                               (path->hfile filename)))))))))))))))

; output
; (listof Record) -> (void)
; displays output

(define (output lor)
  (foldl (λ (f r) (displayln (record-record f))) (void) lor))

; rid-reference-records
; (listof Record) -> (listof Record)
; filters all reference records from list of records

(define (rid-reference-records lor)
  (local [(define (not-reference-record? r)
            (not (string=? (record-type r) REFERENCE-RECORD)))]
    (if (references)
        (filter not-reference-record? lor)
        lor)))

; rid-global-comments
; (listof Record) -> (listof Record)
; filters global comments from list of records

(define (rid-global-comments lor)
  (local [(define (not-global-comment? r)
            (not (string=? (record-type r) GLOBAL-COMMENT)))]
    (if (global)
        (filter not-global-comment? lor)
        lor)))

; rid-local-comments
; (listof Record) -> (listof Record)
; filters local comments from list of records

(define (rid-local-comments lor)
  (local [(define (not-local-comment? r)
            (not (string=? (record-type r) LOCAL-COMMENT)))]
    (if (l)
        (filter not-local-comment? lor)
        lor)))

; rid-empty-global-comments
; (listof Record) -> (listof Record)
; filters records that match "!!" followed by any whitepsace

(define (rid-empty-global-comments lor)
  (local [(define (not-empty-global-comment? r)
            (not (regexp-match #px"^!![\\s]*$" (record-record r))))]
    (if (Global)
        (filter not-empty-global-comment? lor)
        lor)))

; rid-empty-local-comments
; (listof Record) -> (listof Record)
; filters records that are LOCAL-COMMENT and do not match "[a-gA-G0-9]"

(define (rid-empty-local-comments lor)
  (local [(define (not-empty-local-comment? r)
            (not (and (string=? LOCAL-COMMENT (record-type r))
                      (not (regexp-match #px"^!(\t!)*$" (record-record r))))))]
    (if (Local)
        (filter not-empty-local-comment? lor)
        lor)))

; rid-interpretations
; (listof Record) -> (listof Record)
; filters records that are interpretations

(define (rid-interpretations lor)
  (local [(define (not-interpretation? r)
            (not (and (string=? TOKEN (record-type r))
                      (interpretation? (token-token (first (record-split r)))))))]
    (if (interpretations)
        (filter not-interpretation? lor)
        lor)))

; rid-tandem-interpretations
; (listof Record) -> (listof Record)
; filters tandem interpretation records

(define (rid-tandem-interpretations lor)
  (local [(define (not-tandem-interpretation? r)
            (not (and (string=? TOKEN (record-type r))
                      (tandem-interpretation? (token-token (first (record-split r)))))))]
    (if (tandem)
        (filter not-tandem-interpretation? lor)
        lor)))

; rid-empty-interpretations
; (listof Record) -> (listof Record)
; filters records with only null interpretations

(define (rid-empty-interpretations lor)
  (local [(define (not-empty-interpretation? r)
            (not (and (string=? TOKEN (record-type r))
                      (empty-interpretation? (record-split r)))))

          (define (empty-interpretation? split)
            (cond [(empty? split) #t]
                  [(not (string=? NULL-INTERPRETATION (token-type (first split)))) #f]
                  [else
                    (empty-interpretation? (rest split))]))]
    (if (e)
        (filter not-empty-interpretation? lor)
        lor)))

; rid-data-records
; (listof Record) -> (listof Record)
; filters records that are not comments, references, or interpretations

(define (rid-data-records lor)
  (local [(define (not-data-record? r)
            (or (string=? REFERENCE-RECORD (record-type r))
                (string=? GLOBAL-COMMENT (record-type r))
                (string=? LOCAL-COMMENT (record-type r))
                (and (string=? TOKEN (record-type r))
                     (interpretation? (token-token (first (record-split r)))))))]
    (if (spine)
        (filter not-data-record? lor)
        lor)))

; rid-null-data-records
; (listof Record) -> (listof Record)
; filters records that only have null data tokens

(define (rid-null-data-records lor)
  (local [(define (not-null-data-record? r)
            (not (and (string=? TOKEN (record-type r))
                      (null-data-record? (record-split r)))))

          (define (null-data-record? split)
            (cond [(empty? split) #t]
                  [(not (string=? NULL-SPINE-DATA (token-type (first split)))) #f]
                  [else
                    (null-data-record? (rest split))]))]
    (if (n)
        (filter not-null-data-record? lor)
        lor)))

; rid-duplicate-exclusive-interpretations
; (listof Record) -> (listof Record)
; filters records with exclusive interpretations that occur after the exclusive interpretation record

(define (rid-duplicate-exclusive-interpretations lor)
  (local [(define (find-first-exclusive-record-number lor)
            (cond [(empty? lor) -1] ; records use zero-based indexing
                  [(and (string=? TOKEN (record-type (first lor)))
                        (string=? EXCLUSIVE-INTERPRETATION
                                  (token-type (first (record-split (first lor)))))) (record-record-number (first lor))]
                  [else
                    (find-first-exclusive-record-number (rest lor))]))

          (define first-exclusive-record-number (find-first-exclusive-record-number lor))

          (define (not-duplicate-exclusive-interpretation? r)
            (not (and (string=? TOKEN (record-type r))
                      (ormap exclusive-interpretation? (map (λ (t) (token-token t)) (record-split r)))
                      (> (record-record-number r) first-exclusive-record-number))))]
      (if (duplicates)
          (if (= -1 first-exclusive-record-number)
              lor
              (filter not-duplicate-exclusive-interpretation? lor))
          lor)))

(define ridkt
  (command-line
    #:once-each
    [("-r" "--references")      "Filter all reference records"                  (references #t)]
    [("-g" "--global")          "Filter all global comments"                    (global #t)]
    [("-G" "--Global")          "Filter only empty global commments"            (Global #t)]
    [("-l" "--local")           "Filter all local comments"                     (l #t)]
    [("-L" "--Local")           "Filter only empty local comments"              (Local #t)]
    [("-i" "--interpretations") "Filter all interpretations"                    (interpretations #t)]
    [("-d" "--duplicates")      "Filter duplicate exclusive interpretations"    (duplicates #t)]
    [("-t" "--tandem")          "Filter tandem interpretations"                 (tandem #t)]
    [("-e" "--empty")           "Filter empty interpretations"                  (e #t)]
    [("-s" "--spine")           "Filter spine data, except for interpretations" (spine #t)]
    [("-n" "--null")            "Filter null data records"                      (n #t)]
    #:args (filename)
    (composition filename)))
