#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  hum-parser: tests for type functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require "../data-definitions/data-definitions.rkt"
         "../functions/type.rkt"
         test-engine/racket-tests)

; TODO
;  More robust tests would use real examples that contain each tag.
;  Could use constants.

; type-metadata
(check-expect (type-metadata "!!!COM: Scriabin, Alexander")   REFERENCE-RECORD)
(check-expect (type-metadata "!! See pg. 5 of print edition") GLOBAL-COMMENT)
(check-expect (type-metadata "!\t! In some editions A#")      LOCAL-COMMENT)

; Should only be called on strings that are tokens.
; #f indicates only that the token type is not known,
;   and does not indicate that string is not a token.
; type-token
(check-expect (type-token "**kern\t**kern") EXCLUSIVE-INTERPRETATION)
(check-expect (type-token "*\t*8va\t*")     #f)
(check-expect (type-token "=4||")           MEASURE)
(check-expect (type-token "16.aaLL]")       SPINE-DATA)
(check-expect (type-token "*^")             SPINE-SPLIT)
(check-expect (type-token "*v")             SPINE-JOIN)
(check-expect (type-token "*-")             SPINE-TERMINATOR)
(check-expect (type-token "*")              NULL-INTERPRETATION)

; TODO
; Should only be called on strings that are tandem tokens.
; #f indicates only that the tandem type is not known,
;   and does not indicate that string is not a tandem token.
; type-tandem
(check-expect (type-tandem "*^")     SPINE-SPLIT)
(check-expect (type-tandem "*v")     SPINE-JOIN)
(check-expect (type-tandem "*-")     SPINE-TERMINATOR)
(check-expect (type-tandem "*")      NULL-INTERPRETATION)
(check-expect (type-tandem "*X8va")  #f)
(check-expect (type-tandem "*M3/4")  #f)
(check-expect (type-tandem "*k[]")   #f)

; type-record
(check-expect (type-record "!!!COM: Scriabin, Alexander")   REFERENCE-RECORD)
(check-expect (type-record "!! See pg. 5 of print edition") GLOBAL-COMMENT)
(check-expect (type-record "!\t! In some editions A#")      LOCAL-COMMENT)
(check-expect (type-record "4a\t4aa\tf")                    TOKEN)

(test)
