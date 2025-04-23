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
(define TERM-19-0 (terminator-node (token "*-" SPINE-TERMINATOR 19 0)))
(define M-18-0 (token-node (token "==" MEASURE 18 0) (box-immutable TERM-19-0)))
(define J-17-0 (token-node (token "*v" SPINE-JOIN 17 0) (box-immutable M-18-0)))
(define J-17-1 (token-node (token "*v" SPINE-JOIN 17 1) (box-immutable M-18-0)))
(define 4c-16-0 (token-node (token "4c" SPINE-DATA 16 0) (box-immutable J-17-0)))
(define 4c-16-1 (token-node (token "4c" SPINE-DATA 16 1) (box-immutable J-17-1)))
(define 4c-15-0 (token-node (token "4c" SPINE-DATA 15 0) (box-immutable 4c-16-0)))
(define 4c-15-1 (token-node (token "4c" SPINE-DATA 15 1) (box-immutable 4c-16-1)))
(define 4c-14-0 (token-node (token "4c" SPINE-DATA 14 0) (box-immutable 4c-15-0)))
(define 4c-14-1 (token-node (token "4c" SPINE-DATA 14 1) (box-immutable 4c-15-1)))
(define M-13-0 (token-node (token "=3" MEASURE 13 0) (box-immutable 4c-14-0)))
(define M-13-1 (token-node (token "=3" MEASURE 13 1) (box-immutable 4c-14-1)))
(define 4c-12-0 (token-node (token "4c" SPINE-DATA 12 0) (box-immutable M-13-0)))
(define 4c-12-1 (token-node (token "4c" SPINE-DATA 12 1) (box-immutable M-13-1)))
(define 4c-11-0 (token-node (token "4c" SPINE-DATA 11 0) (box-immutable 4c-12-0)))
(define 4c-11-1 (token-node (token "4c" SPINE-DATA 11 1) (box-immutable 4c-12-1)))
(define 4c-10-0 (token-node (token "4c" SPINE-DATA 10 0) (box-immutable 4c-11-0)))
(define 4c-10-1 (token-node (token "4c" SPINE-DATA 10 1) (box-immutable 4c-11-1)))
(define M-9-0 (token-node (token "=2" MEASURE 9 0) (box-immutable 4c-10-0)))
(define M-9-1 (token-node (token "=2" MEASURE 9 1) (box-immutable 4c-10-1)))
(define 4c-8-0 (token-node (token "4c" SPINE-DATA 8 0) (box-immutable M-9-0)))
(define 4c-8-1 (token-node (token "4c" SPINE-DATA 8 1) (box-immutable M-9-1)))
(define 4c-7-0 (token-node (token "4c" SPINE-DATA 7 0) (box-immutable 4c-8-0)))
(define 4c-7-1 (token-node (token "4c" SPINE-DATA 7 1) (box-immutable 4c-8-1)))
(define 4c-6-0 (token-node (token "4c" SPINE-DATA 6 0) (box-immutable 4c-7-0)))
(define 4c-6-1 (token-node (token "4c" SPINE-DATA 6 1) (box-immutable 4c-7-1)))
(define S-5-0 (split-node (token "*^" SPINE-SPLIT 5 0)
                          (box-immutable 4c-6-0)
                          (box-immutable 4c-6-1)))
(define TS-4-0 (token-node (token "*M3/4" TIME-SIG 4 0) (box-immutable S-5-0)))
(define KL-3-0 (token-node (token "*a:" KEY-LABEL 3 0) (box-immutable TS-4-0)))
(define KS-2-0 (token-node (token "*k[]" KEY-SIG 2 0) (box-immutable KL-3-0)))
(define CL-1-0 (token-node (token "*clefG2" CLEF 1 0) (box-immutable KS-2-0)))
(define KERN-0-0 (token-node (token "**kern" EXCLUSIVE-INTERPRETATION 0 0) (box-immutable CL-1-0)))

