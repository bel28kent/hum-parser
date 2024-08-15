#lang racket/base

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  hum-parser: functions: type
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require racket/bool
         racket/local
         racket/list
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
;;  SPINE FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; type-spine
; (listof (listof Token)) -> SpineType or false
; produce the type of the spine or false if unknown

(define (type-spine lolot)
  (local [(define first-token (first (first lolot)))]
    (cond [(kern? first-token) KERN]
          [(dynam? first-token) DYNAM]
          [else
            #f])))

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
                  [(key-cancel? token)        KEY-CANCEL]
                  [(staff-number? token)      STAFF-NUMBER]
                  [(instrument-class? token)  INSTRUMENT-CLASS]
                  [(ottava? token)            OTTAVA]
                  [(group-attribution? token) GROUP-ATTRIBUTION]
                  [(part-number? token)       PART-NUMBER]
                  [(metronome-marking? token) METRONOME-MARKING]
                  [(cue-sized-notes? token)   CUE-SIZED-NOTES]
                  [(tuplet? token)            TUPLET]
                  [(tremolo? token)           TREMOLO]
                  [(pedal-marking? token)     PEDAL-MARKING]
                  [(form-marker? token)       FORM-MARKER]
                  [(bracket-tuplet? token)    BRACKET-TUPLET]
                  [(flip-subspines? token)    FLIP-SUBSPINES]
                  [(above-staff? token)       ABOVE-STAFF]
                  [(below-staff? token)       BELOW-STAFF]
                  [(center-staff? token)      CENTER-STAFF]
                  [else
                    #f]))]
    (if (false? (regexp-match #px"(^=[^\t]*$)|(^!$|^!?[^!\t][^\t]*$)" token))
        (raise-argument-error 'type-token
                              "str with no tabs and optional bang to start"
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
