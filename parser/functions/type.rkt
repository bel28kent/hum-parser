#lang racket/base

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  hum-parser: functions: type
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require racket/bool
         racket/local
         test-engine/racket-tests
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

; TODO
; type-token
; String -> TokenType or false
; produce the type of the token or false if unknown

(define (type-token token)
  (cond [(exclusive-interpretation? token) EXCLUSIVE-INTERPRETATION]
        [(tandem-interpretation? token)    (type-tandem token)]
        [(null-interpretation? token)      NULL-INTERPRETATION]
        [(measure? token)                  MEASURE]
        [(spine-data? token)               SPINE-DATA]
        [(null-spine-data? token)          NULL-SPINE-DATA]
        [(local-comment-token? token)      LOCAL-COMMENT]
        [else
          #f]))

; type-tandem
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
          #f]))

; type-metadata
(check-expect (type-metadata "!!!COM: Scriabin, Alexander")   REFERENCE-RECORD)
(check-expect (type-metadata "!! See pg. 5 of print edition") GLOBAL-COMMENT)
(check-expect (type-metadata "!\t! In some editions A#")      LOCAL-COMMENT)
(check-expect (type-metadata "4a\t4aa")                       #f)

; type-record
(check-expect (type-record "!!!COM: Scriabin, Alexander")   REFERENCE-RECORD)
(check-expect (type-record "!! See pg. 5 of print edition") GLOBAL-COMMENT)
(check-expect (type-record "!\t! In some editions A#")      LOCAL-COMMENT)
(check-expect (type-record "4a\t4aa\tf")                    TOKEN)

; Should only be called on strings that are tokens.
; #f indicates only that the token type is not known,
;   and does not indicate that string is not a token.
; type-token
(check-expect (type-token "**kern")    EXCLUSIVE-INTERPRETATION)
(check-expect (type-token "=4||")      MEASURE)
(check-expect (type-token "16.aaLL]")  SPINE-DATA)
(check-expect (type-token "*^")        SPINE-SPLIT)
(check-expect (type-token "*v")        SPINE-JOIN)
(check-expect (type-token "*-")        SPINE-TERMINATOR)
(check-expect (type-token "*")         NULL-INTERPRETATION)
(check-expect (type-token "*clefG2")   CLEF)
(check-expect (type-token "*M3/4")     TIME-SIG)
(check-expect (type-token "*met(c)")   TIME-SIG)
(check-expect (type-token "*k[]")      KEY-SIG)
(check-expect (type-token "*k[f#]")    KEY-SIG)
(check-expect (type-token "*k[b-]")    KEY-SIG)
(check-expect (type-token "*C:")       KEY-LABEL)
(check-expect (type-token "*X:")       KEY-LABEL)
(check-expect (type-token "*f#:")      KEY-LABEL)
(check-expect (type-token "*d:")       KEY-LABEL)
(check-expect (type-token "*B-:")      KEY-LABEL)
(check-expect (type-token "*staff1")   STAFF-NUMBER)
(check-expect (type-token "*staff1/2") STAFF-NUMBER)
(check-expect (type-token "*Ipiano")   INSTRUMENT-CLASS)
(check-expect (type-token "*X8va")     #f)
(check-expect (type-token "*8va")      #f)

; TODO
; Should only be called on strings that are tandem tokens.
; #f indicates only that the tandem type is not known,
;   and does not indicate that string is not a tandem token.
; type-tandem
(check-expect (type-tandem "*^")        SPINE-SPLIT)
(check-expect (type-tandem "*v")        SPINE-JOIN)
(check-expect (type-tandem "*-")        SPINE-TERMINATOR)
(check-expect (type-tandem "*clefG2")   CLEF)
(check-expect (type-tandem "*M3/4")     TIME-SIG)
(check-expect (type-tandem "*met(c)")   TIME-SIG)
(check-expect (type-tandem "*k[]")      KEY-SIG)
(check-expect (type-tandem "*k[f#]")    KEY-SIG)
(check-expect (type-tandem "*k[b-]")    KEY-SIG)
(check-expect (type-tandem "*C:")       KEY-LABEL)
(check-expect (type-tandem "*X:")       KEY-LABEL)
(check-expect (type-tandem "*f#:")      KEY-LABEL)
(check-expect (type-tandem "*d:")       KEY-LABEL)
(check-expect (type-tandem "*B-:")      KEY-LABEL)
(check-expect (type-tandem "*staff1")   STAFF-NUMBER)
(check-expect (type-tandem "*staff1/2") STAFF-NUMBER)
(check-expect (type-tandem "*Ipiano")   INSTRUMENT-CLASS)
(check-expect (type-tandem "*")         #f)
(check-expect (type-tandem "*X8va")     #f)

(test)
