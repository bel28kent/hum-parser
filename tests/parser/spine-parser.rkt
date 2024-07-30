#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hum-parser: tests for spine-parser
;;    also tested in spine-parser-scriabin-test
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require "../../parser/data-definitions/data-definitions.rkt"
         (only-in "../../parser/functions/file.rkt"
                  path->hfile)
         "../../parser/functions/spine-parser.rkt"
         test-engine/racket-tests)

(define KERN-TOKEN  (token "**kern" "ExclusiveInterpretation" 0))
(define CLEF-G2     (token "*clefG2" "Clef" 1))
(define CLEF-F4     (token "*clefF4" "Clef" 1))
(define SPLIT-TOKEN (token "*^" "SpineSplit" 1))
(define NULL        (token "*" "NullInterpretation" 1))
(define LEFT-SPLIT  (token "4a" "SpineData" 2))
(define RIGHT-SPLIT (token "4aa" "SpineData" 2))
(define 4AAA        (token "4aaa" "SpineData" 2))

(define berg-hfile (path->hfile "data/berg01.pc"))

; spine-parser
(check-expect (spine-parser berg-hfile)
              (list (global-spine (list
                                   (list
                                    (token "**pc" EXCLUSIVE-INTERPRETATION 5))
                                   (list (token "*X:" KEY-LABEL 6))
                                   (list (token "0" SPINE-DATA 7))
                                   (list (token "1" SPINE-DATA 8))
                                   (list (token "3" SPINE-DATA 9))
                                   (list (token "8" SPINE-DATA 10))
                                   (list (token "4" SPINE-DATA 11))
                                   (list (token "9" SPINE-DATA 12))
                                   (list (token "10" SPINE-DATA 13))
                                   (list (token "7" SPINE-DATA 14))
                                   (list (token "6" SPINE-DATA 15))
                                   (list (token "5" SPINE-DATA 16))
                                   (list (token "11" SPINE-DATA 17))
                                   (list (token "2" SPINE-DATA 18))
                                   (list (token "*-" SPINE-TERMINATOR 19)))
                                  0)
                    (global-spine (list
                                   (list
                                    (token "**kern"
                                           EXCLUSIVE-INTERPRETATION
                                           5))
                                   (list (token "*X:" KEY-LABEL 6))
                                   (list (token "F" SPINE-DATA 7))
                                   (list (token "F#" SPINE-DATA 8))
                                   (list (token "G#" SPINE-DATA 9))
                                   (list (token "C#" SPINE-DATA 10))
                                   (list (token "A" SPINE-DATA 11))
                                   (list (token "D" SPINE-DATA 12))
                                   (list (token "E-" SPINE-DATA 13))
                                   (list (token "C" SPINE-DATA 14))
                                   (list (token "B" SPINE-DATA 15))
                                   (list (token "B-" SPINE-DATA 16))
                                   (list (token "E" SPINE-DATA 17))
                                   (list (token "G" SPINE-DATA 18))
                                   (list (token "*-" SPINE-TERMINATOR 19)))
                                  1)))

; unwrap
(check-expect (unwrap berg-hfile)
              (list (list (token "**pc" EXCLUSIVE-INTERPRETATION 5)
                          (token "**kern" EXCLUSIVE-INTERPRETATION 5))
                    (list (token "*X:" KEY-LABEL 6)
                          (token "*X:" KEY-LABEL 6))
                    (list (token "0" SPINE-DATA 7)
                          (token "F" SPINE-DATA 7))
                    (list (token "1" SPINE-DATA 8)
                          (token "F#" SPINE-DATA 8))
                    (list (token "3" SPINE-DATA 9)
                          (token "G#" SPINE-DATA 9))
                    (list (token "8" SPINE-DATA 10)
                          (token "C#" SPINE-DATA 10))
                    (list (token "4" SPINE-DATA 11)
                          (token "A" SPINE-DATA 11))
                    (list (token "9" SPINE-DATA 12)
                          (token "D" SPINE-DATA 12))
                    (list (token "10" SPINE-DATA 13)
                          (token "E-" SPINE-DATA 13))
                    (list (token "7" SPINE-DATA 14)
                          (token "C" SPINE-DATA 14))
                    (list (token "6" SPINE-DATA 15)
                          (token "B" SPINE-DATA 15))
                    (list (token "5" SPINE-DATA 16)
                          (token "B-" SPINE-DATA 16))
                    (list (token "11" SPINE-DATA 17)
                          (token "E" SPINE-DATA 17))
                    (list (token "2" SPINE-DATA 18)
                          (token "G" SPINE-DATA 18))
                    (list (token "*-" SPINE-TERMINATOR 19)
                          (token "*-" SPINE-TERMINATOR 19))))

