#lang racket

#|
	Data for spine parsing function tests.
|#

(require (only-in "../../../parser/file-fn.rkt" HUM-PARSER-PATH path->hfile)
         "../../../parser/HumdrumSyntax.rkt")

(provide berg-hfile
         KERN-TOKEN
         CLEF-G2
         CLEF-F4
         SPLIT-TOKEN
         NULL
         LEFT-SPLIT
         RIGHT-SPLIT
         4AAA
         TEST-TOKEN-1 TEST-TOKEN-2 TEST-TOKEN-3 TEST-TOKEN-4
         TEST-RECORD-1 TEST-RECORD-2 TEST-RECORD-3 TEST-RECORD-4
         SPLIT SECOND-SPLIT THIRD-SPLIT
         SPLIT-LEFT SPLIT-RIGHT
         AFTER-SPLIT
         THIRD-JOIN-A THIRD-JOIN-B THIRD-JOIN-C
         JOIN SECOND-JOIN
         JOIN-LEFT JOIN-RIGHT
         AFTER-JOIN)

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
 (define JOIN (record "*\t*v\t*v\t*"
                      'TandemInterpretation
                      (list (token "*" 'NullInterpretation 3 0)
                            (token "*v" 'SpineJoin 3 1)
                            (token "*v" 'SpineJoin 3 2)
                            (token "*" 'NullInterpretation 3 3))
                      3))
(define SECOND-JOIN (record "*\t*\t*v\t*v\t*"
                            'TandemInterpretation
                            (list (token "*" 'NullInterpretation 2 0)
                                  (token "*" 'NullInterpretation 2 1)
                                  (token "*v" 'SpineJoin 2 2)
                                  (token "*v" 'SpineJoin 2 3)
                                  (token "*" 'NullInterpretation 2 4))
                            2))
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