(check-expect (path->hfile "../../data/count/one-spine-one-split.krn")
              (hfile (list (record "**kern"
                                   TOKEN
                                   (list (token "**kern" EXCLUSIVE-INTERPRETATION 0 0))
                                   0)
                           (record "*clefG2"
                                   TOKEN
                                   (list (token "*clefG2" CLEF 1 0))
                                   1)
                           (record "*k[]"
                                   TOKEN
                                   (list (token "*k[]" KEY-SIG 2 0))
                                   2)
                           (record "*a:"
                                   TOKEN
                                   (list (token "*a:" KEY-LABEL 3 0))
                                   3)
                           (record "*M3/4"
                                   TOKEN
                                   (list (token "*M3/4" TIME-SIG 4 0))
                                   4)
                           (record "*^"
                                   TOKEN
                                   (list (token "*^" SPINE-SPLIT 5 0))
                                   5)
                           (record "4c\t4c"
                                   TOKEN
                                   (list (token "4c" SPINE-DATA 6 0)
                                         (token "4c" SPINE-DATA 6 1))
                                   6)
                           (record "4c\t4c"
                                   TOKEN
                                   (list (token "4c" SPINE-DATA 7 0)
                                         (token "4c" SPINE-DATA 7 1))
                                   7)
                           (record "4c\t4c"
                                   TOKEN
                                   (list (token "4c" SPINE-DATA 8 0)
                                         (token "4c" SPINE-DATA 8 1))
                                   8)
                           (record "=2\t=2"
                                   TOKEN
                                   (list (token "=2" MEASURE 9 0)
                                         (token "=2" MEASURE 9 1))
                                   9)
                           (record "4c\t4c"
                                   TOKEN
                                   (list (token "4c" SPINE-DATA 10 0)
                                         (token "4c" SPINE-DATA 10 1))
                                   10)
                           (record "4c\t4c"
                                   TOKEN
                                   (list (token "4c" SPINE-DATA 11 0)
                                         (token "4c" SPINE-DATA 11 1))
                                   11)
                           (record "4c\t4c"
                                   TOKEN
                                   (list (token "4c" SPINE-DATA 12 0)
                                         (token "4c" SPINE-DATA 12 1))
                                   12)
                           (record "=3\t=3"
                                   TOKEN
                                   (list (token "=3" MEASURE 13 0)
                                         (token "=3" MEASURE 13 1))
                                   13)
                           (record "4c\t4c"
                                   TOKEN
                                   (list (token "4c" SPINE-DATA 14 0)
                                         (token "4c" SPINE-DATA 14 1))
                                   14)
                           (record "4c\t4c"
                                   TOKEN
                                   (list (token "4c" SPINE-DATA 15 0)
                                         (token "4c" SPINE-DATA 15 1))
                                   15)
                           (record "4c\t4c"
                                   TOKEN
                                   (list (token "4c" SPINE-DATA 16 0)
                                         (token "4c" SPINE-DATA 16 1))
                                   16)
                           (record "*v\t*v"
                                   TOKEN
                                   (list (token "*v" SPINE-JOIN 17 0)
                                         (token "*v" SPINE-JOIN 17 1))
                                   17)
                           (record "=="
                                   TOKEN
                                   (list (token "==" MEASURE 18 0))
                                   18)
                           (record "*-"
                                   TOKEN
                                   (list (token "*-" SPINE-TERMINATOR 19 0))
                                   19))))
