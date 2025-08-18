#lang racket/base

(require "../../../../../parser/HumdrumSyntax.rkt"
         "../../../../../parser/file-fn.rkt"
         "../../../../../parser/spine-parsing-fn.rkt"
         "../../../../../parser/humdrum-graph/HumdrumGraph.rkt"
         "../../../../../parser/humdrum-graph/hfile-to-hgraph-fn.rkt"
         "../../../../../parser/humdrum-graph/hgraph-to-hfile-fn.rkt"
         "../../../../../parser/linked-spine/LinkedSpine.rkt"
         "../../../../../parser/linked-spine/gspines-to-linked-spines-fn.rkt"
         test-engine/racket-tests)

;; Node definitions
(define TERM-21-0 (terminator-node (token "*-" 'SpineTerminator 21 0)))
(define M-20-0 (token-node (token "==" 'Measure 20 0) (box-immutable TERM-21-0)))
(define J-19-0 (token-node (token "*v" 'SpineJoin 19 0) (box-immutable M-20-0)))
(define J-19-1 (token-node (token "*v" 'SpineJoin 19 1) (box-immutable M-20-0)))
(define NULL-18-0 (token-node (token "*" 'NullInterpretation 18 0) (box-immutable J-19-0)))
(define J-18-1 (token-node (token "*v" 'SpineJoin 18 1) (box-immutable J-19-1)))
(define J-18-2 (token-node (token "*v" 'SpineJoin 18 2) (box-immutable J-19-1)))
(define 4c-17-0 (token-node (token "4c" 'SpineData 17 0) (box-immutable NULL-18-0)))
(define 4c-17-1 (token-node (token "4c" 'SpineData 17 1) (box-immutable J-18-1)))
(define 4c-17-2 (token-node (token "4c" 'SpineData 17 2) (box-immutable J-18-2)))
(define 4c-16-0 (token-node (token "4c" 'SpineData 16 0) (box-immutable 4c-17-0)))
(define 4c-16-1 (token-node (token "4c" 'SpineData 16 1) (box-immutable 4c-17-1)))
(define 4c-16-2 (token-node (token "4c" 'SpineData 16 2) (box-immutable 4c-17-2)))
(define 4c-15-0 (token-node (token "4c" 'SpineData 15 0) (box-immutable 4c-16-0)))
(define 4c-15-1 (token-node (token "4c" 'SpineData 15 1) (box-immutable 4c-16-1)))
(define 4c-15-2 (token-node (token "4c" 'SpineData 15 2) (box-immutable 4c-16-2)))
(define M-14-0 (token-node (token "=3" 'Measure 14 0) (box-immutable 4c-15-0)))
(define M-14-1 (token-node (token "=3" 'Measure 14 1) (box-immutable 4c-15-1)))
(define M-14-2 (token-node (token "=3" 'Measure 14 2) (box-immutable 4c-15-2)))
(define 4c-13-0 (token-node (token "4c" 'SpineData 13 0) (box-immutable M-14-0)))
(define 4c-13-1 (token-node (token "4c" 'SpineData 13 1) (box-immutable M-14-1)))
(define 4c-13-2 (token-node (token "4c" 'SpineData 13 2) (box-immutable M-14-2)))
(define 4c-12-0 (token-node (token "4c" 'SpineData 12 0) (box-immutable 4c-13-0)))
(define 4c-12-1 (token-node (token "4c" 'SpineData 12 1) (box-immutable 4c-13-1)))
(define 4c-12-2 (token-node (token "4c" 'SpineData 12 2) (box-immutable 4c-13-2)))
(define 4c-11-0 (token-node (token "4c" 'SpineData 11 0) (box-immutable 4c-12-0)))
(define 4c-11-1 (token-node (token "4c" 'SpineData 11 1) (box-immutable 4c-12-1)))
(define 4c-11-2 (token-node (token "4c" 'SpineData 11 2) (box-immutable 4c-12-2)))
(define M-10-0 (token-node (token "=2" 'Measure 10 0) (box-immutable 4c-11-0)))
(define M-10-1 (token-node (token "=2" 'Measure 10 1) (box-immutable 4c-11-1)))
(define M-10-2 (token-node (token "=2" 'Measure 10 2) (box-immutable 4c-11-2)))
(define 4c-9-0 (token-node (token "4c" 'SpineData 9 0) (box-immutable M-10-0)))
(define 4c-9-1 (token-node (token "4c" 'SpineData 9 1) (box-immutable M-10-1)))
(define 4c-9-2 (token-node (token "4c" 'SpineData 9 2) (box-immutable M-10-2)))
(define 4c-8-0 (token-node (token "4c" 'SpineData 8 0) (box-immutable 4c-9-0)))
(define 4c-8-1 (token-node (token "4c" 'SpineData 8 1) (box-immutable 4c-9-1)))
(define 4c-8-2 (token-node (token "4c" 'SpineData 8 2) (box-immutable 4c-9-2)))
(define 4c-7-0 (token-node (token "4c" 'SpineData 7 0) (box-immutable 4c-8-0)))
(define 4c-7-1 (token-node (token "4c" 'SpineData 7 1) (box-immutable 4c-8-1)))
(define 4c-7-2 (token-node (token "4c" 'SpineData 7 2) (box-immutable 4c-8-2)))
(define NULL-6-0 (token-node (token "*" 'NullInterpretation 6 0) (box-immutable 4c-7-0)))
(define S-6-1 (split-node (token "*^" 'SpineSplit 6 1)
                          (box-immutable 4c-7-1)
                          (box-immutable 4c-7-2)))
(define S-5-0 (split-node (token "*^" 'SpineSplit 5 0)
                          (box-immutable NULL-6-0)
                          (box-immutable S-6-1)))
(define TS-4-0 (token-node (token "*M3/4" 'TimeSignature 4 0) (box-immutable S-5-0)))
(define KL-3-0 (token-node (token "*a:" 'KeyLabel 3 0) (box-immutable TS-4-0)))
(define KS-2-0 (token-node (token "*k[]" 'KeySignature 2 0) (box-immutable KL-3-0)))
(define CL-1-0 (token-node (token "*clefG2" 'Clef 1 0) (box-immutable KS-2-0)))
(define KERN-0-0 (token-node (token "**kern" 'ExclusiveInterpretation 0 0) (box CL-1-0)))

(check-expect (path->hfile "../../data/count/one-spine-two-splits.krn")
              (hfile (list (record "**kern"
                                   'ExclusiveInterpretation
                                   (list (token "**kern" 'ExclusiveInterpretation 0 0))
                                   0)
                           (record "*clefG2" 'TandemInterpretation (list (token "*clefG2" 'Clef 1 0)) 1)
                           (record "*k[]" 'TandemInterpretation (list (token "*k[]" 'KeySignature 2 0)) 2)
                           (record "*a:" 'TandemInterpretation (list (token "*a:" 'KeyLabel 3 0)) 3)
                           (record "*M3/4" 'TandemInterpretation (list (token "*M3/4" 'TimeSignature 4 0)) 4)
                           (record "*^" 'TandemInterpretation (list (token "*^" 'SpineSplit 5 0)) 5)
                           (record "*\t*^"
                                   'TandemInterpretation
                                   (list (token "*" 'NullInterpretation 6 0)
                                         (token "*^" 'SpineSplit 6 1))
                                   6)
                           (record "4c\t4c\t4c"
                                   'Token
                                   (list (token "4c" 'SpineData 7 0)
                                         (token "4c" 'SpineData 7 1)
                                         (token "4c" 'SpineData 7 2))
                                   7)
                           (record "4c\t4c\t4c"
                                   'Token
                                   (list (token "4c" 'SpineData 8 0)
                                         (token "4c" 'SpineData 8 1)
                                         (token "4c" 'SpineData 8 2))
                                   8)
                           (record "4c\t4c\t4c"
                                   'Token
                                   (list (token "4c" 'SpineData 9 0)
                                         (token "4c" 'SpineData 9 1)
                                         (token "4c" 'SpineData 9 2))
                                   9)
                           (record "=2\t=2\t=2"
                                   'Measure
                                   (list (token "=2" 'Measure 10 0)
                                         (token "=2" 'Measure 10 1)
                                         (token "=2" 'Measure 10 2))
                                   10)
                           (record "4c\t4c\t4c"
                                   'Token
                                   (list (token "4c" 'SpineData 11 0)
                                         (token "4c" 'SpineData 11 1)
                                         (token "4c" 'SpineData 11 2))
                                   11)
                           (record "4c\t4c\t4c"
                                   'Token
                                   (list (token "4c" 'SpineData 12 0)
                                         (token "4c" 'SpineData 12 1)
                                         (token "4c" 'SpineData 12 2))
                                   12)
                           (record "4c\t4c\t4c"
                                   'Token
                                   (list (token "4c" 'SpineData 13 0)
                                         (token "4c" 'SpineData 13 1)
                                         (token "4c" 'SpineData 13 2))
                                   13)
                           (record "=3\t=3\t=3"
                                   'Measure
                                   (list (token "=3" 'Measure 14 0)
                                         (token "=3" 'Measure 14 1)
                                         (token "=3" 'Measure 14 2))
                                   14)
                           (record "4c\t4c\t4c"
                                   'Token
                                   (list (token "4c" 'SpineData 15 0)
                                         (token "4c" 'SpineData 15 1)
                                         (token "4c" 'SpineData 15 2))
                                   15)
                           (record "4c\t4c\t4c"
                                   'Token
                                   (list (token "4c" 'SpineData 16 0)
                                         (token "4c" 'SpineData 16 1)
                                         (token "4c" 'SpineData 16 2))
                                   16)
                           (record "4c\t4c\t4c"
                                   'Token
                                   (list (token "4c" 'SpineData 17 0)
                                         (token "4c" 'SpineData 17 1)
                                         (token "4c" 'SpineData 17 2))
                                   17)
                           (record "*\t*v\t*v"
                                   'TandemInterpretation
                                   (list (token "*" 'NullInterpretation 18 0)
                                         (token "*v" 'SpineJoin 18 1)
                                         (token "*v" 'SpineJoin 18 2))
                                   18)
                           (record "*v\t*v"
                                   'TandemInterpretation
                                   (list (token "*v" 'SpineJoin 19 0)
                                         (token "*v" 'SpineJoin 19 1))
                                   19)
                           (record "==" 'Measure (list (token "==" 'Measure 20 0)) 20)
                           (record "*-" 'TandemInterpretation (list (token "*-" 'SpineTerminator 21 0)) 21))))
(check-expect (spine-parser (hfile (list (record "**kern"
                                                 'ExclusiveInterpretation
                                                 (list (token "**kern" 'ExclusiveInterpretation 0 0))
                                                 0)
                                         (record "*clefG2" 'TandemInterpretation (list (token "*clefG2" 'Clef 1 0)) 1)
                                         (record "*k[]" 'TandemInterpretation (list (token "*k[]" 'KeySignature 2 0)) 2)
                                         (record "*a:" 'TandemInterpretation (list (token "*a:" 'KeyLabel 3 0)) 3)
                                         (record "*M3/4" 'TandemInterpretation (list (token "*M3/4" 'TimeSignature 4 0)) 4)
                                         (record "*^" 'TandemInterpretation (list (token "*^" 'SpineSplit 5 0)) 5)
                                         (record "*\t*^"
                                                 'TandemInterpretation
                                                 (list (token "*" 'NullInterpretation 6 0)
                                                       (token "*^" 'SpineSplit 6 1))
                                                 6)
                                         (record "4c\t4c\t4c"
                                                 'Token
                                                 (list (token "4c" 'SpineData 7 0)
                                                       (token "4c" 'SpineData 7 1)
                                                       (token "4c" 'SpineData 7 2))
                                                 7)
                                         (record "4c\t4c\t4c"
                                                 'Token
                                                 (list (token "4c" 'SpineData 8 0)
                                                       (token "4c" 'SpineData 8 1)
                                                       (token "4c" 'SpineData 8 2))
                                                 8)
                                         (record "4c\t4c\t4c"
                                                 'Token
                                                 (list (token "4c" 'SpineData 9 0)
                                                       (token "4c" 'SpineData 9 1)
                                                       (token "4c" 'SpineData 9 2))
                                                 9)
                                         (record "=2\t=2\t=2"
                                                 'Measure
                                                 (list (token "=2" 'Measure 10 0)
                                                       (token "=2" 'Measure 10 1)
                                                       (token "=2" 'Measure 10 2))
                                                 10)
                                         (record "4c\t4c\t4c"
                                                 'Token
                                                 (list (token "4c" 'SpineData 11 0)
                                                       (token "4c" 'SpineData 11 1)
                                                       (token "4c" 'SpineData 11 2))
                                                 11)
                                         (record "4c\t4c\t4c"
                                                 'Token
                                                 (list (token "4c" 'SpineData 12 0)
                                                       (token "4c" 'SpineData 12 1)
                                                       (token "4c" 'SpineData 12 2))
                                                 12)
                                         (record "4c\t4c\t4c"
                                                 'Token
                                                 (list (token "4c" 'SpineData 13 0)
                                                       (token "4c" 'SpineData 13 1)
                                                       (token "4c" 'SpineData 13 2))
                                                 13)
                                         (record "=3\t=3\t=3"
                                                 'Measure
                                                 (list (token "=3" 'Measure 14 0)
                                                       (token "=3" 'Measure 14 1)
                                                       (token "=3" 'Measure 14 2))
                                                 14)
                                         (record "4c\t4c\t4c"
                                                 'Token
                                                 (list (token "4c" 'SpineData 15 0)
                                                       (token "4c" 'SpineData 15 1)
                                                       (token "4c" 'SpineData 15 2))
                                                 15)
                                         (record "4c\t4c\t4c"
                                                 'Token
                                                 (list (token "4c" 'SpineData 16 0)
                                                       (token "4c" 'SpineData 16 1)
                                                       (token "4c" 'SpineData 16 2))
                                                 16)
                                         (record "4c\t4c\t4c"
                                                 'Token
                                                 (list (token "4c" 'SpineData 17 0)
                                                       (token "4c" 'SpineData 17 1)
                                                       (token "4c" 'SpineData 17 2))
                                                 17)
                                         (record "*\t*v\t*v"
                                                 'TandemInterpretation
                                                 (list (token "*" 'NullInterpretation 18 0)
                                                       (token "*v" 'SpineJoin 18 1)
                                                       (token "*v" 'SpineJoin 18 2))
                                                 18)
                                         (record "*v\t*v"
                                                 'TandemInterpretation
                                                 (list (token "*v" 'SpineJoin 19 0)
                                                       (token "*v" 'SpineJoin 19 1))
                                                 19)
                                         (record "==" 'Measure (list (token "==" 'Measure 20 0)) 20)
                                         (record "*-"
                                                 'TandemInterpretation
                                                 (list (token "*-" 'SpineTerminator 21 0))
                                                 21))))
              (list (global-spine 'Kern
                                  (list (list (token "**kern" 'ExclusiveInterpretation 0 0))
                                        (list (token "*clefG2" 'Clef 1 0))
                                        (list (token "*k[]" 'KeySignature 2 0))
                                        (list (token "*a:" 'KeyLabel 3 0))
                                        (list (token "*M3/4" 'TimeSignature 4 0))
                                        (list (token "*^" 'SpineSplit 5 0))
                                        (list (token "*" 'NullInterpretation 6 0)
                                              (token "*^" 'SpineSplit 6 1))
                                        (list (token "4c" 'SpineData 7 0)
                                              (token "4c" 'SpineData 7 1)
                                              (token "4c" 'SpineData 7 2))
                                        (list (token "4c" 'SpineData 8 0)
                                              (token "4c" 'SpineData 8 1)
                                              (token "4c" 'SpineData 8 2))
                                        (list (token "4c" 'SpineData 9 0)
                                              (token "4c" 'SpineData 9 1)
                                              (token "4c" 'SpineData 9 2))
                                        (list (token "=2" 'Measure 10 0)
                                              (token "=2" 'Measure 10 1)
                                              (token "=2" 'Measure 10 2))
                                        (list (token "4c" 'SpineData 11 0)
                                              (token "4c" 'SpineData 11 1)
                                              (token "4c" 'SpineData 11 2))
                                        (list (token "4c" 'SpineData 12 0)
                                              (token "4c" 'SpineData 12 1)
                                              (token "4c" 'SpineData 12 2))
                                        (list (token "4c" 'SpineData 13 0)
                                              (token "4c" 'SpineData 13 1)
                                              (token "4c" 'SpineData 13 2))
                                        (list (token "=3" 'Measure 14 0)
                                              (token "=3" 'Measure 14 1)
                                              (token "=3" 'Measure 14 2))
                                        (list (token "4c" 'SpineData 15 0)
                                              (token "4c" 'SpineData 15 1)
                                              (token "4c" 'SpineData 15 2))
                                        (list (token "4c" 'SpineData 16 0)
                                              (token "4c" 'SpineData 16 1)
                                              (token "4c" 'SpineData 16 2))
                                        (list (token "4c" 'SpineData 17 0)
                                              (token "4c" 'SpineData 17 1)
                                              (token "4c" 'SpineData 17 2))
                                        (list (token "*" 'NullInterpretation 18 0)
                                              (token "*v" 'SpineJoin 18 1)
                                              (token "*v" 'SpineJoin 18 2))
                                        (list (token "*v" 'SpineJoin 19 0)
                                              (token "*v" 'SpineJoin 19 1))
                                        (list (token "==" 'Measure 20 0))
                                        (list (token "*-" 'SpineTerminator 21 0)))
                                  0)))
(check-expect (hgraph->hfile
               (hgraph (root (list (list (leaf (token "**kern" 'ExclusiveInterpretation 0 0))
                                         (leaf (token "*clefG2" 'Clef 1 0))
                                         (leaf (token "*k[]" 'KeySignature 2 0))
                                         (leaf (token "*a:" 'KeyLabel 3 0))
                                         (leaf (token "*M3/4" 'TimeSignature 4 0))
                                         (parent (token "*^" 'SpineSplit 5 0)
                                                 (list (leaf (token "*" 'NullInterpretation 6 0))
                                                       (leaf (token "4c" 'SpineData 7 0))
                                                       (leaf (token "4c" 'SpineData 8 0))
                                                       (leaf (token "4c" 'SpineData 9 0))
                                                       (leaf (token "=2" 'Measure 10 0))
                                                       (leaf (token "4c" 'SpineData 11 0))
                                                       (leaf (token "4c" 'SpineData 12 0))
                                                       (leaf (token "4c" 'SpineData 13 0))
                                                       (leaf (token "=3" 'Measure 14 0))
                                                       (leaf (token "4c" 'SpineData 15 0))
                                                       (leaf (token "4c" 'SpineData 16 0))
                                                       (leaf (token "4c" 'SpineData 17 0))
                                                       (leaf (token "*" 'NullInterpretation 18 0))
                                                       (leaf (token "*v" 'SpineJoin 19 0)))
                                                 (list (parent (token "*^" 'SpineSplit 6 1)
                                                               (list (leaf (token "4c" 'SpineData 7 1))
                                                                     (leaf (token "4c" 'SpineData 8 1))
                                                                     (leaf (token "4c" 'SpineData 9 1))
                                                                     (leaf (token "=2" 'Measure 10 1))
                                                                     (leaf (token "4c" 'SpineData 11 1))
                                                                     (leaf (token "4c" 'SpineData 12 1))
                                                                     (leaf (token "4c" 'SpineData 13 1))
                                                                     (leaf (token "=3" 'Measure 14 1))
                                                                     (leaf (token "4c" 'SpineData 15 1))
                                                                     (leaf (token "4c" 'SpineData 16 1))
                                                                     (leaf (token "4c" 'SpineData 17 1))
                                                                     (leaf (token "*v" 'SpineJoin 18 1)))
                                                               (list (leaf (token "4c" 'SpineData 7 2))
                                                                     (leaf (token "4c" 'SpineData 8 2))
                                                                     (leaf (token "4c" 'SpineData 9 2))
                                                                     (leaf (token "=2" 'Measure 10 2))
                                                                     (leaf (token "4c" 'SpineData 11 2))
                                                                     (leaf (token "4c" 'SpineData 12 2))
                                                                     (leaf (token "4c" 'SpineData 13 2))
                                                                     (leaf (token "=3" 'Measure 14 2))
                                                                     (leaf (token "4c" 'SpineData 15 2))
                                                                     (leaf (token "4c" 'SpineData 16 2))
                                                                     (leaf (token "4c" 'SpineData 17 2))
                                                                     (leaf (token "*v" 'SpineJoin 18 2))))
                                                       (leaf (token "*v" 'SpineJoin 19 1))))
                                         (leaf (token "==" 'Measure 20 0))
                                         (leaf (token "*-" 'SpineTerminator 21 0)))))))
              (hfile (list (record "**kern"
                                   'ExclusiveInterpretation
                                   (list (token "**kern" 'ExclusiveInterpretation 0 0))
                                   0)
                           (record "*clefG2" 'TandemInterpretation (list (token "*clefG2" 'Clef 1 0)) 1)
                           (record "*k[]" 'TandemInterpretation (list (token "*k[]" 'KeySignature 2 0)) 2)
                           (record "*a:" 'TandemInterpretation (list (token "*a:" 'KeyLabel 3 0)) 3)
                           (record "*M3/4" 'TandemInterpretation (list (token "*M3/4" 'TimeSignature 4 0)) 4)
                           (record "*^" 'TandemInterpretation (list (token "*^" 'SpineSplit 5 0)) 5)
                           (record "*\t*^"
                                   'TandemInterpretation
                                   (list (token "*" 'NullInterpretation 6 0)
                                         (token "*^" 'SpineSplit 6 1))
                                   6)
                           (record "4c\t4c\t4c"
                                   'Token
                                   (list (token "4c" 'SpineData 7 0)
                                         (token "4c" 'SpineData 7 1)
                                         (token "4c" 'SpineData 7 2))
                                   7)
                           (record "4c\t4c\t4c"
                                   'Token
                                   (list (token "4c" 'SpineData 8 0)
                                         (token "4c" 'SpineData 8 1)
                                         (token "4c" 'SpineData 8 2))
                                   8)
                           (record "4c\t4c\t4c"
                                   'Token
                                   (list (token "4c" 'SpineData 9 0)
                                         (token "4c" 'SpineData 9 1)
                                         (token "4c" 'SpineData 9 2))
                                   9)
                           (record "=2\t=2\t=2"
                                   'Measure
                                   (list (token "=2" 'Measure 10 0)
                                         (token "=2" 'Measure 10 1)
                                         (token "=2" 'Measure 10 2))
                                   10)
                           (record "4c\t4c\t4c"
                                   'Token
                                   (list (token "4c" 'SpineData 11 0)
                                         (token "4c" 'SpineData 11 1)
                                         (token "4c" 'SpineData 11 2))
                                   11)
                           (record "4c\t4c\t4c"
                                   'Token
                                   (list (token "4c" 'SpineData 12 0)
                                         (token "4c" 'SpineData 12 1)
                                         (token "4c" 'SpineData 12 2))
                                   12)
                           (record "4c\t4c\t4c"
                                   'Token
                                   (list (token "4c" 'SpineData 13 0)
                                         (token "4c" 'SpineData 13 1)
                                         (token "4c" 'SpineData 13 2))
                                   13)
                           (record "=3\t=3\t=3"
                                   'Measure
                                   (list (token "=3" 'Measure 14 0)
                                         (token "=3" 'Measure 14 1)
                                         (token "=3" 'Measure 14 2))
                                   14)
                           (record "4c\t4c\t4c"
                                   'Token
                                   (list (token "4c" 'SpineData 15 0)
                                         (token "4c" 'SpineData 15 1)
                                         (token "4c" 'SpineData 15 2))
                                   15)
                           (record "4c\t4c\t4c"
                                   'Token
                                   (list (token "4c" 'SpineData 16 0)
                                         (token "4c" 'SpineData 16 1)
                                         (token "4c" 'SpineData 16 2))
                                   16)
                           (record "4c\t4c\t4c"
                                   'Token
                                   (list (token "4c" 'SpineData 17 0)
                                         (token "4c" 'SpineData 17 1)
                                         (token "4c" 'SpineData 17 2))
                                   17)
                           (record "*\t*v\t*v"
                                   'TandemInterpretation
                                   (list (token "*" 'NullInterpretation 18 0)
                                         (token "*v" 'SpineJoin 18 1)
                                         (token "*v" 'SpineJoin 18 2))
                                   18)
                           (record "*v\t*v"
                                   'TandemInterpretation
                                   (list (token "*v" 'SpineJoin 19 0)
                                         (token "*v" 'SpineJoin 19 1))
                                   19)
                           (record "==" 'Measure (list (token "==" 'Measure 20 0)) 20)
                           (record "*-" 'TandemInterpretation (list (token "*-" 'SpineTerminator 21 0)) 21))))
(check-expect (tokens->records
               (list (list (token "**kern" 'ExclusiveInterpretation 0 0))
                     (list (token "*clefG2" 'Clef 1 0))
                     (list (token "*k[]" 'KeySignature 2 0))
                     (list (token "*a:" 'KeyLabel 3 0))
                     (list (token "*M3/4" 'TimeSignature 4 0))
                     (list (token "*^" 'SpineSplit 5 0))
                     (list (token "*" 'NullInterpretation 6 0)
                           (token "*^" 'SpineSplit 6 1))
                     (list (token "4c" 'SpineData 7 0)
                           (token "4c" 'SpineData 7 1)
                           (token "4c" 'SpineData 7 2))
                     (list (token "4c" 'SpineData 8 0)
                           (token "4c" 'SpineData 8 1)
                           (token "4c" 'SpineData 8 2))
                     (list (token "4c" 'SpineData 9 0)
                           (token "4c" 'SpineData 9 1)
                           (token "4c" 'SpineData 9 2))
                     (list (token "=2" 'Measure 10 0)
                           (token "=2" 'Measure 10 1)
                           (token "=2" 'Measure 10 2))
                     (list (token "4c" 'SpineData 11 0)
                           (token "4c" 'SpineData 11 1)
                           (token "4c" 'SpineData 11 2))
                     (list (token "4c" 'SpineData 12 0)
                           (token "4c" 'SpineData 12 1)
                           (token "4c" 'SpineData 12 2))
                     (list (token "4c" 'SpineData 13 0)
                           (token "4c" 'SpineData 13 1)
                           (token "4c" 'SpineData 13 2))
                     (list (token "=3" 'Measure 14 0)
                           (token "=3" 'Measure 14 1)
                           (token "=3" 'Measure 14 2))
                     (list (token "4c" 'SpineData 15 0)
                           (token "4c" 'SpineData 15 1)
                           (token "4c" 'SpineData 15 2))
                     (list (token "4c" 'SpineData 16 0)
                           (token "4c" 'SpineData 16 1)
                           (token "4c" 'SpineData 16 2))
                     (list (token "4c" 'SpineData 17 0)
                           (token "4c" 'SpineData 17 1)
                           (token "4c" 'SpineData 17 2))
                     (list (token "*" 'NullInterpretation 18 0)
                           (token "*v" 'SpineJoin 18 1)
                           (token "*v" 'SpineJoin 18 2))
                     (list (token "*v" 'SpineJoin 19 0)
                           (token "*v" 'SpineJoin 19 1))
                     (list (token "==" 'Measure 20 0))
                     (list (token "*-" 'SpineTerminator 21 0))))
              (list (record "**kern"
                            'ExclusiveInterpretation
                            (list (token "**kern" 'ExclusiveInterpretation 0 0))
                            0)
                    (record "*clefG2" 'TandemInterpretation (list (token "*clefG2" 'Clef 1 0)) 1)
                    (record "*k[]" 'TandemInterpretation (list (token "*k[]" 'KeySignature 2 0)) 2)
                    (record "*a:" 'TandemInterpretation (list (token "*a:" 'KeyLabel 3 0)) 3)
                    (record "*M3/4" 'TandemInterpretation (list (token "*M3/4" 'TimeSignature 4 0)) 4)
                    (record "*^" 'TandemInterpretation (list (token "*^" 'SpineSplit 5 0)) 5)
                    (record "*\t*^"
                            'TandemInterpretation
                            (list (token "*" 'NullInterpretation 6 0)
                                  (token "*^" 'SpineSplit 6 1))
                            6)
                    (record "4c\t4c\t4c"
                            'Token
                            (list (token "4c" 'SpineData 7 0)
                                  (token "4c" 'SpineData 7 1)
                                  (token "4c" 'SpineData 7 2))
                            7)
                    (record "4c\t4c\t4c"
                            'Token
                            (list (token "4c" 'SpineData 8 0)
                                  (token "4c" 'SpineData 8 1)
                                  (token "4c" 'SpineData 8 2))
                            8)
                    (record "4c\t4c\t4c"
                            'Token
                            (list (token "4c" 'SpineData 9 0)
                                  (token "4c" 'SpineData 9 1)
                                  (token "4c" 'SpineData 9 2))
                            9)
                    (record "=2\t=2\t=2"
                            'Measure
                            (list (token "=2" 'Measure 10 0)
                                  (token "=2" 'Measure 10 1)
                                  (token "=2" 'Measure 10 2))
                            10)
                    (record "4c\t4c\t4c"
                            'Token
                            (list (token "4c" 'SpineData 11 0)
                                  (token "4c" 'SpineData 11 1)
                                  (token "4c" 'SpineData 11 2))
                            11)
                    (record "4c\t4c\t4c"
                            'Token
                            (list (token "4c" 'SpineData 12 0)
                                  (token "4c" 'SpineData 12 1)
                                  (token "4c" 'SpineData 12 2))
                            12)
                    (record "4c\t4c\t4c"
                            'Token
                            (list (token "4c" 'SpineData 13 0)
                                  (token "4c" 'SpineData 13 1)
                                  (token "4c" 'SpineData 13 2))
                            13)
                    (record "=3\t=3\t=3"
                            'Measure
                            (list (token "=3" 'Measure 14 0)
                                  (token "=3" 'Measure 14 1)
                                  (token "=3" 'Measure 14 2))
                            14)
                    (record "4c\t4c\t4c"
                            'Token
                            (list (token "4c" 'SpineData 15 0)
                                  (token "4c" 'SpineData 15 1)
                                  (token "4c" 'SpineData 15 2))
                            15)
                    (record "4c\t4c\t4c"
                            'Token
                            (list (token "4c" 'SpineData 16 0)
                                  (token "4c" 'SpineData 16 1)
                                  (token "4c" 'SpineData 16 2))
                            16)
                    (record "4c\t4c\t4c"
                            'Token
                            (list (token "4c" 'SpineData 17 0)
                                  (token "4c" 'SpineData 17 1)
                                  (token "4c" 'SpineData 17 2))
                            17)
                    (record "*\t*v\t*v"
                            'TandemInterpretation
                            (list (token "*" 'NullInterpretation 18 0)
                                  (token "*v" 'SpineJoin 18 1)
                                  (token "*v" 'SpineJoin 18 2))
                            18)
                    (record "*v\t*v"
                            'TandemInterpretation
                            (list (token "*v" 'SpineJoin 19 0)
                                  (token "*v" 'SpineJoin 19 1))
                            19)
                    (record "==" 'Measure (list (token "==" 'Measure 20 0)) 20)
                    (record "*-" 'TandemInterpretation (list (token "*-" 'SpineTerminator 21 0)) 21)))
(check-expect (hgraph->tokens
               (hgraph (root (list (list (leaf (token "**kern" 'ExclusiveInterpretation 0 0))
                                         (leaf (token "*clefG2" 'Clef 1 0))
                                         (leaf (token "*k[]" 'KeySignature 2 0))
                                         (leaf (token "*a:" 'KeyLabel 3 0))
                                         (leaf (token "*M3/4" 'TimeSignature 4 0))
                                         (parent (token "*^" 'SpineSplit 5 0)
                                                 (list (leaf (token "*" 'NullInterpretation 6 0))
                                                       (leaf (token "4c" 'SpineData 7 0))
                                                       (leaf (token "4c" 'SpineData 8 0))
                                                       (leaf (token "4c" 'SpineData 9 0))
                                                       (leaf (token "=2" 'Measure 10 0))
                                                       (leaf (token "4c" 'SpineData 11 0))
                                                       (leaf (token "4c" 'SpineData 12 0))
                                                       (leaf (token "4c" 'SpineData 13 0))
                                                       (leaf (token "=3" 'Measure 14 0))
                                                       (leaf (token "4c" 'SpineData 15 0))
                                                       (leaf (token "4c" 'SpineData 16 0))
                                                       (leaf (token "4c" 'SpineData 17 0))
                                                       (leaf (token "*" 'NullInterpretation 18 0))
                                                       (leaf (token "*v" 'SpineJoin 19 0)))
                                                 (list (parent (token "*^" 'SpineSplit 6 1)
                                                               (list (leaf (token "4c" 'SpineData 7 1))
                                                                     (leaf (token "4c" 'SpineData 8 1))
                                                                     (leaf (token "4c" 'SpineData 9 1))
                                                                     (leaf (token "=2" 'Measure 10 1))
                                                                     (leaf (token "4c" 'SpineData 11 1))
                                                                     (leaf (token "4c" 'SpineData 12 1))
                                                                     (leaf (token "4c" 'SpineData 13 1))
                                                                     (leaf (token "=3" 'Measure 14 1))
                                                                     (leaf (token "4c" 'SpineData 15 1))
                                                                     (leaf (token "4c" 'SpineData 16 1))
                                                                     (leaf (token "4c" 'SpineData 17 1))
                                                                     (leaf (token "*v" 'SpineJoin 18 1)))
                                                               (list (leaf (token "4c" 'SpineData 7 2))
                                                                     (leaf (token "4c" 'SpineData 8 2))
                                                                     (leaf (token "4c" 'SpineData 9 2))
                                                                     (leaf (token "=2" 'Measure 10 2))
                                                                     (leaf (token "4c" 'SpineData 11 2))
                                                                     (leaf (token "4c" 'SpineData 12 2))
                                                                     (leaf (token "4c" 'SpineData 13 2))
                                                                     (leaf (token "=3" 'Measure 14 2))
                                                                     (leaf (token "4c" 'SpineData 15 2))
                                                                     (leaf (token "4c" 'SpineData 16 2))
                                                                     (leaf (token "4c" 'SpineData 17 2))
                                                                     (leaf (token "*v" 'SpineJoin 18 2))))
                                                       (leaf (token "*v" 'SpineJoin 19 1))))
                                         (leaf (token "==" 'Measure 20 0))
                                         (leaf (token "*-" 'SpineTerminator 21 0)))))))
              (list (list (token "**kern" 'ExclusiveInterpretation 0 0))
                    (list (token "*clefG2" 'Clef 1 0))
                    (list (token "*k[]" 'KeySignature 2 0))
                    (list (token "*a:" 'KeyLabel 3 0))
                    (list (token "*M3/4" 'TimeSignature 4 0))
                    (list (token "*^" 'SpineSplit 5 0))
                    (list (token "*" 'NullInterpretation 6 0)
                          (token "*^" 'SpineSplit 6 1))
                    (list (token "4c" 'SpineData 7 0)
                          (token "4c" 'SpineData 7 1)
                          (token "4c" 'SpineData 7 2))
                    (list (token "4c" 'SpineData 8 0)
                          (token "4c" 'SpineData 8 1)
                          (token "4c" 'SpineData 8 2))
                    (list (token "4c" 'SpineData 9 0)
                          (token "4c" 'SpineData 9 1)
                          (token "4c" 'SpineData 9 2))
                    (list (token "=2" 'Measure 10 0)
                          (token "=2" 'Measure 10 1)
                          (token "=2" 'Measure 10 2))
                    (list (token "4c" 'SpineData 11 0)
                          (token "4c" 'SpineData 11 1)
                          (token "4c" 'SpineData 11 2))
                    (list (token "4c" 'SpineData 12 0)
                          (token "4c" 'SpineData 12 1)
                          (token "4c" 'SpineData 12 2))
                    (list (token "4c" 'SpineData 13 0)
                          (token "4c" 'SpineData 13 1)
                          (token "4c" 'SpineData 13 2))
                    (list (token "=3" 'Measure 14 0)
                          (token "=3" 'Measure 14 1)
                          (token "=3" 'Measure 14 2))
                    (list (token "4c" 'SpineData 15 0)
                          (token "4c" 'SpineData 15 1)
                          (token "4c" 'SpineData 15 2))
                    (list (token "4c" 'SpineData 16 0)
                          (token "4c" 'SpineData 16 1)
                          (token "4c" 'SpineData 16 2))
                    (list (token "4c" 'SpineData 17 0)
                          (token "4c" 'SpineData 17 1)
                          (token "4c" 'SpineData 17 2))
                    (list (token "*" 'NullInterpretation 18 0)
                          (token "*v" 'SpineJoin 18 1)
                          (token "*v" 'SpineJoin 18 2))
                    (list (token "*v" 'SpineJoin 19 0)
                          (token "*v" 'SpineJoin 19 1))
                    (list (token "==" 'Measure 20 0))
                    (list (token "*-" 'SpineTerminator 21 0))))
(check-expect (hfile->hgraph (hfile (list (record "**kern"
                                                  'ExclusiveInterpretation
                                                  (list (token "**kern" 'ExclusiveInterpretation 0 0))
                                                  0)
                                          (record "*clefG2"
                                                  'TandemInterpretation
                                                  (list (token "*clefG2" 'Clef 1 0))
                                                  1)
                                          (record "*k[]"
                                                  'TandemInterpretation
                                                  (list (token "*k[]" 'KeySignature 2 0))
                                                  2)
                                          (record "*a:"
                                                  'TandemInterpretation
                                                  (list (token "*a:" 'KeyLabel 3 0))
                                                  3)
                                          (record "*M3/4"
                                                  'TandemInterpretation
                                                  (list (token "*M3/4" 'TimeSignature 4 0))
                                                  4)
                                          (record "*^"
                                                  'TandemInterpretation
                                                  (list (token "*^" 'SpineSplit 5 0))
                                                  5)
                                          (record "*\t*^"
                                                  'TandemInterpretation
                                                  (list (token "*" 'NullInterpretation 6 0)
                                                        (token "*^" 'SpineSplit 6 1))
                                                  6)
                                          (record "4c\t4c\t4c"
                                                  'Token
                                                  (list (token "4c" 'SpineData 7 0)
                                                        (token "4c" 'SpineData 7 1)
                                                        (token "4c" 'SpineData 7 2))
                                                  7)
                                          (record "4c\t4c\t4c"
                                                  'Token
                                                  (list (token "4c" 'SpineData 8 0)
                                                        (token "4c" 'SpineData 8 1)
                                                        (token "4c" 'SpineData 8 2))
                                                  8)
                                          (record "4c\t4c\t4c"
                                                  'Token
                                                  (list (token "4c" 'SpineData 9 0)
                                                        (token "4c" 'SpineData 9 1)
                                                        (token "4c" 'SpineData 9 2))
                                                  9)
                                          (record "=2\t=2\t=2"
                                                  'Measure
                                                  (list (token "=2" 'Measure 10 0)
                                                        (token "=2" 'Measure 10 1)
                                                        (token "=2" 'Measure 10 2))
                                                  10)
                                          (record "4c\t4c\t4c"
                                                  'Token
                                                  (list (token "4c" 'SpineData 11 0)
                                                        (token "4c" 'SpineData 11 1)
                                                        (token "4c" 'SpineData 11 2))
                                                  11)
                                          (record "4c\t4c\t4c"
                                                  'Token
                                                  (list (token "4c" 'SpineData 12 0)
                                                        (token "4c" 'SpineData 12 1)
                                                        (token "4c" 'SpineData 12 2))
                                                  12)
                                          (record "4c\t4c\t4c"
                                                  'Token
                                                  (list (token "4c" 'SpineData 13 0)
                                                        (token "4c" 'SpineData 13 1)
                                                        (token "4c" 'SpineData 13 2))
                                                  13)
                                          (record "=3\t=3\t=3"
                                                  'Measure
                                                  (list (token "=3" 'Measure 14 0)
                                                        (token "=3" 'Measure 14 1)
                                                        (token "=3" 'Measure 14 2))
                                                  14)
                                          (record "4c\t4c\t4c"
                                                  'Token
                                                  (list (token "4c" 'SpineData 15 0)
                                                        (token "4c" 'SpineData 15 1)
                                                        (token "4c" 'SpineData 15 2))
                                                  15)
                                          (record "4c\t4c\t4c"
                                                  'Token
                                                  (list (token "4c" 'SpineData 16 0)
                                                        (token "4c" 'SpineData 16 1)
                                                        (token "4c" 'SpineData 16 2))
                                                  16)
                                          (record "4c\t4c\t4c"
                                                  'Token
                                                  (list (token "4c" 'SpineData 17 0)
                                                        (token "4c" 'SpineData 17 1)
                                                        (token "4c" 'SpineData 17 2))
                                                  17)
                                          (record "*\t*v\t*v"
                                                  'TandemInterpretation
                                                  (list (token "*" 'NullInterpretation 18 0)
                                                        (token "*v" 'SpineJoin 18 1)
                                                        (token "*v" 'SpineJoin 18 2))
                                                  18)
                                          (record "*v\t*v"
                                                  'TandemInterpretation
                                                  (list (token "*v" 'SpineJoin 19 0)
                                                        (token "*v" 'SpineJoin 19 1))
                                                  19)
                                          (record "==" 'Measure (list (token "==" 'Measure 20 0)) 20)
                                          (record "*-"
                                                  'TandemInterpretation
                                                  (list (token "*-" 'SpineTerminator 21 0))
                                                  21))))
              (hgraph (root (list (list (leaf (token "**kern" 'ExclusiveInterpretation 0 0))
                                        (leaf (token "*clefG2" 'Clef 1 0))
                                        (leaf (token "*k[]" 'KeySignature 2 0))
                                        (leaf (token "*a:" 'KeyLabel 3 0))
                                        (leaf (token "*M3/4" 'TimeSignature 4 0))
                                        (parent (token "*^" 'SpineSplit 5 0)
                                                (list (leaf (token "*" 'NullInterpretation 6 0))
                                                      (leaf (token "4c" 'SpineData 7 0))
                                                      (leaf (token "4c" 'SpineData 8 0))
                                                      (leaf (token "4c" 'SpineData 9 0))
                                                      (leaf (token "=2" 'Measure 10 0))
                                                      (leaf (token "4c" 'SpineData 11 0))
                                                      (leaf (token "4c" 'SpineData 12 0))
                                                      (leaf (token "4c" 'SpineData 13 0))
                                                      (leaf (token "=3" 'Measure 14 0))
                                                      (leaf (token "4c" 'SpineData 15 0))
                                                      (leaf (token "4c" 'SpineData 16 0))
                                                      (leaf (token "4c" 'SpineData 17 0))
                                                      (leaf (token "*" 'NullInterpretation 18 0))
                                                      (leaf (token "*v" 'SpineJoin 19 0)))
                                                (list (parent (token "*^" 'SpineSplit 6 1)
                                                              (list (leaf (token "4c" 'SpineData 7 1))
                                                                    (leaf (token "4c" 'SpineData 8 1))
                                                                    (leaf (token "4c" 'SpineData 9 1))
                                                                    (leaf (token "=2" 'Measure 10 1))
                                                                    (leaf (token "4c" 'SpineData 11 1))
                                                                    (leaf (token "4c" 'SpineData 12 1))
                                                                    (leaf (token "4c" 'SpineData 13 1))
                                                                    (leaf (token "=3" 'Measure 14 1))
                                                                    (leaf (token "4c" 'SpineData 15 1))
                                                                    (leaf (token "4c" 'SpineData 16 1))
                                                                    (leaf (token "4c" 'SpineData 17 1))
                                                                    (leaf (token "*v" 'SpineJoin 18 1)))
                                                              (list (leaf (token "4c" 'SpineData 7 2))
                                                                    (leaf (token "4c" 'SpineData 8 2))
                                                                    (leaf (token "4c" 'SpineData 9 2))
                                                                    (leaf (token "=2" 'Measure 10 2))
                                                                    (leaf (token "4c" 'SpineData 11 2))
                                                                    (leaf (token "4c" 'SpineData 12 2))
                                                                    (leaf (token "4c" 'SpineData 13 2))
                                                                    (leaf (token "=3" 'Measure 14 2))
                                                                    (leaf (token "4c" 'SpineData 15 2))
                                                                    (leaf (token "4c" 'SpineData 16 2))
                                                                    (leaf (token "4c" 'SpineData 17 2))
                                                                    (leaf (token "*v" 'SpineJoin 18 2))))
                                                      (leaf (token "*v" 'SpineJoin 19 1))))
                                        (leaf (token "==" 'Measure 20 0))
                                        (leaf (token "*-" 'SpineTerminator 21 0)))))))
(check-expect (gspines->linked-spines (spine-parser (path->hfile "../../data/count/one-spine-two-splits.krn"))
                                      (path->hfile "../../data/count/one-spine-two-splits.krn"))
              (list (linked-spine KERN-0-0)))

(test)
