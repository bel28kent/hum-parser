#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hum-parser: tests for spine-parser
;;    NB: also tested in spine-parser-scriabin-test
;;        and count-and-order-tests
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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

#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  hum-parser: tests for extract-spine-arity
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require "../../../parser/data-definitions/data-definitions.rkt"
         "../../../parser/functions/abstract.rkt"
         "../../../parser/functions/extract-spine-arity.rkt"
         "../../../parser/functions/file.rkt"
         test-engine/racket-tests)

(define TEST-TOKEN-1 (token "**kern" EXCLUSIVE-INTERPRETATION 3 0))
(define TEST-TOKEN-2 (token "*^"     SPINE-SPLIT 3 0))
(define TEST-TOKEN-3 (token "*v"     SPINE-JOIN 3 0))
(define TEST-TOKEN-4 (token "4a"     SPINE-DATA 3 0))

(define TEST-RECORD-1 (record "**kern" TOKEN (list TEST-TOKEN-1) 3))
(define TEST-RECORD-2 (record "*^"     TOKEN (list TEST-TOKEN-2) 3))
(define TEST-RECORD-3 (record "*v"     TOKEN (list TEST-TOKEN-3) 3))
(define TEST-RECORD-4 (record "4a"     TOKEN (list TEST-TOKEN-4) 3))

(define SPLIT (record "*\t*^\t*"
                      TOKEN
                      (list (token "*" NULL-INTERPRETATION 3 0)
                            (token "*^" SPINE-SPLIT 3 1)
                            (token "*" NULL-INTERPRETATION 3 2))
                      3))
(define SECOND-SPLIT (record "*\t*^\t*\t*"
                             TOKEN
                             (list (token "*" NULL-INTERPRETATION 4 0)
                                   (token "*^" SPINE-SPLIT 4 1)
                                   (token "*" NULL-INTERPRETATION 4 2)
                                   (token "*" NULL-INTERPRETATION 4 3))
                             4))
(define THIRD-SPLIT (record "*\t*\t*^\t*\t*"
                            TOKEN
                            (list (token "*" NULL-INTERPRETATION 5 0)
                                  (token "*" NULL-INTERPRETATION 5 1)
                                  (token "*^" SPINE-SPLIT 5 2)
                                  (token "*" NULL-INTERPRETATION 5 3)
                                  (token "*" NULL-INTERPRETATION 5 4))
                            5))
(define SPLIT-LEFT (record "*^\t*\t*"
                           TOKEN
                           (list (token "*^" SPINE-SPLIT 3 0)
                                 (token "*" NULL-INTERPRETATION 3 1)
                                 (token "*" NULL-INTERPRETATION 3 2))
                           3))
(define SPLIT-RIGHT (record "*\t*\t*^"
                            TOKEN
                            (list (token "*" NULL-INTERPRETATION 3 0)
                                  (token "*" NULL-INTERPRETATION 3 1)
                                  (token "*^" SPINE-SPLIT 3 2))
                            3))
(define AFTER-SPLIT (record "4A\t4a\t4aa\t4aaa"
                            TOKEN
                            (list (token "4A" SPINE-DATA 4 0)
                                  (token "4a" SPINE-DATA 4 1)
                                  (token "4aa" SPINE-DATA 4 2)
                                  (token "4aaa" SPINE-DATA 4 3))
                            4))
(define THIRD-JOIN-A (record "*\t*v\t*v\t*\t*\t*"
                             TOKEN
                             (list (token "*" NULL-INTERPRETATION 1 0)
                                   (token "*v" SPINE-JOIN 1 1)
                                   (token "*v" SPINE-JOIN 1 2)
                                   (token "*" NULL-INTERPRETATION 1 3)
                                   (token "*" NULL-INTERPRETATION 1 4)
                                   (token "*" NULL-INTERPRETATION 1 5))
                             1))
(define THIRD-JOIN-B (record "*\t*\t*v\t*v\t*\t*"
                             TOKEN
                             (list (token "*" NULL-INTERPRETATION 1 0)
                                   (token "*" NULL-INTERPRETATION 1 1)
                                   (token "*v" SPINE-JOIN 1 2)
                                   (token "*v" SPINE-JOIN 1 3)
                                   (token "*" NULL-INTERPRETATION 1 4)
                                   (token "*" NULL-INTERPRETATION 1 5))
                             1))