(check-expect (spine-parser (hfile (list (record "**kern"
                                                 TOKEN
                                                 (list (token "**kern" EXCLUSIVE-INTERPRETATION 0 0))
                                                 0)
                                         (record "*clefG2"
                                                 TOKEN
                                                 (list (token "*clefG2" CLEF 1 0))
                                                 1)
                                         (record "*k[]"
                                                 TOKEN
                                                 (list (token "*k[]" KEY-SIG 2 0))
                                                 2)
                                         (record "*a:"
                                                 TOKEN
                                                 (list (token "*a:" KEY-LABEL 3 0))
                                                 3)
                                         (record "*M3/4"
                                                 TOKEN
                                                 (list (token "*M3/4" TIME-SIG 4 0))
                                                 4)
                                         (record "*^"
                                                 TOKEN
                                                 (list (token "*^" SPINE-SPLIT 5 0))
                                                 5)
                                         (record "4c\t4c"
                                                 TOKEN
                                                 (list (token "4c" SPINE-DATA 6 0)
                                                       (token "4c" SPINE-DATA 6 1))
                                                 6)
                                         (record "4c\t4c"
                                                 TOKEN
                                                 (list (token "4c" SPINE-DATA 7 0)
                                                       (token "4c" SPINE-DATA 7 1))
                                                 7)
                                         (record "4c\t4c"
                                                 TOKEN
                                                 (list (token "4c" SPINE-DATA 8 0)
                                                       (token "4c" SPINE-DATA 8 1))
                                                 8)
                                         (record "=2\t=2"
                                                 TOKEN
                                                 (list (token "=2" MEASURE 9 0)
                                                       (token "=2" MEASURE 9 1))
                                                 9)
                                         (record "4c\t4c"
                                                 TOKEN
                                                 (list (token "4c" SPINE-DATA 10 0)
                                                       (token "4c" SPINE-DATA 10 1))
                                                 10)
                                         (record "4c\t4c"
                                                 TOKEN
                                                 (list (token "4c" SPINE-DATA 11 0)
                                                       (token "4c" SPINE-DATA 11 1))
                                                 11)
                                         (record "4c\t4c"
                                                 TOKEN
                                                 (list (token "4c" SPINE-DATA 12 0)
                                                       (token "4c" SPINE-DATA 12 1))
                                                 12)
                                         (record "=3\t=3"
                                                 TOKEN
                                                 (list (token "=3" MEASURE 13 0)
                                                       (token "=3" MEASURE 13 1))
                                                 13)
                                         (record "4c\t4c"
                                                 TOKEN
                                                 (list (token "4c" SPINE-DATA 14 0)
                                                       (token "4c" SPINE-DATA 14 1))
                                                 14)
                                         (record "4c\t4c"
                                                 TOKEN
                                                 (list (token "4c" SPINE-DATA 15 0)
                                                       (token "4c" SPINE-DATA 15 1))
                                                 15)
                                         (record "4c\t4c"
                                                 TOKEN
                                                 (list (token "4c" SPINE-DATA 16 0)
                                                       (token "4c" SPINE-DATA 16 1))
                                                 16)
                                         (record "*v\t*v"
                                                 TOKEN
                                                 (list (token "*v" SPINE-JOIN 17 0)
                                                       (token "*v" SPINE-JOIN 17 1))
                                                 17)
                                         (record "=="
                                                 TOKEN
                                                 (list (token "==" MEASURE 18 0))
                                                 18)
                                         (record "*-"
                                                 TOKEN
                                                 (list (token "*-" SPINE-TERMINATOR 19 0))
                                                 19))))
              (list (global-spine KERN
                                  (list (list (token "**kern" EXCLUSIVE-INTERPRETATION 0 0))
                                        (list (token "*clefG2" CLEF 1 0))
                                        (list (token "*k[]" KEY-SIG 2 0))
                                        (list (token "*a:" KEY-LABEL 3 0))
                                        (list (token "*M3/4" TIME-SIG 4 0))
                                        (list (token "*^" SPINE-SPLIT 5 0))
                                        (list (token "4c" SPINE-DATA 6 0)
                                              (token "4c" SPINE-DATA 6 1))
                                        (list (token "4c" SPINE-DATA 7 0)
                                              (token "4c" SPINE-DATA 7 1))
                                        (list (token "4c" SPINE-DATA 8 0)
                                              (token "4c" SPINE-DATA 8 1))
                                        (list (token "=2" MEASURE 9 0)
                                              (token "=2" MEASURE 9 1))
                                        (list (token "4c" SPINE-DATA 10 0)
                                              (token "4c" SPINE-DATA 10 1))
                                        (list (token "4c" SPINE-DATA 11 0)
                                              (token "4c" SPINE-DATA 11 1))
                                        (list (token "4c" SPINE-DATA 12 0)
                                              (token "4c" SPINE-DATA 12 1))
                                        (list (token "=3" MEASURE 13 0)
                                              (token "=3" MEASURE 13 1))
                                        (list (token "4c" SPINE-DATA 14 0)
                                              (token "4c" SPINE-DATA 14 1))
                                        (list (token "4c" SPINE-DATA 15 0)
                                              (token "4c" SPINE-DATA 15 1))
                                        (list (token "4c" SPINE-DATA 16 0)
                                              (token "4c" SPINE-DATA 16 1))
                                        (list (token "*v" SPINE-JOIN 17 0)
                                              (token "*v" SPINE-JOIN 17 1))
                                        (list (token "==" MEASURE 18 0))
                                        (list (token "*-" SPINE-TERMINATOR 19 0)))
                                  0)))
