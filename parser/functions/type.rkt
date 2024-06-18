#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  hum-parser: functions: type
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require "../data-definitions/data-definitions.rkt"
         "predicates.rkt"
         "../../../abstract-fns/functions/functions.rkt")

(provide (all-defined-out))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  METADATA FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; type-metadata
; String -> MetadataType or false
; produce the type of the metadata or false if unknown

(define (type-metadata string)
  (cond [(reference? string) REFERENCE-RECORD]
        [(global-comment? string) GLOBAL-COMMENT]
        [(local-comment? string) LOCAL-COMMENT]
        [else
          #f]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  RECORD FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; type-record
; String -> MetadataType or Token or false
; produce the type of the record or false if unknown

(define (type-record string)
  (local [(define bool (type-metadata string))]
    (if (false? bool)
        (if (is-token? string)
            TOKEN
            #f)
        bool)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  TOKEN FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; type-token
; String -> TokenType or false
; produce the type of the token or false if unknown

(define (type-token token)
  (cond [(exclusive-interpretation? token) EXCLUSIVE-INTERPRETATION]
        [(tandem-interpretation? token) (type-tandem token)]
        [(null-interpretation? token) NULL-INTERPRETATION]
        [(measure? token) MEASURE]
        [(spine-data? token) SPINE-DATA]
        [else
          #f]))

; type-tandem
; String -> TandemInterpretation or false
; produce the type of the tandem interpretation or false if unknown

(define (type-tandem token)
  (cond [(spine-split? token) SPINE-SPLIT]
        [(spine-join? token) SPINE-JOIN]
        [(spine-terminator? token) SPINE-TERMINATOR]
        [else
          #f]))
