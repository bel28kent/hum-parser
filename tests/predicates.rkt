#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  hum-parser: tests for predicates
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require "../data-definitions/data-definitions.rkt"
         "../functions/predicates.rkt"
         test-engine/racket-tests)

; TODO
;  More robust tests would use real examples that contain each tag.
;  Could use constants.

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

; spine-data?
(check-expect (spine-data? (token-token MUSIC-TOKEN-EX))        #t)
(check-expect (spine-data? MEASURE-TAG)                         #f)
(check-expect (spine-data? REFERENCE-RECORD-EX)                 #f)
(check-expect (spine-data? GLOBAL-COMMENT-EX)                   #f)
(check-expect (spine-data? LOCAL-COMMENT-EX)                    #f)
(check-expect (spine-data? EXCLUSIVE-TAG)                       #f)
(check-expect (spine-data? TANDEM-TAG)                          #f)

(test)