; byrecord->byspine
(check-expect (byrecord->byspine (spine-arity 2
                                              (list (list 1 1)
                                                    (list 1 1)
                                                    (list 1 1)
                                                    (list 1 1)
                                                    (list 1 1)
                                                    (list 1 1)
                                                    (list 1 1)
                                                    (list 1 1)
                                                    (list 1 1)
                                                    (list 1 1)
                                                    (list 1 1)
                                                    (list 1 1)
                                                    (list 1 1)
                                                    (list 1 1)
                                                    (list 1 1))))
              (list (list 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1)
                    (list 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1)))

; tokens-by-spine
(check-expect (tokens-by-spine (list (list KERN-TOKEN))
                               (list (list 1)))
              (list (list (list KERN-TOKEN))))
(check-expect (tokens-by-spine (list (list KERN-TOKEN KERN-TOKEN))
                               (list (list 1) (list 1)))
              (list (list (list KERN-TOKEN))
                    (list (list KERN-TOKEN))))
(check-expect (tokens-by-spine (list (list KERN-TOKEN KERN-TOKEN)
                                     (list CLEF-F4 CLEF-G2))
                               (list (list 1
                                           1)
                                     (list 1
                                           1)))
              (list (list (list KERN-TOKEN)
                          (list CLEF-F4))
                    (list (list KERN-TOKEN)
                          (list CLEF-G2))))
(check-expect (tokens-by-spine (list (list KERN-TOKEN)
                                     (list SPINE-SPLIT)
                                     (list LEFT-SPLIT RIGHT-SPLIT))
                               (list (list 1
                                           1
                                           2)))
              (list (list (list KERN-TOKEN)
                          (list SPINE-SPLIT)
                          (list LEFT-SPLIT RIGHT-SPLIT))))
(check-expect (tokens-by-spine (list (list KERN-TOKEN KERN-TOKEN)
                                     (list CLEF-F4 CLEF-G2)
                                     (list SPINE-SPLIT NULL)
                                     (list LEFT-SPLIT RIGHT-SPLIT 4AAA))
                               (list (list 1
                                           1
                                           1
                                           2)
                                     (list 1
                                           1
                                           1
                                           1)))
              (list (list (list KERN-TOKEN)
                          (list CLEF-F4)
                          (list SPINE-SPLIT)
                          (list LEFT-SPLIT RIGHT-SPLIT))
                    (list (list KERN-TOKEN)
                          (list CLEF-G2)
                          (list NULL)
                          (list 4AAA))))

; lololot->logs
(check-expect (lololot->logs (tokens-by-spine (list (list KERN-TOKEN))
                                              (list (list 1))))
              (list (global-spine (list (list KERN-TOKEN)) 0)))
(check-expect (lololot->logs (tokens-by-spine (list
                                                (list KERN-TOKEN KERN-TOKEN))
                                              (list (list 1) (list 1))))
              (list (global-spine (list (list KERN-TOKEN)) 0)
                    (global-spine (list (list KERN-TOKEN)) 1)))

; logs->lolos
(check-expect (logs->lolos (list (global-spine (list (list KERN-TOKEN)) 0)))
              (list (list "**kern")))
(check-expect (logs->lolos (list (global-spine (list (list KERN-TOKEN)) 0)
                                 (global-spine (list (list KERN-TOKEN)) 1)))
              (list (list "**kern") (list "**kern")))

(test)
