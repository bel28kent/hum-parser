#lang racket/base

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  hum-parser: functions: type
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require racket/bool
         racket/local
         racket/string
         "../data-definitions/data-definitions.rkt"
         "predicates.rkt")

(provide (all-defined-out))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  METADATA FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; type-metadata
; String -> MetadataType or false
; produce the type of the metadata or false if unknown

(define (type-metadata string)
  (cond [(reference? string)      REFERENCE-RECORD]
        [(global-comment? string) GLOBAL-COMMENT]
        [(local-comment? string)  LOCAL-COMMENT]
        [else
          #f]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  RECORD FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; type-record
; String -> MetadataType or Token
; produce the type of the record

(define (type-record string)
  (local [(define metadata (type-metadata string))]
    (if (false? metadata)
        TOKEN
        metadata)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  TOKEN FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; type-token
; String -> TokenType or false
; produce the type of the token or false if unknown

(define (type-token token)
  (local [; type-tandem
          ; String -> TandemInterpretation or false
          ; produce the type of the tandem interpretation or false if unknown
          (define (type-tandem token)
            (cond [(spine-split? token)      SPINE-SPLIT]
                  [(spine-join? token)       SPINE-JOIN]
                  [(spine-terminator? token) SPINE-TERMINATOR]
                  [(clef? token)             CLEF]
                  [(time-sig? token)         TIME-SIG]
                  [(key-sig? token)          KEY-SIG]
                  [(key-label? token)        KEY-LABEL]
                  [(staff-number? token)     STAFF-NUMBER]
                  [(instrument-class? token) INSTRUMENT-CLASS]
                  [else
                    #f]))]
    (if (false? (regexp-match #px"^!?[^!\t]+$" token))
        (raise-argument-error 'type-token
                              "A string that does not contain a tab or more than one bang"
                              token)
        (cond [(exclusive-interpretation? token) EXCLUSIVE-INTERPRETATION]
              [(tandem-interpretation? token)    (type-tandem token)]
              [(null-interpretation? token)      NULL-INTERPRETATION]
              [(measure? token)                  MEASURE]
              [(spine-data? token)               SPINE-DATA]
              [(null-spine-data? token)          NULL-SPINE-DATA]
              [(local-comment-token? token)      LOCAL-COMMENT]
              [else
                #f]))))
