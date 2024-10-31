#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hum-parser: tests for spine-parser
;;    also tested in spine-parser-scriabin-test
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require "../../../parser/data-definitions/data-definitions.rkt"
         (only-in "../../../parser/functions/file.rkt"
                  path->hfile)
         "../../../parser/functions/spine-parser.rkt"
         test-engine/racket-tests)

(define KERN-TOKEN  (token "**kern" "ExclusiveInterpretation" 0 0))
(define CLEF-G2     (token "*clefG2" "Clef" 1 0))
(define CLEF-F4     (token "*clefF4" "Clef" 1 0))
(define SPLIT-TOKEN (token "*^" "SpineSplit" 1 0))
(define NULL        (token "*" "NullInterpretation" 1 0))
(define LEFT-SPLIT  (token "4a" "SpineData" 2 0))
(define RIGHT-SPLIT (token "4aa" "SpineData" 2 0))
(define 4AAA        (token "4aaa" "SpineData" 2 0))

(define berg-hfile (path->hfile "../data/berg01.pc"))

; spine-parser
(check-expect (spine-parser berg-hfile)
              (list (global-spine #f
                                  (list
                                    (list
                                      (token "**pc" EXCLUSIVE-INTERPRETATION 5 0))
                                    (list (token "*X:" KEY-LABEL 6 0))
                                    (list (token "0" SPINE-DATA 7 0))
                                    (list (token "1" SPINE-DATA 8 0))
                                    (list (token "3" SPINE-DATA 9 0))
                                    (list (token "8" SPINE-DATA 10 0))
                                    (list (token "4" SPINE-DATA 11 0))
                                    (list (token "9" SPINE-DATA 12 0))
                                    (list (token "10" SPINE-DATA 13 0))
                                    (list (token "7" SPINE-DATA 14 0))
                                    (list (token "6" SPINE-DATA 15 0))
                                    (list (token "5" SPINE-DATA 16 0))
                                    (list (token "11" SPINE-DATA 17 0))
                                    (list (token "2" SPINE-DATA 18 0))
                                    (list (token "*-" SPINE-TERMINATOR 19 0)))
                                  0)
                    (global-spine KERN
                                  (list (list (token "**kern" EXCLUSIVE-INTERPRETATION 5 1))
                                        (list (token "*X:" KEY-LABEL 6 1))
                                        (list (token "F" SPINE-DATA 7 1))
                                        (list (token "F#" SPINE-DATA 8 1))
                                        (list (token "G#" SPINE-DATA 9 1))
                                        (list (token "C#" SPINE-DATA 10 1))
                                        (list (token "A" SPINE-DATA 11 1))
                                        (list (token "D" SPINE-DATA 12 1))
                                        (list (token "E-" SPINE-DATA 13 1))
                                        (list (token "C" SPINE-DATA 14 1))
                                        (list (token "B" SPINE-DATA 15 1))
                                        (list (token "B-" SPINE-DATA 16 1))
                                        (list (token "E" SPINE-DATA 17 1))
                                        (list (token "G" SPINE-DATA 18 1))
                                        (list (token "*-" SPINE-TERMINATOR 19 1)))
                                  1)))

; unwrap
(check-expect (unwrap berg-hfile)
              (list (list (token "**pc" EXCLUSIVE-INTERPRETATION 5 0)
                          (token "**kern" EXCLUSIVE-INTERPRETATION 5 1))
                    (list (token "*X:" KEY-LABEL 6 0)
                          (token "*X:" KEY-LABEL 6 1))
                    (list (token "0" SPINE-DATA 7 0)
                          (token "F" SPINE-DATA 7 1))
                    (list (token "1" SPINE-DATA 8 0)
                          (token "F#" SPINE-DATA 8 1))
                    (list (token "3" SPINE-DATA 9 0)
                          (token "G#" SPINE-DATA 9 1))
                    (list (token "8" SPINE-DATA 10 0)
                          (token "C#" SPINE-DATA 10 1))
                    (list (token "4" SPINE-DATA 11 0)
                          (token "A" SPINE-DATA 11 1))
                    (list (token "9" SPINE-DATA 12 0)
                          (token "D" SPINE-DATA 12 1))
                    (list (token "10" SPINE-DATA 13 0)
                          (token "E-" SPINE-DATA 13 1))
                    (list (token "7" SPINE-DATA 14 0)
                          (token "C" SPINE-DATA 14 1))
                    (list (token "6" SPINE-DATA 15 0)
                          (token "B" SPINE-DATA 15 1))
                    (list (token "5" SPINE-DATA 16 0)
                          (token "B-" SPINE-DATA 16 1))
                    (list (token "11" SPINE-DATA 17 0)
                          (token "E" SPINE-DATA 17 1))
                    (list (token "2" SPINE-DATA 18 0)
                          (token "G" SPINE-DATA 18 1))
                    (list (token "*-" SPINE-TERMINATOR 19 0)
                          (token "*-" SPINE-TERMINATOR 19 1))))

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
              (list (global-spine KERN (list (list KERN-TOKEN)) 0)))
(check-expect (lololot->logs (tokens-by-spine (list
                                                (list KERN-TOKEN KERN-TOKEN))
                                              (list (list 1) (list 1))))
              (list (global-spine KERN (list (list KERN-TOKEN)) 0)
                    (global-spine KERN (list (list KERN-TOKEN)) 1)))

; logs->lolos
(check-expect (logs->lolos (list (global-spine KERN
                                               (list (list KERN-TOKEN))
                                               0)))
              (list (list "**kern")))
(check-expect (logs->lolos (list (global-spine KERN
                                               (list (list KERN-TOKEN))
                                               0)
                                 (global-spine KERN
                                               (list (list KERN-TOKEN))
                                               1)))
              (list (list "**kern") (list "**kern")))

(test)