(check-expect (hgraph->hfile (hgraph (root (list (list (leaf (token "**kern" EXCLUSIVE-INTERPRETATION 0 0))
                                                       (leaf (token "*clefG2" CLEF 1 0))
                                                       (leaf (token "*k[]" KEY-SIG 2 0))
                                                       (leaf (token "*a:" KEY-LABEL 3 0))
                                                       (leaf (token "*M3/4" TIME-SIG 4 0))
                                                       (parent (token "*^" SPINE-SPLIT 5 0)
                                                               (list (leaf (token "4c" SPINE-DATA 6 0))
                                                                     (leaf (token "4c" SPINE-DATA 7 0))
                                                                     (leaf (token "4c" SPINE-DATA 8 0))
                                                                     (leaf (token "=2" MEASURE 9 0))
                                                                     (leaf (token "4c" SPINE-DATA 10 0))
                                                                     (leaf (token "4c" SPINE-DATA 11 0))
                                                                     (leaf (token "4c" SPINE-DATA 12 0))
                                                                     (leaf (token "=3" MEASURE 13 0))
                                                                     (leaf (token "4c" SPINE-DATA 14 0))
                                                                     (leaf (token "4c" SPINE-DATA 15 0))
                                                                     (leaf (token "4c" SPINE-DATA 16 0))
                                                                     (leaf (token "*v" SPINE-JOIN 17 0)))
                                                               (list (leaf (token "4c" SPINE-DATA 6 1))
                                                                     (leaf (token "4c" SPINE-DATA 7 1))
                                                                     (leaf (token "4c" SPINE-DATA 8 1))
                                                                     (leaf (token "=2" MEASURE 9 1))
                                                                     (leaf (token "4c" SPINE-DATA 10 1))
                                                                     (leaf (token "4c" SPINE-DATA 11 1))
                                                                     (leaf (token "4c" SPINE-DATA 12 1))
                                                                     (leaf (token "=3" MEASURE 13 1))
                                                                     (leaf (token "4c" SPINE-DATA 14 1))
                                                                     (leaf (token "4c" SPINE-DATA 15 1))
                                                                     (leaf (token "4c" SPINE-DATA 16 1))
                                                                     (leaf (token "*v" SPINE-JOIN 17 1))))
                                                       (leaf (token "==" MEASURE 18 0))
                                                       (leaf (token "*-" SPINE-TERMINATOR 19 0)))))))
              (path->hfile "../../data/count/one-spine-one-split.krn"))
