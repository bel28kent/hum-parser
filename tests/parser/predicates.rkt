#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  hum-parser: tests for predicates
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require "../../parser/data-definitions/data-definitions.rkt"
         "../../parser/functions/predicates.rkt"
         test-engine/racket-tests)

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

; is-token?
(check-expect (is-token? "**kern\t**kern")                 #t)
(check-expect (is-token? "!!!COM: Bach, Johann Sebastian") #f)

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
(check-expect (tandem-interpretation? "*Ipiano")                         #t)
(check-expect (tandem-interpretation? "*clefC3")                         #t)
(check-expect (tandem-interpretation? "*M3/4")                           #t)
(check-expect (tandem-interpretation? "*k[f#c#g#]")                      #t)
(check-expect (tandem-interpretation? TANDEM-TAG)                        #f)
(check-expect (tandem-interpretation? EXCLUSIVE-TAG)                     #f)
(check-expect (tandem-interpretation? REFERENCE-RECORD-EX)               #f)
(check-expect (tandem-interpretation? GLOBAL-COMMENT-EX)                 #f)
(check-expect (tandem-interpretation? LOCAL-COMMENT-EX)                  #f)
(check-expect (tandem-interpretation? MEASURE-TAG)                       #f)
(check-expect (tandem-interpretation? (token-token MUSIC-TOKEN-EX))      #f)

; null-interpretation?
(check-expect (null-interpretation? TANDEM-TAG)                        #t)
(check-expect (null-interpretation? "*Ipiano")                         #f)
(check-expect (null-interpretation? "*clefC3")                         #f)
(check-expect (null-interpretation? "*M3/4")                           #f)
(check-expect (null-interpretation? "*k[f#c#g#]")                      #f)
(check-expect (null-interpretation? REFERENCE-RECORD-EX)               #f)
(check-expect (null-interpretation? GLOBAL-COMMENT-EX)                 #f)
(check-expect (null-interpretation? LOCAL-COMMENT-EX)                  #f)
(check-expect (null-interpretation? MEASURE-TAG)                       #f)
(check-expect (null-interpretation? (token-token MUSIC-TOKEN-EX))      #f)

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

; clef?
(check-expect (clef? "*Ipiano")    #f)
(check-expect (clef? "*clefC3")    #t)
(check-expect (clef? "*clefF4")    #t)
(check-expect (clef? "*clefG2")    #t)
(check-expect (clef? "*M3/4")      #f)
(check-expect (clef? "*k[f#c#g#]") #f)
(check-expect (clef? TANDEM-TAG)   #f)

; time-sig?
(check-expect (time-sig? "*Ipiano")    #f)
(check-expect (time-sig? "*clefC3")    #f)
(check-expect (time-sig? "*M3/4")      #t)
(check-expect (time-sig? "*M4/4")      #t)
(check-expect (time-sig? "*met(c)")    #t)
(check-expect (time-sig? "*k[f#c#g#]") #f)
(check-expect (time-sig? TANDEM-TAG)   #f)

; key-sig?
(check-expect (key-sig? "*Ipiano")    #f)
(check-expect (key-sig? "*clefC3")    #f)
(check-expect (key-sig? "*M3/4")      #f)
(check-expect (key-sig? "*M4/4")      #f)
(check-expect (key-sig? "*met(c)")    #f)
(check-expect (key-sig? "*k[]")       #t)
(check-expect (key-sig? "*k[b-]")     #t)
(check-expect (key-sig? "*k[f#c#g#]") #t)
(check-expect (key-sig? TANDEM-TAG)   #f)

; key-label?
(check-expect (key-label? "*Ipiano")     #f)
(check-expect (key-label? "*clefC3")     #f)
(check-expect (key-label? "*M3/4")       #f)
(check-expect (key-label? "*M4/4")       #f)
(check-expect (key-label? "*met(c)")     #f)
(check-expect (key-label? "*k[]")        #f)
(check-expect (key-label? "*C:")         #t)
(check-expect (key-label? "*a:")         #t)
(check-expect (key-label? "*X:")         #t)
(check-expect (key-label? "*k[b-]")      #f)
(check-expect (key-label? "*F:")         #t)
(check-expect (key-label? "*d:")         #t)
(check-expect (key-label? "*k[f#c#g#]")  #f)
(check-expect (key-label? "*A:")         #t)
(check-expect (key-label? "*f#:")        #t)
(check-expect (key-label? "*b-:")        #t)
(check-expect (key-label? TANDEM-TAG)    #f)

; staff-number?
(check-expect (staff-number? "*Ipiano")   #f)
(check-expect (staff-number? "*clefC3")   #f)
(check-expect (staff-number? "*M3/4")     #f)
(check-expect (staff-number? "*k[]")      #f)
(check-expect (staff-number? "*C:")       #f)
(check-expect (staff-number? "*staff1")   #t)
(check-expect (staff-number? "*staff1/2") #t)

; instrument-class?
(check-expect (instrument-class? "*Ipiano")   #t)
(check-expect (instrument-class? "*Icello")   #t)
(check-expect (instrument-class? "*clefC3")   #f)
(check-expect (instrument-class? "*M3/4")     #f)
(check-expect (instrument-class? "*k[]")      #f)
(check-expect (instrument-class? "*C:")       #f)
(check-expect (instrument-class? "*staff1")   #f)

; spine-data?
(check-expect (spine-data? (token-token MUSIC-TOKEN-EX))        #t)
(check-expect (spine-data? MEASURE-TAG)                         #f)
(check-expect (spine-data? REFERENCE-RECORD-EX)                 #f)
(check-expect (spine-data? GLOBAL-COMMENT-EX)                   #f)
(check-expect (spine-data? LOCAL-COMMENT-EX)                    #f)
(check-expect (spine-data? EXCLUSIVE-TAG)                       #f)
(check-expect (spine-data? TANDEM-TAG)                          #f)

; null-spine-data?
(check-expect (null-spine-data? ".")  #t)
(check-expect (null-spine-data? "4a") #f)
(check-expect (null-spine-data? "ff") #f)
(check-expect (null-spine-data? "a-") #f)

(test)
