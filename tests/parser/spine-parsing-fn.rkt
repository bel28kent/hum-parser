#lang racket

#|
	Tests for spine parsing functions.
|#

(require (only-in "../../parser/file-fn.rkt" HUM-PARSER-PATH path->hfile)
         "../../parser/abstract-fn.rkt"
         "../../parser/spine-parsing-fn.rkt"
         "../../parser/HumdrumSyntax.rkt"
         test-engine/racket-tests)

(define berg-hfile (path->hfile (string-append HUM-PARSER-PATH "/tests/parser/data/berg01.pc")))

(define KERN-TOKEN  (token "**kern" 'ExclusiveInterpretation 0 0))
(define CLEF-G2     (token "*clefG2" 'Clef 1 0))
(define CLEF-F4     (token "*clefF4" 'Clef 1 0))
(define SPLIT-TOKEN (token "*^" 'SpineSplit 1 0))
(define NULL        (token "*" 'NullInterpretation 1 0))
(define LEFT-SPLIT  (token "4a" 'SpineData 2 0))
(define RIGHT-SPLIT (token "4aa" 'SpineData 2 0))
(define 4AAA        (token "4aaa" 'SpineData 2 0))

(define TEST-TOKEN-1 (token "**kern" 'ExclusiveInterpretation 3 0))
(define TEST-TOKEN-2 (token "*^" 'SpineSplit 3 0))
(define TEST-TOKEN-3 (token "*v" 'SpineJoin 3 0))
(define TEST-TOKEN-4 (token "4a" 'SpineData 3 0))

(define TEST-RECORD-1 (record "**kern" 'Token (list TEST-TOKEN-1) 3))
(define TEST-RECORD-2 (record "*^" 'Token (list TEST-TOKEN-2) 3))
(define TEST-RECORD-3 (record "*v" 'Token (list TEST-TOKEN-3) 3))
(define TEST-RECORD-4 (record "4a" 'Token (list TEST-TOKEN-4) 3))

(define SPLIT (record "*\t*^\t*"
                      'TandemInterpretation
                      (list (token "*" 'NullInterpretation 3 0)
                            (token "*^" 'SpineSplit 3 1)
                            (token "*" 'NullInterpretation 3 2))
                      3))
(define SECOND-SPLIT (record "*\t*^\t*\t*"
                             'TandemInterpretation
                             (list (token "*" 'NullInterpretation 4 0)
                                   (token "*^" 'SpineSplit 4 1)
                                   (token "*" 'NullInterpretation 4 2)
                                   (token "*" 'NullInterpretation 4 3))
                             4))
(define THIRD-SPLIT (record "*\t*\t*^\t*\t*"
                            'TandemInterpretation
                            (list (token "*" 'NullInterpretation 5 0)
                                  (token "*" 'NullInterpretation 5 1)
                                  (token "*^" 'SpineSplit 5 2)
                                  (token "*" 'NullInterpretation 5 3)
                                  (token "*" 'NullInterpretation 5 4))
                            5))
(define SPLIT-LEFT (record "*^\t*\t*"
                           'TandemInterpretation
                           (list (token "*^" 'SpineSplit 3 0)
                                 (token "*" 'NullInterpretation 3 1)
                                 (token "*" 'NullInterpretation 3 2))
                           3))
(define SPLIT-RIGHT (record "*\t*\t*^"
                            'TandemInterpretation
                            (list (token "*" 'NullInterpretation 3 0)
                                  (token "*" 'NullInterpretation 3 1)
                                  (token "*^" 'SpineSplit 3 2))
                            3))
(define AFTER-SPLIT (record "4A\t4a\t4aa\t4aaa"
                            'Token
                            (list (token "4A" 'SpineData 4 0)
                                  (token "4a" 'SpineData 4 1)
                                  (token "4aa" 'SpineData 4 2)
                                  (token "4aaa" 'SpineData 4 3))
                            4))
(define THIRD-JOIN-A (record "*\t*v\t*v\t*\t*\t*"
                             'TandemInterpretation
                             (list (token "*" 'NullInterpretation 1 0)
                                   (token "*v" 'SpineJoin 1 1)
                                   (token "*v" 'SpineJoin 1 2)
                                   (token "*" 'NullInterpretation 1 3)
                                   (token "*" 'NullInterpretation 1 4)
                                   (token "*" 'NullInterpretation 1 5))
                             1))
(define THIRD-JOIN-B (record "*\t*\t*v\t*v\t*\t*"
                             'TandemInterpretation
                             (list (token "*" 'NullInterpretation 1 0)
                                   (token "*" 'NullInterpretation 1 1)
                                   (token "*v" 'SpineJoin 1 2)
                                   (token "*v" 'SpineJoin 1 3)
                                   (token "*" 'NullInterpretation 1 4)
                                   (token "*" 'NullInterpretation 1 5))
                             1))
(define THIRD-JOIN-C (record "*\t*\t*\t*v\t*v\t*"
                             'TandemInterpretation
                             (list (token "*" 'NullInterpretation 1 0)
                                   (token "*" 'NullInterpretation 1 1)
                                   (token "*" 'NullInterpretation 1 2)
                                   (token "*v" 'SpineJoin 1 3)
                                   (token "*v" 'SpineJoin 1 4)
                                   (token "*" 'NullInterpretation 1 5))
                             1))
(define SECOND-JOIN (record "*\t*\t*v\t*v\t*"
                            'TandemInterpretation
                            (list (token "*" 'NullInterpretation 2 0)
                                  (token "*" 'NullInterpretation 2 1)
                                  (token "*v" 'SpineJoin 2 2)
                                  (token "*v" 'SpineJoin 2 3)
                                  (token "*" 'NullInterpretation 2 4))
                            2))
(define JOIN (record "*\t*v\t*v\t*"
                     'TandemInterpretation
                     (list (token "*" 'NullInterpretation 3 0)
                           (token "*v" 'SpineJoin 3 1)
                           (token "*v" 'SpineJoin 3 2)
                           (token "*" 'NullInterpretation 3 3))
                     3))
(define JOIN-LEFT (record "*v\t*v\t*\t*"
                          'TandemInterpretation
                          (list (token "*v" 'SpineJoin 3 0)
                                (token "*v" 'SpineJoin 3 1)
                                (token "*" 'NullInterpretation 3 2)
                                (token "*" 'NullInterpretation 3 3))
                          3))
(define JOIN-RIGHT (record "*\t*\t*v\t*v"
                           'TandemInterpretation
                           (list (token "*" 'NullInterpretation 3 0)
                                 (token "*" 'NullInterpretation 3 1)
                                 (token "*v" 'SpineJoin 3 2)
                                 (token "*v" 'SpineJoin 3 3))
                           3))
(define AFTER-JOIN (record "4A\t4a\t4aaa"
                           'Token
                           (list (token "4A" 'SpineData 4 0)
                                 (token "4a" 'SpineData 4 1)
                                 (token "4aaa" 'SpineData 4 2))
                           4))

; spine-parser
(check-expect (spine-parser berg-hfile)
              (list (global-spine 'Unknown
                                  (list
                                    (list
                                      (token "**pc" 'ExclusiveInterpretation 5 0))
                                    (list (token "*X:" 'KeyLabel 6 0))
                                    (list (token "0" 'SpineData 7 0))
                                    (list (token "1" 'SpineData 8 0))
                                    (list (token "3" 'SpineData 9 0))
                                    (list (token "8" 'SpineData 10 0))
                                    (list (token "4" 'SpineData 11 0))
                                    (list (token "9" 'SpineData 12 0))
                                    (list (token "10" 'SpineData 13 0))
                                    (list (token "7" 'SpineData 14 0))
                                    (list (token "6" 'SpineData 15 0))
                                    (list (token "5" 'SpineData 16 0))
                                    (list (token "11" 'SpineData 17 0))
                                    (list (token "2" 'SpineData 18 0))
                                    (list (token "*-" 'SpineTerminator 19 0)))
                                  0)
                    (global-spine 'Kern
                                  (list (list (token "**kern" 'ExclusiveInterpretation 5 1))
                                        (list (token "*X:" 'KeyLabel 6 1))
                                        (list (token "F" 'SpineData 7 1))
                                        (list (token "F#" 'SpineData 8 1))
                                        (list (token "G#" 'SpineData 9 1))
                                        (list (token "C#" 'SpineData 10 1))
                                        (list (token "A" 'SpineData 11 1))
                                        (list (token "D" 'SpineData 12 1))
                                        (list (token "E-" 'SpineData 13 1))
                                        (list (token "C" 'SpineData 14 1))
                                        (list (token "B" 'SpineData 15 1))
                                        (list (token "B-" 'SpineData 16 1))
                                        (list (token "E" 'SpineData 17 1))
                                        (list (token "G" 'SpineData 18 1))
                                        (list (token "*-" 'SpineTerminator 19 1)))
                                  1)))

; unwrap
(check-expect (unwrap berg-hfile)
              (list (list (token "**pc" 'ExclusiveInterpretation 5 0)
                          (token "**kern" 'ExclusiveInterpretation 5 1))
                    (list (token "*X:" 'KeyLabel 6 0)
                          (token "*X:" 'KeyLabel 6 1))
                    (list (token "0" 'SpineData 7 0)
                          (token "F" 'SpineData 7 1))
                    (list (token "1" 'SpineData 8 0)
                          (token "F#" 'SpineData 8 1))
                    (list (token "3" 'SpineData 9 0)
                          (token "G#" 'SpineData 9 1))
                    (list (token "8" 'SpineData 10 0)
                          (token "C#" 'SpineData 10 1))
                    (list (token "4" 'SpineData 11 0)
                          (token "A" 'SpineData 11 1))
                    (list (token "9" 'SpineData 12 0)
                          (token "D" 'SpineData 12 1))
                    (list (token "10" 'SpineData 13 0)
                          (token "E-" 'SpineData 13 1))
                    (list (token "7" 'SpineData 14 0)
                          (token "C" 'SpineData 14 1))
                    (list (token "6" 'SpineData 15 0)
                          (token "B" 'SpineData 15 1))
                    (list (token "5" 'SpineData 16 0)
                          (token "B-" 'SpineData 16 1))
                    (list (token "11" 'SpineData 17 0)
                          (token "E" 'SpineData 17 1))
                    (list (token "2" 'SpineData 18 0)
                          (token "G" 'SpineData 18 1))
                    (list (token "*-" 'SpineTerminator 19 0)
                          (token "*-" 'SpineTerminator 19 1))))

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
                                     (list SPLIT-TOKEN)
                                     (list LEFT-SPLIT RIGHT-SPLIT))
                               (list (list 1
                                           1
                                           2)))
              (list (list (list KERN-TOKEN)
                          (list SPLIT-TOKEN)
                          (list LEFT-SPLIT RIGHT-SPLIT))))
(check-expect (tokens-by-spine (list (list KERN-TOKEN KERN-TOKEN)
                                     (list CLEF-F4 CLEF-G2)
                                     (list SPLIT-TOKEN NULL)
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
                          (list SPLIT-TOKEN)
                          (list LEFT-SPLIT RIGHT-SPLIT))
                    (list (list KERN-TOKEN)
                          (list CLEF-G2)
                          (list NULL)
                          (list 4AAA))))

; gspine-wrapper
(check-expect (gspine-wrapper (tokens-by-spine (list (list KERN-TOKEN))
                                               (list (list 1))))
              (list (global-spine 'Kern (list (list KERN-TOKEN)) 0)))
(check-expect (gspine-wrapper (tokens-by-spine (list (list KERN-TOKEN KERN-TOKEN))
                                               (list (list 1) (list 1))))
              (list (global-spine 'Kern (list (list KERN-TOKEN)) 0)
                    (global-spine 'Kern (list (list KERN-TOKEN)) 1)))

; gspines->strings
(check-expect (gspines->strings (list (global-spine 'Kern
                                                    (list (list KERN-TOKEN))
                                                    0)))
              (list (list "**kern")))
(check-expect (gspines->strings (list (global-spine 'Kern
                                                    (list (list KERN-TOKEN))
                                                    0)
                                      (global-spine 'Kern
                                                    (list (list KERN-TOKEN))
                                                    1)))
              (list (list "**kern") (list "**kern")))

; extract-spine-arity
(check-expect (extract-spine-arity berg-hfile) (spine-arity 2 (list (list 1 1)
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

; get-byrecord
(check-expect (get-byrecord (list TEST-RECORD-1)) (list (list 1)))
(check-expect (get-byrecord (filter (λ (r) (is-spine-content-type? (record-type r)))
                                    (humdrum-file-records berg-hfile)))
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

; maybe-spine-structure
(check-expect (maybe-spine-structure SPLIT (list 1 1 1)) (list 1 2 1))
(check-expect (maybe-spine-structure JOIN (list 1 2 1)) (list 1 1 1))
(check-expect (maybe-spine-structure (record "4a" 'Token (list (token "4a" 'SpineData 9 0)) 9)
                                     (list 1))
              (list 1))

; was-spine-struct?
(check-expect (was-spine-struct? TEST-RECORD-1) #f)
(check-expect (was-spine-struct? TEST-RECORD-2) #t)
(check-expect (was-spine-struct? TEST-RECORD-3) #t)
(check-expect (was-spine-struct? TEST-RECORD-4) #f)
(check-expect (was-spine-struct?
               (record "*\t*^\t*\t*"
                       'Token
                       (list (token "*" 'NullInterpretation 20 0)
                             (token "*^" 'SpineSplit 20 1)
                             (token "*" 'NullInterpretation 20 2)
                             (token "*" 'NullInterpretation 20 3))
                       20))
              #t)

; split-or-join-token?
(check-expect (split-or-join-token? TEST-TOKEN-1) #f)
(check-expect (split-or-join-token? TEST-TOKEN-2) #t)
(check-expect (split-or-join-token? TEST-TOKEN-3) #t)
(check-expect (split-or-join-token? TEST-TOKEN-4) #f)

; after-struct
(check-expect (after-struct SPLIT (list 1 1 1)) (list 1 2 1))
(check-expect (after-struct SPLIT-LEFT (list 1 1 1)) (list 2 1 1))
(check-expect (after-struct SPLIT-RIGHT (list 1 1 1)) (list 1 1 2))
(check-expect (after-struct SECOND-SPLIT (list 1 2 1)) (list 1 3 1))
(check-expect (after-struct THIRD-SPLIT (list 1 3 1)) (list 1 4 1))
(check-expect (after-struct THIRD-JOIN-A (list 1 4 1)) (list 1 3 1))
(check-expect (after-struct THIRD-JOIN-B (list 1 4 1)) (list 1 3 1))
(check-expect (after-struct THIRD-JOIN-C (list 1 4 1)) (list 1 3 1))
(check-expect (after-struct SECOND-JOIN (list 1 3 1)) (list 1 2 1))
(check-expect (after-struct JOIN (list 1 2 1)) (list 1 1 1))
(check-expect (after-struct JOIN-LEFT (list 2 1 1)) (list 1 1 1))
(check-expect (after-struct JOIN-RIGHT (list 1 1 2)) (list 1 1 1))

; one-per-spine
(check-expect (one-per-spine 5) (list 1 1 1 1 1))

(test)