(check-expect (lolot->lor (list (list (token "**kern" EXCLUSIVE-INTERPRETATION 0 0))
                                (list (token "*clefG2" CLEF 1 0))
                                (list (token "*k[]" KEY-SIG 2 0))
                                (list (token "*a:" KEY-LABEL 3 0))
                                (list (token "*M3/4" TIME-SIG 4 0))
                                (list (token "*^" SPINE-SPLIT 5 0))
                                (list (token "4c" SPINE-DATA 6 0)
                                      (token "4c" SPINE-DATA 6 1))
                                (list (token "4c" SPINE-DATA 7 0)
                                      (token "4c" SPINE-DATA 7 1))
                                (list (token "4c" SPINE-DATA 8 0)
                                      (token "4c" SPINE-DATA 8 1))
                                (list (token "=2" MEASURE 9 0)
                                      (token "=2" MEASURE 9 1))
                                (list (token "4c" SPINE-DATA 10 0)
                                      (token "4c" SPINE-DATA 10 1))
                                (list (token "4c" SPINE-DATA 11 0)
                                      (token "4c" SPINE-DATA 11 1))
                                (list (token "4c" SPINE-DATA 12 0)
                                      (token "4c" SPINE-DATA 12 1))
                                (list (token "=3" MEASURE 13 0)
                                      (token "=3" MEASURE 13 1))
                                (list (token "4c" SPINE-DATA 14 0)
                                      (token "4c" SPINE-DATA 14 1))
                                (list (token "4c" SPINE-DATA 15 0)
                                      (token "4c" SPINE-DATA 15 1))
                                (list (token "4c" SPINE-DATA 16 0)
                                      (token "4c" SPINE-DATA 16 1))
                                (list (token "*v" SPINE-JOIN 17 0)
                                      (token "*v" SPINE-JOIN 17 1))
                                (list (token "==" MEASURE 18 0))
                                (list (token "*-" SPINE-TERMINATOR 19 0))))
              (list (record "**kern"
                            TOKEN
                            (list (token "**kern" EXCLUSIVE-INTERPRETATION 0 0))
                            0)
                    (record "*clefG2"
                            TOKEN
                            (list (token "*clefG2" CLEF 1 0))
                            1)
                    (record "*k[]"
                            TOKEN
                            (list (token "*k[]" KEY-SIG 2 0))
                            2)
                    (record "*a:"
                            TOKEN
                            (list (token "*a:" KEY-LABEL 3 0))
                            3)
                    (record "*M3/4"
                            TOKEN
                            (list (token "*M3/4" TIME-SIG 4 0))
                            4)
                    (record "*^"
                            TOKEN
                            (list (token "*^" SPINE-SPLIT 5 0))
                            5)
                    (record "4c\t4c"
                            TOKEN
                            (list (token "4c" SPINE-DATA 6 0)
                                  (token "4c" SPINE-DATA 6 1))
                            6)
                    (record "4c\t4c"
                            TOKEN
                            (list (token "4c" SPINE-DATA 7 0)
                                  (token "4c" SPINE-DATA 7 1))
                            7)
                    (record "4c\t4c"
                            TOKEN
                            (list (token "4c" SPINE-DATA 8 0)
                                  (token "4c" SPINE-DATA 8 1))
                            8)
                    (record "=2\t=2"
                            TOKEN
                            (list (token "=2" MEASURE 9 0)
                                  (token "=2" MEASURE 9 1))
                            9)
                    (record "4c\t4c"
                            TOKEN
                            (list (token "4c" SPINE-DATA 10 0)
                                  (token "4c" SPINE-DATA 10 1))
                            10)
                    (record "4c\t4c"
                            TOKEN
                            (list (token "4c" SPINE-DATA 11 0)
                                  (token "4c" SPINE-DATA 11 1))
                            11)
                    (record "4c\t4c"
                            TOKEN
                            (list (token "4c" SPINE-DATA 12 0)
                                  (token "4c" SPINE-DATA 12 1))
                            12)
                    (record "=3\t=3"
                            TOKEN
                            (list (token "=3" MEASURE 13 0)
                                  (token "=3" MEASURE 13 1))
                            13)
                    (record "4c\t4c"
                            TOKEN
                            (list (token "4c" SPINE-DATA 14 0)
                                  (token "4c" SPINE-DATA 14 1))
                            14)
                    (record "4c\t4c"
                            TOKEN
                            (list (token "4c" SPINE-DATA 15 0)
                                  (token "4c" SPINE-DATA 15 1))
                            15)
                    (record "4c\t4c"
                            TOKEN
                            (list (token "4c" SPINE-DATA 16 0)
                                  (token "4c" SPINE-DATA 16 1))
                            16)
                    (record "*v\t*v"
                            TOKEN
                            (list (token "*v" SPINE-JOIN 17 0)
                                  (token "*v" SPINE-JOIN 17 1))
                            17)
                    (record "=="
                            TOKEN
                            (list (token "==" MEASURE 18 0))
                            18)
                    (record "*-"
                            TOKEN
                            (list (token "*-" SPINE-TERMINATOR 19 0))
                            19)))