(define THIRD-JOIN-C (record "*\t*\t*\t*v\t*v\t*"
                             TOKEN
                             (list (token "*" NULL-INTERPRETATION 1 0)
                                   (token "*" NULL-INTERPRETATION 1 1)
                                   (token "*" NULL-INTERPRETATION 1 2)
                                   (token "*v" SPINE-JOIN 1 3)
                                   (token "*v" SPINE-JOIN 1 4)
                                   (token "*" NULL-INTERPRETATION 1 5))
                             1))
(define SECOND-JOIN (record "*\t*\t*v\t*v\t*"
                            TOKEN
                            (list (token "*" NULL-INTERPRETATION 2 0)
                                  (token "*" NULL-INTERPRETATION 2 1)
                                  (token "*v" SPINE-JOIN 2 2)
                                  (token "*v" SPINE-JOIN 2 3)
                                  (token "*" NULL-INTERPRETATION 2 4))
                            2))
(define JOIN (record "*\t*v\t*v\t*"
                     TOKEN
                     (list (token "*" NULL-INTERPRETATION 3 0)
                           (token "*v" SPINE-JOIN 3 1)
                           (token "*v" SPINE-JOIN 3 2)
                           (token "*" NULL-INTERPRETATION 3 3))
                     3))
(define JOIN-LEFT (record "*v\t*v\t*\t*"
                          TOKEN
                          (list (token "*v" SPINE-JOIN 3 0)
                                (token "*v" SPINE-JOIN 3 1)
                                (token "*" NULL-INTERPRETATION 3 2)
                                (token "*" NULL-INTERPRETATION 3 3))
                          3))
(define JOIN-RIGHT (record "*\t*\t*v\t*v"
                           TOKEN
                           (list (token "*" NULL-INTERPRETATION 3 0)
                                 (token "*" NULL-INTERPRETATION 3 1)
                                 (token "*v" SPINE-JOIN 3 2)
                                 (token "*v" SPINE-JOIN 3 3))
                           3))
(define AFTER-JOIN (record "4A\t4a\t4aaa"
                           TOKEN
                           (list (token "4A" SPINE-DATA 4 0)
                                 (token "4a" SPINE-DATA 4 1)
                                 (token "4aaa" SPINE-DATA 4 2))
                           4))
(define BERG (path->hfile "../data/berg01.pc"))
(define SIM (path->hfile "../../count-and-order-tests/data/order/spine-splits-simultaneous.krn"))
(define 3-J (path->hfile "../../count-and-order-tests/data/order/more-than-two-spine-joins.krn"))
(define S-J-A (path->hfile "../../count-and-order-tests/data/order/spine-splits-and-joins-a.krn"))
(define S-J-B (path->hfile "../../count-and-order-tests/data/order/spine-splits-and-joins-b.krn"))
(define S-J-C (path->hfile "../../count-and-order-tests/data/order/spine-splits-and-joins-c.krn"))

