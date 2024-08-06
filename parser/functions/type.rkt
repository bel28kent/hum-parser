#lang racket/base

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  hum-parser: functions: type
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require racket/bool
         racket/local
         racket/string
         (only-in lang/htdp-advanced
                  boolean->string)
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
            (cond [(spine-split? token)       SPINE-SPLIT]
                  [(spine-join? token)        SPINE-JOIN]
                  [(spine-terminator? token)  SPINE-TERMINATOR]
                  [(clef? token)              CLEF]
                  [(time-sig? token)          TIME-SIG]
                  [(key-sig? token)           KEY-SIG]
                  [(key-label? token)         KEY-LABEL]
                  [(staff-number? token)      STAFF-NUMBER]
                  [(instrument-class? token)  INSTRUMENT-CLASS]
                  [(ottava? token)            OTTAVA]
                  [(group-attribution? token) GROUP-ATTRIBUTION]
                  [(part-number? token)       PART-NUMBER]
                  [(metronome-marking? token) METRONOME-MARKING]
                  [(cue-sized-notes? token)   CUE-SIZED-NOTES]
                  [(tuplet? token)            TUPLET]
                  [else
                    #f]))]
    (if (false? (regexp-match #px"(^=[^\t]*$)|(^!?[^!\t]*$)" token))
        (raise-argument-error 'type-token
                              "str with no tabs and 0 or 1 bang"
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

; type-token-as-str
; String -> String
; produce the type of the token as a string

(define (type-token-as-str token)
  (local [(define type (type-token token))]
    (cond [(string? type) type]
          [else
            (boolean->string type)])))