(check-expect (hgraph->lolot (hgraph (root (list (list (leaf (token "**kern" EXCLUSIVE-INTERPRETATION 0 0))
                                                       (leaf (token "*clefG2" CLEF 1 0))
                                                       (leaf (token "*k[]" KEY-SIG 2 0))
                                                       (leaf (token "*a:" KEY-LABEL 3 0))
                                                       (leaf (token "*M3/4" TIME-SIG 4 0))
                                                       (parent (token "*^" SPINE-SPLIT 5 0)
                                                               (list (leaf (token "4c" SPINE-DATA 6 0))
                                                                     (leaf (token "4c" SPINE-DATA 7 0))
                                                                     (leaf (token "4c" SPINE-DATA 8 0))
                                                                     (leaf (token "=2" MEASURE 9 0))
                                                                     (leaf (token "4c" SPINE-DATA 10 0))
                                                                     (leaf (token "4c" SPINE-DATA 11 0))
                                                                     (leaf (token "4c" SPINE-DATA 12 0))
                                                                     (leaf (token "=3" MEASURE 13 0))
                                                                     (leaf (token "4c" SPINE-DATA 14 0))
                                                                     (leaf (token "4c" SPINE-DATA 15 0))
                                                                     (leaf (token "4c" SPINE-DATA 16 0))
                                                                     (leaf (token "*v" SPINE-JOIN 17 0)))
                                                               (list (leaf (token "4c" SPINE-DATA 6 1))
                                                                     (leaf (token "4c" SPINE-DATA 7 1))
                                                                     (leaf (token "4c" SPINE-DATA 8 1))
                                                                     (leaf (token "=2" MEASURE 9 1))
                                                                     (leaf (token "4c" SPINE-DATA 10 1))
                                                                     (leaf (token "4c" SPINE-DATA 11 1))
                                                                     (leaf (token "4c" SPINE-DATA 12 1))
                                                                     (leaf (token "=3" MEASURE 13 1))
                                                                     (leaf (token "4c" SPINE-DATA 14 1))
                                                                     (leaf (token "4c" SPINE-DATA 15 1))
                                                                     (leaf (token "4c" SPINE-DATA 16 1))
                                                                     (leaf (token "*v" SPINE-JOIN 17 1))))
                                                       (leaf (token "==" MEASURE 18 0))
                                                       (leaf (token "*-" SPINE-TERMINATOR 19 0)))))))
              (list (list (token "**kern" EXCLUSIVE-INTERPRETATION 0 0))
                    (list (token "*clefG2" CLEF 1 0))
                    (list (token "*k[]" KEY-SIG 2 0))
                    (list (token "*a:" KEY-LABEL 3 0))
                    (list (token "*M3/4" TIME-SIG 4 0))
                    (list (token "*^" SPINE-SPLIT 5 0))
                    (list (token "4c" SPINE-DATA 6 0)
                          (token "4c" SPINE-DATA 6 1))
                    (list (token "4c" SPINE-DATA 7 0)
                          (token "4c" SPINE-DATA 7 1))
                    (list (token "4c" SPINE-DATA 8 0)
                          (token "4c" SPINE-DATA 8 1))
                    (list (token "=2" MEASURE 9 0)
                          (token "=2" MEASURE 9 1))
                    (list (token "4c" SPINE-DATA 10 0)
                          (token "4c" SPINE-DATA 10 1))
                    (list (token "4c" SPINE-DATA 11 0)
                          (token "4c" SPINE-DATA 11 1))
                    (list (token "4c" SPINE-DATA 12 0)
                          (token "4c" SPINE-DATA 12 1))
                    (list (token "=3" MEASURE 13 0)
                          (token "=3" MEASURE 13 1))
                    (list (token "4c" SPINE-DATA 14 0)
                          (token "4c" SPINE-DATA 14 1))
                    (list (token "4c" SPINE-DATA 15 0)
                          (token "4c" SPINE-DATA 15 1))
                    (list (token "4c" SPINE-DATA 16 0)
                          (token "4c" SPINE-DATA 16 1))
                    (list (token "*v" SPINE-JOIN 17 0)
                          (token "*v" SPINE-JOIN 17 1))
                    (list (token "==" MEASURE 18 0))
                    (list (token "*-" SPINE-TERMINATOR 19 0))))
