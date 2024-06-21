#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  hum-parser: tests for type functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require "../../parser/data-definitions/data-definitions.rkt"
         "../../parser/functions/type.rkt"
         test-engine/racket-tests)

; type-metadata
(check-expect (type-metadata "!!!COM: Scriabin, Alexander")   REFERENCE-RECORD)
(check-expect (type-metadata "!! See pg. 5 of print edition") GLOBAL-COMMENT)
(check-expect (type-metadata "!\t! In some editions A#")      LOCAL-COMMENT)

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
