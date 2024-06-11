#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  hum-parser: TEST
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require "../functions/abstract.rkt"
         "../functions/file.rkt"
         "../functions/predicates.rkt"
         "../functions/split-and-gather.rkt"
         "../functions/type.rkt"
         "../data-definitions/data-definitions.rkt"
         test-engine/racket-tests)

(provide BERG-PATH)

(define BERG-PATH "data/berg01.pc")

; TODO
;  More robust tests would use real examples that contain each tag.
;  Could use constants.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  PREDICATES
;;    These functions can be called on any string.
;;    #f only signifies that the string is not a type.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; reference?
(check-expect (reference? REFERENCE-RECORD-EX)               #t)
(check-expect (reference? GLOBAL-COMMENT-EX)                 #f)
(check-expect (reference? LOCAL-COMMENT-EX)                  #f)
(check-expect (reference? EXCLUSIVE-TAG)                     #f)
(check-expect (reference? TANDEM-TAG)                        #f)
(check-expect (reference? MEASURE-TAG)                       #f)
(check-expect (reference? (token-token MUSIC-TOKEN-EX))      #f)

; global-comment?
(check-expect (global-comment? GLOBAL-COMMENT-EX)                 #t)
(check-expect (global-comment? REFERENCE-RECORD-EX)               #f)
(check-expect (global-comment? LOCAL-COMMENT-EX)                  #f)
(check-expect (global-comment? EXCLUSIVE-TAG)                     #f)
(check-expect (global-comment? TANDEM-TAG)                        #f)
(check-expect (global-comment? MEASURE-TAG)                       #f)
(check-expect (global-comment? (token-token MUSIC-TOKEN-EX))      #f)

; local-comment?
(check-expect (local-comment? LOCAL-COMMENT-EX)                  #t)
(check-expect (local-comment? GLOBAL-COMMENT-EX)                 #f)
(check-expect (local-comment? REFERENCE-RECORD-EX)               #f)
(check-expect (local-comment? EXCLUSIVE-TAG)                     #f)
(check-expect (local-comment? TANDEM-TAG)                        #f)
(check-expect (local-comment? MEASURE-TAG)                       #f)
(check-expect (local-comment? (token-token MUSIC-TOKEN-EX))      #f)

; metadata?
(check-expect (metadata? REFERENCE-RECORD-EX)               #t)
(check-expect (metadata? GLOBAL-COMMENT-EX)                 #t)
(check-expect (metadata? LOCAL-COMMENT-EX)                  #t)
(check-expect (metadata? EXCLUSIVE-TAG)                     #f)
(check-expect (metadata? TANDEM-TAG)                        #f)
(check-expect (metadata? MEASURE-TAG)                       #f)
(check-expect (metadata? (token-token MUSIC-TOKEN-EX))      #f)

; exclusive-interpretation?
(check-expect (exclusive-interpretation? EXCLUSIVE-TAG)                     #t)
(check-expect (exclusive-interpretation? "**kern")                          #t)
(check-expect (exclusive-interpretation? "**mens")                          #t)
(check-expect (exclusive-interpretation? "**dynam")                         #t)
(check-expect (exclusive-interpretation? "**text")                          #t)
(check-expect (exclusive-interpretation? REFERENCE-RECORD-EX)               #f)
(check-expect (exclusive-interpretation? GLOBAL-COMMENT-EX)                 #f)
(check-expect (exclusive-interpretation? LOCAL-COMMENT-EX)                  #f)
(check-expect (exclusive-interpretation? TANDEM-TAG)                        #f)
(check-expect (exclusive-interpretation? MEASURE-TAG)                       #f)
(check-expect (exclusive-interpretation? (token-token MUSIC-TOKEN-EX))      #f)

; tandem-interpretation?
(check-expect (tandem-interpretation? TANDEM-TAG)                        #t)
(check-expect (tandem-interpretation? "*Ipiano")                         #t)
(check-expect (tandem-interpretation? "*clefC3")                         #t)
(check-expect (tandem-interpretation? "*M3/4")                           #t)
(check-expect (tandem-interpretation? "*k[f#c#g#]")                      #t)
(check-expect (tandem-interpretation? EXCLUSIVE-TAG)                     #f)
(check-expect (tandem-interpretation? REFERENCE-RECORD-EX)               #f)
(check-expect (tandem-interpretation? GLOBAL-COMMENT-EX)                 #f)
(check-expect (tandem-interpretation? LOCAL-COMMENT-EX)                  #f)
(check-expect (tandem-interpretation? MEASURE-TAG)                       #f)
(check-expect (tandem-interpretation? (token-token MUSIC-TOKEN-EX))      #f)

; interpretation?
(check-expect (interpretation? TANDEM-TAG)                        #t)
(check-expect (interpretation? "*Ipiano")                         #t)
(check-expect (interpretation? "*clefC3")                         #t)
(check-expect (interpretation? "*M3/4")                           #t)
(check-expect (interpretation? "*k[f#c#g#]")                      #t)
(check-expect (interpretation? EXCLUSIVE-TAG)                     #t)
(check-expect (interpretation? "**kern")                          #t)
(check-expect (interpretation? "**mens")                          #t)
(check-expect (interpretation? "**dynam")                         #t)
(check-expect (interpretation? "**text")                          #t)
(check-expect (interpretation? REFERENCE-RECORD-EX)               #f)
(check-expect (interpretation? GLOBAL-COMMENT-EX)                 #f)
(check-expect (interpretation? LOCAL-COMMENT-EX)                  #f)
(check-expect (interpretation? MEASURE-TAG)                       #f)
(check-expect (interpretation? (token-token MUSIC-TOKEN-EX))      #f)

; spine-split?
(check-expect (spine-split? SPLIT-TOKEN)                         #t)
(check-expect (spine-split? JOIN-TOKEN)                          #f)
(check-expect (spine-split? TERMINATOR)                          #f)
(check-expect (spine-split? REFERENCE-RECORD-EX)                 #f)
(check-expect (spine-split? MEASURE-TAG)                         #f)
(check-expect (spine-split? (token-token MUSIC-TOKEN-EX))        #f)

; spine-join?
(check-expect (spine-join? JOIN-TOKEN)                          #t)
(check-expect (spine-join? SPLIT-TOKEN)                         #f)
(check-expect (spine-join? TERMINATOR)                          #f)
(check-expect (spine-join? REFERENCE-RECORD-EX)                 #f)
(check-expect (spine-join? MEASURE-TAG)                         #f)
(check-expect (spine-join? (token-token MUSIC-TOKEN-EX))        #f)

; spine-terminator?
(check-expect (spine-terminator? TERMINATOR)                          #t)
(check-expect (spine-terminator? JOIN-TOKEN)                          #f)
(check-expect (spine-terminator? SPLIT-TOKEN)                         #f)
(check-expect (spine-terminator? REFERENCE-RECORD-EX)                 #f)
(check-expect (spine-terminator? MEASURE-TAG)                         #f)
(check-expect (spine-terminator? (token-token MUSIC-TOKEN-EX))        #f)

; spine-structure?
(check-expect (spine-structure? SPLIT-TOKEN)                         #t)
(check-expect (spine-structure? JOIN-TOKEN)                          #t)
(check-expect (spine-structure? TERMINATOR)                          #t)
(check-expect (spine-structure? REFERENCE-RECORD-EX)                 #f)
(check-expect (spine-structure? MEASURE-TAG)                         #f)
(check-expect (spine-structure? (token-token MUSIC-TOKEN-EX))        #f)

; measure?
(check-expect (measure? MEASURE-TAG)                         #t)
(check-expect (measure? REFERENCE-RECORD-EX)                 #f)
(check-expect (measure? GLOBAL-COMMENT-EX)                   #f)
(check-expect (measure? LOCAL-COMMENT-EX)                    #f)
(check-expect (measure? EXCLUSIVE-TAG)                       #f)
(check-expect (measure? TANDEM-TAG)                          #f)
(check-expect (measure? (token-token MUSIC-TOKEN-EX))        #f)

; spine-data?
(check-expect (spine-data? (token-token MUSIC-TOKEN-EX))        #t)
(check-expect (spine-data? MEASURE-TAG)                         #f)
(check-expect (spine-data? REFERENCE-RECORD-EX)                 #f)
(check-expect (spine-data? GLOBAL-COMMENT-EX)                   #f)
(check-expect (spine-data? LOCAL-COMMENT-EX)                    #f)
(check-expect (spine-data? EXCLUSIVE-TAG)                       #f)
(check-expect (spine-data? TANDEM-TAG)                          #f)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  TOKEN FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Should only be called on strings that are tokens.
; #f indicates only that the token type is not known,
;   and does not indicate that string is not a token.
; type-token
(check-expect (type-token "**kern\t**kern") EXCLUSIVE-INTERPRETATION)
(check-expect (type-token "*\t*8va\t*")     #f)
(check-expect (type-token "=4||")           MEASURE)
(check-expect (type-token "16.aaLL]")       SPINE-DATA)

; TODO
; Should only be called on strings that are tandem tokens.
; #f indicates only that the tandem type is not known,
;   and does not indicate that string is not a tandem token.
; type-tandem
(check-expect (type-tandem "*^")    SPINE-SPLIT)
(check-expect (type-tandem "*v")    SPINE-JOIN)
(check-expect (type-tandem "*-")    SPINE-TERMINATOR)
(check-expect (type-tandem "*")     #f)
(check-expect (type-tandem "X8va")  #f)
(check-expect (type-tandem "*M3/4") #f)
(check-expect (type-tandem "*k[]")  #f)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  RECORD FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(check-expect (type-record "!!!COM: Scriabin, Alexander")   REFERENCE-RECORD)
(check-expect (type-record "!! See pg. 5 of print edition") GLOBAL-COMMENT)
(check-expect (type-record "!\t! In some editions A#")      LOCAL-COMMENT)
(check-expect (type-record "4a\t4aa\tf")                    TOKEN)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  FILE FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; read-file
(check-expect (read-file BERG-PATH)
                              (list (list "!!!COM: Berg, Alban")
                                    (list "!!!OTL: Chamber Concerto")
                                    (list "!!!OMV: Movements 1 and 3")
                                    (list "!!!ODT: 1925")
                                    (list "!!!ONB: In German, the last 8 notes are the capitalized letters in ArnolD SCHoenBErG.")
                                    (list "**pc" "**kern")
                                    (list "*X:" "*X:")
                                    (list "0" "F")
                                    (list "1" "F#")
                                    (list "3" "G#")
                                    (list "8" "C#")
                                    (list "4" "A")
                                    (list "9" "D")
                                    (list "10" "E-")
                                    (list "7" "C")
                                    (list "6" "B")
                                    (list "5" "B-")
                                    (list "11" "E")
                                    (list "2" "G")
                                    (list "*-" "*-")
                                    (list "!!!YOR: Dave Headlam, The Music of Alban Berg (New Haven, CT: Yale University Press, 1996), p. 391")
                                    (list "!!!ref: @{COM}: <i>@{OTL}</i> (@{ODT}), @{OMV} <br>@{ONB}")
                                    (list "!!!SEM: This row contains 4 instances of the semitone interval class.")
                                    (list "!!!AIR: This is an all-interval row.")
                                    (list "!!!RKY: 0.55")
                                    (list "!!!T33: 1")
                                    (list "!!!T35: 0")))

; TODO
; write-file

; split
(check-expect (split "") empty)
(check-expect (split "**kern") (list "**kern"))
(check-expect (split "**kern\t**kern\t**kern") (list "**kern" "**kern" "**kern"))
(check-expect (split "**kern\t**dynam\t**kern\t**text") (list "**kern" "**dynam" "**kern" "**text"))

; TODO
; gather

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  ABSTRACT FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; TODO
; tag=?

(test)