(check-expect (hfile->hgraph (path->hfile "../../data/count/one-spine-one-split.krn"))
              (hgraph (root (list (list (leaf (token "**kern" EXCLUSIVE-INTERPRETATION 0 0))
                                        (leaf (token "*clefG2" CLEF 1 0))
                                        (leaf (token "*k[]" KEY-SIG 2 0))
                                        (leaf (token "*a:" KEY-LABEL 3 0))
                                        (leaf (token "*M3/4" TIME-SIG 4 0))
                                        (parent (token "*^" SPINE-SPLIT 5 0)
                                                (list (leaf (token "4c" SPINE-DATA 6 0))
                                                      (leaf (token "4c" SPINE-DATA 7 0))
                                                      (leaf (token "4c" SPINE-DATA 8 0))
                                                      (leaf (token "=2" MEASURE 9 0))
                                                      (leaf (token "4c" SPINE-DATA 10 0))
                                                      (leaf (token "4c" SPINE-DATA 11 0))
                                                      (leaf (token "4c" SPINE-DATA 12 0))
                                                      (leaf (token "=3" MEASURE 13 0))
                                                      (leaf (token "4c" SPINE-DATA 14 0))
                                                      (leaf (token "4c" SPINE-DATA 15 0))
                                                      (leaf (token "4c" SPINE-DATA 16 0))
                                                      (leaf (token "*v" SPINE-JOIN 17 0)))
                                                (list (leaf (token "4c" SPINE-DATA 6 1))
                                                      (leaf (token "4c" SPINE-DATA 7 1))
                                                      (leaf (token "4c" SPINE-DATA 8 1))
                                                      (leaf (token "=2" MEASURE 9 1))
                                                      (leaf (token "4c" SPINE-DATA 10 1))
                                                      (leaf (token "4c" SPINE-DATA 11 1))
                                                      (leaf (token "4c" SPINE-DATA 12 1))
                                                      (leaf (token "=3" MEASURE 13 1))
                                                      (leaf (token "4c" SPINE-DATA 14 1))
                                                      (leaf (token "4c" SPINE-DATA 15 1))
                                                      (leaf (token "4c" SPINE-DATA 16 1))
                                                      (leaf (token "*v" SPINE-JOIN 17 1))))
                                        (leaf (token "==" MEASURE 18 0))
                                        (leaf (token "*-" SPINE-TERMINATOR 19 0)))))))
