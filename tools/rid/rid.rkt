#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hum-parser: tools: rid
;;    eliminate specified humdrum record types
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;The rid command allows the user to eliminate specified types of Humdrum records (lines) from the input stream.
;Depending on the options selected, rid will eliminate: global comments, DONE
;                                                       local comments, DONE
;                                                       interpretations, DONE
;                                                       duplicate exclusive interpretations, DONE
;                                                       tandem interpretations, DONE
;                                                       data records, DONE
;                                                       data records consisting of just null tokens (null data records), DONE
;                                                       empty global or local comments, DONE
;                                                       empty interpretations, DONE
;                                                       or any combination of these record types.

(require "../../parser/data-definitions/data-definitions.rkt"
         "../../parser/functions/abstract.rkt"
         "../../parser/functions/predicates.rkt"
         racket/cmdline)

(provide (all-defined-out))

; rid-global-comments
; (listof Record) -> (listof Record)
; filters global comments from list of records

(define (rid-global-comments lor)
  (local [(define (not-global-comment? r)
            (not (string=? (record-type r) GLOBAL-COMMENT)))]
    (filter not-global-comment? lor)))

; rid-local-comments
; (listof Record) -> (listof Record)
; filters local comments from list of records

(define (rid-local-comments lor)
  (local [(define (not-local-comment? r)
            (not (string=? (record-type r) LOCAL-COMMENT)))]
    (filter not-local-comment? lor)))

; rid-empty-global-comments
; (listof Record) -> (listof Record)
; filters records that match "!!" followed by any whitepsace

(define (rid-empty-global-comments lor)
  (local [(define (not-empty-global-comment? r)
            (not (regexp-match #rx"!!\\s*" (record-record r))))]
    (filter not-empty-global-comment? lor)))

; rid-empty-local-comments
; (listof Record) -> (listof Record)
; filters records that are LOCAL-COMMENT and do not match "[a-gA-G0-9]"

(define (rid-empty-local-comments lor)
  (local [(define (not-empty-local-comment? r)
            (not (and (string=? LOCAL-COMMENT (record-type r))
                      (not (regexp-match #rx"[a-gA-G0-9]+" (record-record r))))))]
    (filter not-empty-local-comment? lor)))

; rid-interpretations
; (listof Record) -> (listof Record)
; filters records that are interpretations

(define (rid-interpretations lor)
  (local [(define (not-interpretation? r)
            (not (and (string=? TOKEN (record-type r))
                      (interpretation? (token-token (first (record-split r)))))))]
    (filter not-interpretation? lor)))

; rid-tandem-interpretations
; (listof Record) -> (listof Record)
; filters tandem interpretation records

(define (rid-tandem-interpretations lor)
  (local [(define (not-tandem-interpretation? r)
            (not (and (string=? TOKEN (record-type r))
                      (tandem-interpretation? (token-token (first (record-split r)))))))]
    (filter not-tandem-interpretation? lor)))

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
    (filter not-empty-interpretation? lor)))

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
    (filter not-data-record? lor)))

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
    (filter not-null-data-record? lor)))

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
      (if (= -1 first-exclusive-record-number)
          lor
          (filter not-duplicate-exclusive-interpretation? lor))))