; extract-spine-arity
(check-expect (extract-spine-arity BERG) (spine-arity 2 (list (list 1 1)
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
(check-expect (extract-spine-arity SIM) (spine-arity 1 (list (list 1)
                                                             (list 1)
                                                             (list 2)
                                                             (list 4)
                                                             (list 4)
                                                             (list 4)
                                                             (list 4)
                                                             (list 3)
                                                             (list 2)
                                                             (list 1))))
(check-expect (extract-spine-arity 3-J) (spine-arity 1 (list (list 1)
                                                             (list 1)
                                                             (list 2)
                                                             (list 3)
                                                             (list 3)
                                                             (list 3)
                                                             (list 3)
                                                             (list 1))))
(check-expect (extract-spine-arity S-J-A) (spine-arity 1 (list (list 1)
                                                               (list 1)
                                                               (list 2)
                                                               (list 3)
                                                               (list 3)
                                                               (list 3)
                                                               (list 3)
                                                               (list 3)
                                                               (list 3)
                                                               (list 3)
                                                               (list 3)
                                                               (list 3)
                                                               (list 3)
                                                               (list 3)
                                                               (list 3)
                                                               (list 2)
                                                               (list 1))))
(check-expect (extract-spine-arity S-J-B) (spine-arity 2 (list (list 1 1)
                                                               (list 1 1)
                                                               (list 2 2)
                                                               (list 3 2)
                                                               (list 3 2)
                                                               (list 3 2)
                                                               (list 3 2)
                                                               (list 1 3)
                                                               (list 1 3)
                                                               (list 1 3)
                                                               (list 1 3)
                                                               (list 1 2)
                                                               (list 1 1))))
(check-expect (extract-spine-arity S-J-C) (spine-arity 2 (list (list 1 1)
                                                               (list 1 1)
                                                               (list 2 2)
                                                               (list 2 3)
                                                               (list 2 3)
                                                               (list 2 3)
                                                               (list 2 3)
                                                               (list 3 1)
                                                               (list 3 1)
                                                               (list 3 1)
                                                               (list 3 1)
                                                               (list 2 1)
                                                               (list 1 1))))

; lolon
(check-expect (lolon (list TEST-RECORD-1)) (list (list 1)))
(check-expect (lolon (filter-type record-type
                                  TOKEN
                                  (hfile-records BERG)))
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
                    (list 1 1)))

; lon-caller
(check-expect (lon-caller SPLIT (list 1 1 1)) (list 1 2 1))
(check-expect (lon-caller JOIN (list 1 2 1)) (list 1 1 1))
(check-expect (lon-caller (record "4a" TOKEN (list (token "4a" SPINE-DATA 9 0)) 9)
                          (list 1))
              (list 1))

; previous-spine-struct?
(check-expect (previous-spine-struct? TEST-RECORD-1) #f)
(check-expect (previous-spine-struct? TEST-RECORD-2) #t)
(check-expect (previous-spine-struct? TEST-RECORD-3) #t)
(check-expect (previous-spine-struct? TEST-RECORD-4) #f)
(check-expect (previous-spine-struct?
               (record "*\t*^\t*\t*"
                       TOKEN
                       (list (token "*" NULL-INTERPRETATION 20 0)
                             (token "*^" SPINE-SPLIT 20 1)
                             (token "*" NULL-INTERPRETATION 20 2)
                             (token "*" NULL-INTERPRETATION 20 3))
                       20))
              #t)

; split-or-join-token?
(check-expect (split-or-join-token? TEST-TOKEN-1) #f)
(check-expect (split-or-join-token? TEST-TOKEN-2) #t)
(check-expect (split-or-join-token? TEST-TOKEN-3) #t)
(check-expect (split-or-join-token? TEST-TOKEN-4) #f)

; struct-lon
(check-expect (struct-lon SPLIT (list 1 1 1)) (list 1 2 1))
(check-expect (struct-lon SPLIT-LEFT (list 1 1 1)) (list 2 1 1))
(check-expect (struct-lon SPLIT-RIGHT (list 1 1 1)) (list 1 1 2))
(check-expect (struct-lon SECOND-SPLIT (list 1 2 1)) (list 1 3 1))
(check-expect (struct-lon THIRD-SPLIT (list 1 3 1)) (list 1 4 1))
(check-expect (struct-lon THIRD-JOIN-A (list 1 4 1)) (list 1 3 1))
(check-expect (struct-lon THIRD-JOIN-B (list 1 4 1)) (list 1 3 1))
(check-expect (struct-lon THIRD-JOIN-C (list 1 4 1)) (list 1 3 1))
(check-expect (struct-lon SECOND-JOIN (list 1 3 1)) (list 1 2 1))
(check-expect (struct-lon JOIN (list 1 2 1)) (list 1 1 1))
(check-expect (struct-lon JOIN-LEFT (list 2 1 1)) (list 1 1 1))
(check-expect (struct-lon JOIN-RIGHT (list 1 1 2)) (list 1 1 1))

; one-per-spine
(check-expect (one-per-spine 5) (list 1 1 1 1 1))

(test)