(check-expect (branch->lot (list (leaf (token "**kern" EXCLUSIVE-INTERPRETATION 0 0))
                                 (leaf (token "*clefG2" CLEF 1 0))
                                 (leaf (token "*k[]" KEY-SIG 2 0))
                                 (leaf (token "*a:" KEY-LABEL 3 0))
                                 (leaf (token "*M3/4" TIME-SIG 4 0))
                                 (parent (token "*^" SPINE-SPLIT 5 0)
                                         (list (leaf (token "4c" SPINE-DATA 6 0))
                                               (leaf (token "4c" SPINE-DATA 7 0))
                                               (leaf (token "4c" SPINE-DATA 8 0))
                                               (leaf (token "=2" MEASURE 9 0))
                                               (leaf (token "4c" SPINE-DATA 10 0))
                                               (leaf (token "4c" SPINE-DATA 11 0))
                                               (leaf (token "4c" SPINE-DATA 12 0))
                                               (leaf (token "=3" MEASURE 13 0))
                                               (leaf (token "4c" SPINE-DATA 14 0))
                                               (leaf (token "4c" SPINE-DATA 15 0))
                                               (leaf (token "4c" SPINE-DATA 16 0))
                                               (leaf (token "*v" SPINE-JOIN 17 0)))
                                         (list (leaf (token "4c" SPINE-DATA 6 1))
                                               (leaf (token "4c" SPINE-DATA 7 1))
                                               (leaf (token "4c" SPINE-DATA 8 1))
                                               (leaf (token "=2" MEASURE 9 1))
                                               (leaf (token "4c" SPINE-DATA 10 1))
                                               (leaf (token "4c" SPINE-DATA 11 1))
                                               (leaf (token "4c" SPINE-DATA 12 1))
                                               (leaf (token "=3" MEASURE 13 1))
                                               (leaf (token "4c" SPINE-DATA 14 1))
                                               (leaf (token "4c" SPINE-DATA 15 1))
                                               (leaf (token "4c" SPINE-DATA 16 1))
                                               (leaf (token "*v" SPINE-JOIN 17 1))))
                                 (leaf (token "==" MEASURE 18 0))
                                 (leaf (token "*-" SPINE-TERMINATOR 19 0))))
              (list (token "**kern" EXCLUSIVE-INTERPRETATION 0 0)
                    (token "*clefG2" CLEF 1 0)
                    (token "*k[]" KEY-SIG 2 0)
                    (token "*a:" KEY-LABEL 3 0)
                    (token "*M3/4" TIME-SIG 4 0)
                    (token "*^" SPINE-SPLIT 5 0)
                    (token "4c" SPINE-DATA 6 0)
                    (token "4c" SPINE-DATA 7 0)
                    (token "4c" SPINE-DATA 8 0)
                    (token "=2" MEASURE 9 0)
                    (token "4c" SPINE-DATA 10 0)
                    (token "4c" SPINE-DATA 11 0)
                    (token "4c" SPINE-DATA 12 0)
                    (token "=3" MEASURE 13 0)
                    (token "4c" SPINE-DATA 14 0)
                    (token "4c" SPINE-DATA 15 0)
                    (token "4c" SPINE-DATA 16 0)
                    (token "*v" SPINE-JOIN 17 0)
                    (token "4c" SPINE-DATA 6 1)
                    (token "4c" SPINE-DATA 7 1)
                    (token "4c" SPINE-DATA 8 1)
                    (token "=2" MEASURE 9 1)
                    (token "4c" SPINE-DATA 10 1)
                    (token "4c" SPINE-DATA 11 1)
                    (token "4c" SPINE-DATA 12 1)
                    (token "=3" MEASURE 13 1)
                    (token "4c" SPINE-DATA 14 1)
                    (token "4c" SPINE-DATA 15 1)
                    (token "4c" SPINE-DATA 16 1)
                    (token "*v" SPINE-JOIN 17 1)
                    (token "==" MEASURE 18 0)
                    (token "*-" SPINE-TERMINATOR 19 0)))
(check-expect (gspines->linked-spines (spine-parser (path->hfile "../../data/count/one-spine-one-split.krn"))
                                      (path->hfile "../../data/count/one-spine-one-split.krn"))
              (list (linked-spine KERN-0-0)))

(test)
