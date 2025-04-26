#lang racket/base

(require "../../../../parser/data-definitions/data-definitions.rkt"
         "../../../../parser/functions/file.rkt"
         "../../../../parser/functions/spine-parser.rkt"
         "../../../../parser/data-structures/humdrum-graph/data-definitions/data-definitions.rkt"
         "../../../../parser/data-structures/humdrum-graph/functions/hgraph-to-hfile.rkt"
         "../../../../parser/data-structures/humdrum-graph/functions/hfile-to-hgraph.rkt"
         "../../../../parser/data-structures/linked-spine/data-definitions/data-definitions.rkt"
         "../../../../parser/data-structures/linked-spine/functions/gspines-to-linked-spines.rkt"
         test-engine/racket-tests)

;; Node definitions
(define TERM-19-0 (terminator-node (token "*-" 'SpineTerminator 19 0)))
(define M-18-0 (token-node (token "==" 'Measure 18 0) (box-immutable TERM-19-0)))
(define J-17-0 (token-node (token "*v" 'SpineJoin 17 0) (box-immutable M-18-0)))
(define J-17-1 (token-node (token "*v" 'SpineJoin 17 1) (box-immutable M-18-0)))
(define 4c-16-0 (token-node (token "4c" 'SpineData 16 0) (box-immutable J-17-0)))
(define 4c-16-1 (token-node (token "4c" 'SpineData 16 1) (box-immutable J-17-1)))
(define 4c-15-0 (token-node (token "4c" 'SpineData 15 0) (box-immutable 4c-16-0)))
(define 4c-15-1 (token-node (token "4c" 'SpineData 15 1) (box-immutable 4c-16-1)))
(define 4c-14-0 (token-node (token "4c" 'SpineData 14 0) (box-immutable 4c-15-0)))
(define 4c-14-1 (token-node (token "4c" 'SpineData 14 1) (box-immutable 4c-15-1)))
(define M-13-0 (token-node (token "=3" 'Measure 13 0) (box-immutable 4c-14-0)))
(define M-13-1 (token-node (token "=3" 'Measure 13 1) (box-immutable 4c-14-1)))
(define 4c-12-0 (token-node (token "4c" 'SpineData 12 0) (box-immutable M-13-0)))
(define 4c-12-1 (token-node (token "4c" 'SpineData 12 1) (box-immutable M-13-1)))
(define 4c-11-0 (token-node (token "4c" 'SpineData 11 0) (box-immutable 4c-12-0)))
(define 4c-11-1 (token-node (token "4c" 'SpineData 11 1) (box-immutable 4c-12-1)))
(define 4c-10-0 (token-node (token "4c" 'SpineData 10 0) (box-immutable 4c-11-0)))
(define 4c-10-1 (token-node (token "4c" 'SpineData 10 1) (box-immutable 4c-11-1)))
(define M-9-0 (token-node (token "=2" 'Measure 9 0) (box-immutable 4c-10-0)))
(define M-9-1 (token-node (token "=2" 'Measure 9 1) (box-immutable 4c-10-1)))
(define 4c-8-0 (token-node (token "4c" 'SpineData 8 0) (box-immutable M-9-0)))
(define 4c-8-1 (token-node (token "4c" 'SpineData 8 1) (box-immutable M-9-1)))
(define 4c-7-0 (token-node (token "4c" 'SpineData 7 0) (box-immutable 4c-8-0)))
(define 4c-7-1 (token-node (token "4c" 'SpineData 7 1) (box-immutable 4c-8-1)))
(define 4c-6-0 (token-node (token "4c" 'SpineData 6 0) (box-immutable 4c-7-0)))
(define 4c-6-1 (token-node (token "4c" 'SpineData 6 1) (box-immutable 4c-7-1)))
(define S-5-0 (split-node (token "*^" 'SpineSplit 5 0)
                          (box-immutable 4c-6-0)
                          (box-immutable 4c-6-1)))
(define TS-4-0 (token-node (token "*M3/4" 'TimeSignature 4 0) (box-immutable S-5-0)))
(define KL-3-0 (token-node (token "*a:" 'KeyLabel 3 0) (box-immutable TS-4-0)))
(define KS-2-0 (token-node (token "*k[]" 'KeySignature 2 0) (box-immutable KL-3-0)))
(define CL-1-0 (token-node (token "*clefG2" 'Clef 1 0) (box-immutable KS-2-0)))
(define KERN-0-0 (token-node (token "**kern" 'ExclusiveInterpretation 0 0) (box-immutable CL-1-0)))

(check-expect (path->hfile "../../data/count/one-spine-one-split.krn")
              (hfile (list (record "**kern"
                                   'Token
                                   (list (token "**kern" 'ExclusiveInterpretation 0 0))
                                   0)
                           (record "*clefG2"
                                   'Token
                                   (list (token "*clefG2" 'Clef 1 0))
                                   1)
                           (record "*k[]"
                                   'Token
                                   (list (token "*k[]" 'KeySignature 2 0))
                                   2)
                           (record "*a:"
                                   'Token
                                   (list (token "*a:" 'KeyLabel 3 0))
                                   3)
                           (record "*M3/4"
                                   'Token
                                   (list (token "*M3/4" 'TimeSignature 4 0))
                                   4)
                           (record "*^"
                                   'Token
                                   (list (token "*^" 'SpineSplit 5 0))
                                   5)
                           (record "4c\t4c"
                                   'Token
                                   (list (token "4c" 'SpineData 6 0)
                                         (token "4c" 'SpineData 6 1))
                                   6)
                           (record "4c\t4c"
                                   'Token
                                   (list (token "4c" 'SpineData 7 0)
                                         (token "4c" 'SpineData 7 1))
                                   7)
                           (record "4c\t4c"
                                   'Token
                                   (list (token "4c" 'SpineData 8 0)
                                         (token "4c" 'SpineData 8 1))
                                   8)
                           (record "=2\t=2"
                                   'Token
                                   (list (token "=2" 'Measure 9 0)
                                         (token "=2" 'Measure 9 1))
                                   9)
                           (record "4c\t4c"
                                   'Token
                                   (list (token "4c" 'SpineData 10 0)
                                         (token "4c" 'SpineData 10 1))
                                   10)
                           (record "4c\t4c"
                                   'Token
                                   (list (token "4c" 'SpineData 11 0)
                                         (token "4c" 'SpineData 11 1))
                                   11)
                           (record "4c\t4c"
                                   'Token
                                   (list (token "4c" 'SpineData 12 0)
                                         (token "4c" 'SpineData 12 1))
                                   12)
                           (record "=3\t=3"
                                   'Token
                                   (list (token "=3" 'Measure 13 0)
                                         (token "=3" 'Measure 13 1))
                                   13)
                           (record "4c\t4c"
                                   'Token
                                   (list (token "4c" 'SpineData 14 0)
                                         (token "4c" 'SpineData 14 1))
                                   14)
                           (record "4c\t4c"
                                   'Token
                                   (list (token "4c" 'SpineData 15 0)
                                         (token "4c" 'SpineData 15 1))
                                   15)
                           (record "4c\t4c"
                                   'Token
                                   (list (token "4c" 'SpineData 16 0)
                                         (token "4c" 'SpineData 16 1))
                                   16)
                           (record "*v\t*v"
                                   'Token
                                   (list (token "*v" 'SpineJoin 17 0)
                                         (token "*v" 'SpineJoin 17 1))
                                   17)
                           (record "=="
                                   'Token
                                   (list (token "==" 'Measure 18 0))
                                   18)
                           (record "*-"
                                   'Token
                                   (list (token "*-" 'SpineTerminator 19 0))
                                   19))))
(check-expect (spine-parser (hfile (list (record "**kern"
                                                 'Token
                                                 (list (token "**kern" 'ExclusiveInterpretation 0 0))
                                                 0)
                                         (record "*clefG2"
                                                 'Token
                                                 (list (token "*clefG2" 'Clef 1 0))
                                                 1)
                                         (record "*k[]"
                                                 'Token
                                                 (list (token "*k[]" 'KeySignature 2 0))
                                                 2)
                                         (record "*a:"
                                                 'Token
                                                 (list (token "*a:" 'KeyLabel 3 0))
                                                 3)
                                         (record "*M3/4"
                                                 'Token
                                                 (list (token "*M3/4" 'TimeSignature 4 0))
                                                 4)
                                         (record "*^"
                                                 'Token
                                                 (list (token "*^" 'SpineSplit 5 0))
                                                 5)
                                         (record "4c\t4c"
                                                 'Token
                                                 (list (token "4c" 'SpineData 6 0)
                                                       (token "4c" 'SpineData 6 1))
                                                 6)
                                         (record "4c\t4c"
                                                 'Token
                                                 (list (token "4c" 'SpineData 7 0)
                                                       (token "4c" 'SpineData 7 1))
                                                 7)
                                         (record "4c\t4c"
                                                 'Token
                                                 (list (token "4c" 'SpineData 8 0)
                                                       (token "4c" 'SpineData 8 1))
                                                 8)
                                         (record "=2\t=2"
                                                 'Token
                                                 (list (token "=2" 'Measure 9 0)
                                                       (token "=2" 'Measure 9 1))
                                                 9)
                                         (record "4c\t4c"
                                                 'Token
                                                 (list (token "4c" 'SpineData 10 0)
                                                       (token "4c" 'SpineData 10 1))
                                                 10)
                                         (record "4c\t4c"
                                                 'Token
                                                 (list (token "4c" 'SpineData 11 0)
                                                       (token "4c" 'SpineData 11 1))
                                                 11)
                                         (record "4c\t4c"
                                                 'Token
                                                 (list (token "4c" 'SpineData 12 0)
                                                       (token "4c" 'SpineData 12 1))
                                                 12)
                                         (record "=3\t=3"
                                                 'Token
                                                 (list (token "=3" 'Measure 13 0)
                                                       (token "=3" 'Measure 13 1))
                                                 13)
                                         (record "4c\t4c"
                                                 'Token
                                                 (list (token "4c" 'SpineData 14 0)
                                                       (token "4c" 'SpineData 14 1))
                                                 14)
                                         (record "4c\t4c"
                                                 'Token
                                                 (list (token "4c" 'SpineData 15 0)
                                                       (token "4c" 'SpineData 15 1))
                                                 15)
                                         (record "4c\t4c"
                                                 'Token
                                                 (list (token "4c" 'SpineData 16 0)
                                                       (token "4c" 'SpineData 16 1))
                                                 16)
                                         (record "*v\t*v"
                                                 'Token
                                                 (list (token "*v" 'SpineJoin 17 0)
                                                       (token "*v" 'SpineJoin 17 1))
                                                 17)
                                         (record "=="
                                                 'Token
                                                 (list (token "==" 'Measure 18 0))
                                                 18)
                                         (record "*-"
                                                 'Token
                                                 (list (token "*-" 'SpineTerminator 19 0))
                                                 19))))
              (list (global-spine KERN
                                  (list (list (token "**kern" 'ExclusiveInterpretation 0 0))
                                        (list (token "*clefG2" 'Clef 1 0))
                                        (list (token "*k[]" 'KeySignature 2 0))
                                        (list (token "*a:" 'KeyLabel 3 0))
                                        (list (token "*M3/4" 'TimeSignature 4 0))
                                        (list (token "*^" 'SpineSplit 5 0))
                                        (list (token "4c" 'SpineData 6 0)
                                              (token "4c" 'SpineData 6 1))
                                        (list (token "4c" 'SpineData 7 0)
                                              (token "4c" 'SpineData 7 1))
                                        (list (token "4c" 'SpineData 8 0)
                                              (token "4c" 'SpineData 8 1))
                                        (list (token "=2" 'Measure 9 0)
                                              (token "=2" 'Measure 9 1))
                                        (list (token "4c" 'SpineData 10 0)
                                              (token "4c" 'SpineData 10 1))
                                        (list (token "4c" 'SpineData 11 0)
                                              (token "4c" 'SpineData 11 1))
                                        (list (token "4c" 'SpineData 12 0)
                                              (token "4c" 'SpineData 12 1))
                                        (list (token "=3" 'Measure 13 0)
                                              (token "=3" 'Measure 13 1))
                                        (list (token "4c" 'SpineData 14 0)
                                              (token "4c" 'SpineData 14 1))
                                        (list (token "4c" 'SpineData 15 0)
                                              (token "4c" 'SpineData 15 1))
                                        (list (token "4c" 'SpineData 16 0)
                                              (token "4c" 'SpineData 16 1))
                                        (list (token "*v" 'SpineJoin 17 0)
                                              (token "*v" 'SpineJoin 17 1))
                                        (list (token "==" 'Measure 18 0))
                                        (list (token "*-" 'SpineTerminator 19 0)))
                                  0)))
(check-expect (hgraph->hfile (hgraph (root (list (list (leaf (token "**kern" 'ExclusiveInterpretation 0 0))
                                                       (leaf (token "*clefG2" 'Clef 1 0))
                                                       (leaf (token "*k[]" 'KeySignature 2 0))
                                                       (leaf (token "*a:" 'KeyLabel 3 0))
                                                       (leaf (token "*M3/4" 'TimeSignature 4 0))
                                                       (parent (token "*^" 'SpineSplit 5 0)
                                                               (list (leaf (token "4c" 'SpineData 6 0))
                                                                     (leaf (token "4c" 'SpineData 7 0))
                                                                     (leaf (token "4c" 'SpineData 8 0))
                                                                     (leaf (token "=2" 'Measure 9 0))
                                                                     (leaf (token "4c" 'SpineData 10 0))
                                                                     (leaf (token "4c" 'SpineData 11 0))
                                                                     (leaf (token "4c" 'SpineData 12 0))
                                                                     (leaf (token "=3" 'Measure 13 0))
                                                                     (leaf (token "4c" 'SpineData 14 0))
                                                                     (leaf (token "4c" 'SpineData 15 0))
                                                                     (leaf (token "4c" 'SpineData 16 0))
                                                                     (leaf (token "*v" 'SpineJoin 17 0)))
                                                               (list (leaf (token "4c" 'SpineData 6 1))
                                                                     (leaf (token "4c" 'SpineData 7 1))
                                                                     (leaf (token "4c" 'SpineData 8 1))
                                                                     (leaf (token "=2" 'Measure 9 1))
                                                                     (leaf (token "4c" 'SpineData 10 1))
                                                                     (leaf (token "4c" 'SpineData 11 1))
                                                                     (leaf (token "4c" 'SpineData 12 1))
                                                                     (leaf (token "=3" 'Measure 13 1))
                                                                     (leaf (token "4c" 'SpineData 14 1))
                                                                     (leaf (token "4c" 'SpineData 15 1))
                                                                     (leaf (token "4c" 'SpineData 16 1))
                                                                     (leaf (token "*v" 'SpineJoin 17 1))))
                                                       (leaf (token "==" 'Measure 18 0))
                                                       (leaf (token "*-" 'SpineTerminator 19 0)))))))
              (path->hfile "../../data/count/one-spine-one-split.krn"))
(check-expect (tokens->records (list (list (token "**kern" 'ExclusiveInterpretation 0 0))
                                (list (token "*clefG2" 'Clef 1 0))
                                (list (token "*k[]" 'KeySignature 2 0))
                                (list (token "*a:" 'KeyLabel 3 0))
                                (list (token "*M3/4" 'TimeSignature 4 0))
                                (list (token "*^" 'SpineSplit 5 0))
                                (list (token "4c" 'SpineData 6 0)
                                      (token "4c" 'SpineData 6 1))
                                (list (token "4c" 'SpineData 7 0)
                                      (token "4c" 'SpineData 7 1))
                                (list (token "4c" 'SpineData 8 0)
                                      (token "4c" 'SpineData 8 1))
                                (list (token "=2" 'Measure 9 0)
                                      (token "=2" 'Measure 9 1))
                                (list (token "4c" 'SpineData 10 0)
                                      (token "4c" 'SpineData 10 1))
                                (list (token "4c" 'SpineData 11 0)
                                      (token "4c" 'SpineData 11 1))
                                (list (token "4c" 'SpineData 12 0)
                                      (token "4c" 'SpineData 12 1))
                                (list (token "=3" 'Measure 13 0)
                                      (token "=3" 'Measure 13 1))
                                (list (token "4c" 'SpineData 14 0)
                                      (token "4c" 'SpineData 14 1))
                                (list (token "4c" 'SpineData 15 0)
                                      (token "4c" 'SpineData 15 1))
                                (list (token "4c" 'SpineData 16 0)
                                      (token "4c" 'SpineData 16 1))
                                (list (token "*v" 'SpineJoin 17 0)
                                      (token "*v" 'SpineJoin 17 1))
                                (list (token "==" 'Measure 18 0))
                                (list (token "*-" 'SpineTerminator 19 0))))
              (list (record "**kern"
                            'Token
                            (list (token "**kern" 'ExclusiveInterpretation 0 0))
                            0)
                    (record "*clefG2"
                            'Token
                            (list (token "*clefG2" 'Clef 1 0))
                            1)
                    (record "*k[]"
                            'Token
                            (list (token "*k[]" 'KeySignature 2 0))
                            2)
                    (record "*a:"
                            'Token
                            (list (token "*a:" 'KeyLabel 3 0))
                            3)
                    (record "*M3/4"
                            'Token
                            (list (token "*M3/4" 'TimeSignature 4 0))
                            4)
                    (record "*^"
                            'Token
                            (list (token "*^" 'SpineSplit 5 0))
                            5)
                    (record "4c\t4c"
                            'Token
                            (list (token "4c" 'SpineData 6 0)
                                  (token "4c" 'SpineData 6 1))
                            6)
                    (record "4c\t4c"
                            'Token
                            (list (token "4c" 'SpineData 7 0)
                                  (token "4c" 'SpineData 7 1))
                            7)
                    (record "4c\t4c"
                            'Token
                            (list (token "4c" 'SpineData 8 0)
                                  (token "4c" 'SpineData 8 1))
                            8)
                    (record "=2\t=2"
                            'Token
                            (list (token "=2" 'Measure 9 0)
                                  (token "=2" 'Measure 9 1))
                            9)
                    (record "4c\t4c"
                            'Token
                            (list (token "4c" 'SpineData 10 0)
                                  (token "4c" 'SpineData 10 1))
                            10)
                    (record "4c\t4c"
                            'Token
                            (list (token "4c" 'SpineData 11 0)
                                  (token "4c" 'SpineData 11 1))
                            11)
                    (record "4c\t4c"
                            'Token
                            (list (token "4c" 'SpineData 12 0)
                                  (token "4c" 'SpineData 12 1))
                            12)
                    (record "=3\t=3"
                            'Token
                            (list (token "=3" 'Measure 13 0)
                                  (token "=3" 'Measure 13 1))
                            13)
                    (record "4c\t4c"
                            'Token
                            (list (token "4c" 'SpineData 14 0)
                                  (token "4c" 'SpineData 14 1))
                            14)
                    (record "4c\t4c"
                            'Token
                            (list (token "4c" 'SpineData 15 0)
                                  (token "4c" 'SpineData 15 1))
                            15)
                    (record "4c\t4c"
                            'Token
                            (list (token "4c" 'SpineData 16 0)
                                  (token "4c" 'SpineData 16 1))
                            16)
                    (record "*v\t*v"
                            'Token
                            (list (token "*v" 'SpineJoin 17 0)
                                  (token "*v" 'SpineJoin 17 1))
                            17)
                    (record "=="
                            'Token
                            (list (token "==" 'Measure 18 0))
                            18)
                    (record "*-"
                            'Token
                            (list (token "*-" 'SpineTerminator 19 0))
                            19)))
(check-expect (hgraph->tokens (hgraph (root (list (list (leaf (token "**kern" 'ExclusiveInterpretation 0 0))
                                                       (leaf (token "*clefG2" 'Clef 1 0))
                                                       (leaf (token "*k[]" 'KeySignature 2 0))
                                                       (leaf (token "*a:" 'KeyLabel 3 0))
                                                       (leaf (token "*M3/4" 'TimeSignature 4 0))
                                                       (parent (token "*^" 'SpineSplit 5 0)
                                                               (list (leaf (token "4c" 'SpineData 6 0))
                                                                     (leaf (token "4c" 'SpineData 7 0))
                                                                     (leaf (token "4c" 'SpineData 8 0))
                                                                     (leaf (token "=2" 'Measure 9 0))
                                                                     (leaf (token "4c" 'SpineData 10 0))
                                                                     (leaf (token "4c" 'SpineData 11 0))
                                                                     (leaf (token "4c" 'SpineData 12 0))
                                                                     (leaf (token "=3" 'Measure 13 0))
                                                                     (leaf (token "4c" 'SpineData 14 0))
                                                                     (leaf (token "4c" 'SpineData 15 0))
                                                                     (leaf (token "4c" 'SpineData 16 0))
                                                                     (leaf (token "*v" 'SpineJoin 17 0)))
                                                               (list (leaf (token "4c" 'SpineData 6 1))
                                                                     (leaf (token "4c" 'SpineData 7 1))
                                                                     (leaf (token "4c" 'SpineData 8 1))
                                                                     (leaf (token "=2" 'Measure 9 1))
                                                                     (leaf (token "4c" 'SpineData 10 1))
                                                                     (leaf (token "4c" 'SpineData 11 1))
                                                                     (leaf (token "4c" 'SpineData 12 1))
                                                                     (leaf (token "=3" 'Measure 13 1))
                                                                     (leaf (token "4c" 'SpineData 14 1))
                                                                     (leaf (token "4c" 'SpineData 15 1))
                                                                     (leaf (token "4c" 'SpineData 16 1))
                                                                     (leaf (token "*v" 'SpineJoin 17 1))))
                                                       (leaf (token "==" 'Measure 18 0))
                                                       (leaf (token "*-" 'SpineTerminator 19 0)))))))
              (list (list (token "**kern" 'ExclusiveInterpretation 0 0))
                    (list (token "*clefG2" 'Clef 1 0))
                    (list (token "*k[]" 'KeySignature 2 0))
                    (list (token "*a:" 'KeyLabel 3 0))
                    (list (token "*M3/4" 'TimeSignature 4 0))
                    (list (token "*^" 'SpineSplit 5 0))
                    (list (token "4c" 'SpineData 6 0)
                          (token "4c" 'SpineData 6 1))
                    (list (token "4c" 'SpineData 7 0)
                          (token "4c" 'SpineData 7 1))
                    (list (token "4c" 'SpineData 8 0)
                          (token "4c" 'SpineData 8 1))
                    (list (token "=2" 'Measure 9 0)
                          (token "=2" 'Measure 9 1))
                    (list (token "4c" 'SpineData 10 0)
                          (token "4c" 'SpineData 10 1))
                    (list (token "4c" 'SpineData 11 0)
                          (token "4c" 'SpineData 11 1))
                    (list (token "4c" 'SpineData 12 0)
                          (token "4c" 'SpineData 12 1))
                    (list (token "=3" 'Measure 13 0)
                          (token "=3" 'Measure 13 1))
                    (list (token "4c" 'SpineData 14 0)
                          (token "4c" 'SpineData 14 1))
                    (list (token "4c" 'SpineData 15 0)
                          (token "4c" 'SpineData 15 1))
                    (list (token "4c" 'SpineData 16 0)
                          (token "4c" 'SpineData 16 1))
                    (list (token "*v" 'SpineJoin 17 0)
                          (token "*v" 'SpineJoin 17 1))
                    (list (token "==" 'Measure 18 0))
                    (list (token "*-" 'SpineTerminator 19 0))))
#|
(check-expect (hfile->hgraph (path->hfile "../../data/count/one-spine-one-split.krn"))
              (hgraph (root (list (list (leaf (token "**kern" 'ExclusiveInterpretation 0 0))
                                        (leaf (token "*clefG2" 'Clef 1 0))
                                        (leaf (token "*k[]" 'KeySignature 2 0))
                                        (leaf (token "*a:" 'KeyLabel 3 0))
                                        (leaf (token "*M3/4" 'TimeSignature 4 0))
                                        (parent (token "*^" 'SpineSplit 5 0)
                                                (list (leaf (token "4c" 'SpineData 6 0))
                                                      (leaf (token "4c" 'SpineData 7 0))
                                                      (leaf (token "4c" 'SpineData 8 0))
                                                      (leaf (token "=2" 'Measure 9 0))
                                                      (leaf (token "4c" 'SpineData 10 0))
                                                      (leaf (token "4c" 'SpineData 11 0))
                                                      (leaf (token "4c" 'SpineData 12 0))
                                                      (leaf (token "=3" 'Measure 13 0))
                                                      (leaf (token "4c" 'SpineData 14 0))
                                                      (leaf (token "4c" 'SpineData 15 0))
                                                      (leaf (token "4c" 'SpineData 16 0))
                                                      (leaf (token "*v" 'SpineJoin 17 0)))
                                                (list (leaf (token "4c" 'SpineData 6 1))
                                                      (leaf (token "4c" 'SpineData 7 1))
                                                      (leaf (token "4c" 'SpineData 8 1))
                                                      (leaf (token "=2" 'Measure 9 1))
                                                      (leaf (token "4c" 'SpineData 10 1))
                                                      (leaf (token "4c" 'SpineData 11 1))
                                                      (leaf (token "4c" 'SpineData 12 1))
                                                      (leaf (token "=3" 'Measure 13 1))
                                                      (leaf (token "4c" 'SpineData 14 1))
                                                      (leaf (token "4c" 'SpineData 15 1))
                                                      (leaf (token "4c" 'SpineData 16 1))
                                                      (leaf (token "*v" 'SpineJoin 17 1))))
                                        (leaf (token "==" 'Measure 18 0))
                                        (leaf (token "*-" 'SpineTerminator 19 0)))))))
|#
(check-expect (gspines->linked-spines (spine-parser (path->hfile "../../data/count/one-spine-one-split.krn"))
                                      (path->hfile "../../data/count/one-spine-one-split.krn"))
              (list (linked-spine KERN-0-0)))

(test)
