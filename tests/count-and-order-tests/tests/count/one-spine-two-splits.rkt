#lang racket/base

(require "../../../../parser/data-definitions/data-definitions.rkt"
         "../../../../parser/functions/file.rkt"
         "../../../../parser/functions/spine-parser.rkt"
         "../../../../parser/data-structures/humdrum-graph/data-definitions/data-definitions.rkt"
         "../../../../parser/data-structures/humdrum-graph/functions/hgraph-to-hfile.rkt"
         "../../../../parser/data-structures/humdrum-graph/functions/hfile-to-hgraph.rkt"
         test-engine/racket-tests)

(check-expect (path->hfile "../../data/count/one-spine-two-splits.krn")
              (hfile (list (record "**kern"
                                   TOKEN
                                   (list (token "**kern" EXCLUSIVE-INTERPRETATION 0 0))
                                   0)
                           (record "*clefG2" TOKEN (list (token "*clefG2" CLEF 1 0)) 1)
                           (record "*k[]" TOKEN (list (token "*k[]" KEY-SIG 2 0)) 2)
                           (record "*a:" TOKEN (list (token "*a:" KEY-LABEL 3 0)) 3)
                           (record "*M3/4" TOKEN (list (token "*M3/4" TIME-SIG 4 0)) 4)
                           (record "*^" TOKEN (list (token "*^" SPINE-SPLIT 5 0)) 5)
                           (record "*\t*^"
                                   TOKEN
                                   (list (token "*" NULL-INTERPRETATION 6 0)
                                         (token "*^" SPINE-SPLIT 6 1))
                                   6)
                           (record "4c\t4c\t4c"
                                   TOKEN
                                   (list (token "4c" SPINE-DATA 7 0)
                                         (token "4c" SPINE-DATA 7 1)
                                         (token "4c" SPINE-DATA 7 2))
                                   7)
                           (record "4c\t4c\t4c"
                                   TOKEN
                                   (list (token "4c" SPINE-DATA 8 0)
                                         (token "4c" SPINE-DATA 8 1)
                                         (token "4c" SPINE-DATA 8 2))
                                   8)
                           (record "4c\t4c\t4c"
                                   TOKEN
                                   (list (token "4c" SPINE-DATA 9 0)
                                         (token "4c" SPINE-DATA 9 1)
                                         (token "4c" SPINE-DATA 9 2))
                                   9)
                           (record "=2\t=2\t=2"
                                   TOKEN
                                   (list (token "=2" MEASURE 10 0)
                                         (token "=2" MEASURE 10 1)
                                         (token "=2" MEASURE 10 2))
                                   10)
                           (record "4c\t4c\t4c"
                                   TOKEN
                                   (list (token "4c" SPINE-DATA 11 0)
                                         (token "4c" SPINE-DATA 11 1)
                                         (token "4c" SPINE-DATA 11 2))
                                   11)
                           (record "4c\t4c\t4c"
                                   TOKEN
                                   (list (token "4c" SPINE-DATA 12 0)
                                         (token "4c" SPINE-DATA 12 1)
                                         (token "4c" SPINE-DATA 12 2))
                                   12)
                           (record "4c\t4c\t4c"
                                   TOKEN
                                   (list (token "4c" SPINE-DATA 13 0)
                                         (token "4c" SPINE-DATA 13 1)
                                         (token "4c" SPINE-DATA 13 2))
                                   13)
                           (record "=3\t=3\t=3"
                                   TOKEN
                                   (list (token "=3" MEASURE 14 0)
                                         (token "=3" MEASURE 14 1)
                                         (token "=3" MEASURE 14 2))
                                   14)
                           (record "4c\t4c\t4c"
                                   TOKEN
                                   (list (token "4c" SPINE-DATA 15 0)
                                         (token "4c" SPINE-DATA 15 1)
                                         (token "4c" SPINE-DATA 15 2))
                                   15)
                           (record "4c\t4c\t4c"
                                   TOKEN
                                   (list (token "4c" SPINE-DATA 16 0)
                                         (token "4c" SPINE-DATA 16 1)
                                         (token "4c" SPINE-DATA 16 2))
                                   16)
                           (record "4c\t4c\t4c"
                                   TOKEN
                                   (list (token "4c" SPINE-DATA 17 0)
                                         (token "4c" SPINE-DATA 17 1)
                                         (token "4c" SPINE-DATA 17 2))
                                   17)
                           (record "*\t*v\t*v"
                                   TOKEN
                                   (list (token "*" NULL-INTERPRETATION 18 0)
                                         (token "*v" SPINE-JOIN 18 1)
                                         (token "*v" SPINE-JOIN 18 2))
                                   18)
                           (record "*v\t*v"
                                   TOKEN
                                   (list (token "*v" SPINE-JOIN 19 0)
                                         (token "*v" SPINE-JOIN 19 1))
                                   19)
                           (record "==" TOKEN (list (token "==" MEASURE 20 0)) 20)
                           (record "*-" TOKEN (list (token "*-" SPINE-TERMINATOR 21 0)) 21))))
(check-expect (spine-parser (hfile (list (record "**kern"
                                                 TOKEN
                                                 (list (token "**kern" EXCLUSIVE-INTERPRETATION 0 0))
                                                 0)
                                         (record "*clefG2" TOKEN (list (token "*clefG2" CLEF 1 0)) 1)
                                         (record "*k[]" TOKEN (list (token "*k[]" KEY-SIG 2 0)) 2)
                                         (record "*a:" TOKEN (list (token "*a:" KEY-LABEL 3 0)) 3)
                                         (record "*M3/4" TOKEN (list (token "*M3/4" TIME-SIG 4 0)) 4)
                                         (record "*^" TOKEN (list (token "*^" SPINE-SPLIT 5 0)) 5)
                                         (record "*\t*^"
                                                 TOKEN
                                                 (list (token "*" NULL-INTERPRETATION 6 0)
                                                       (token "*^" SPINE-SPLIT 6 1))
                                                 6)
                                         (record "4c\t4c\t4c"
                                                 TOKEN
                                                 (list (token "4c" SPINE-DATA 7 0)
                                                       (token "4c" SPINE-DATA 7 1)
                                                       (token "4c" SPINE-DATA 7 2))
                                                 7)
                                         (record "4c\t4c\t4c"
                                                 TOKEN
                                                 (list (token "4c" SPINE-DATA 8 0)
                                                       (token "4c" SPINE-DATA 8 1)
                                                       (token "4c" SPINE-DATA 8 2))
                                                 8)
                                         (record "4c\t4c\t4c"
                                                 TOKEN
                                                 (list (token "4c" SPINE-DATA 9 0)
                                                       (token "4c" SPINE-DATA 9 1)
                                                       (token "4c" SPINE-DATA 9 2))
                                                 9)
                                         (record "=2\t=2\t=2"
                                                 TOKEN
                                                 (list (token "=2" MEASURE 10 0)
                                                       (token "=2" MEASURE 10 1)
                                                       (token "=2" MEASURE 10 2))
                                                 10)
                                         (record "4c\t4c\t4c"
                                                 TOKEN
                                                 (list (token "4c" SPINE-DATA 11 0)
                                                       (token "4c" SPINE-DATA 11 1)
                                                       (token "4c" SPINE-DATA 11 2))
                                                 11)
                                         (record "4c\t4c\t4c"
                                                 TOKEN
                                                 (list (token "4c" SPINE-DATA 12 0)
                                                       (token "4c" SPINE-DATA 12 1)
                                                       (token "4c" SPINE-DATA 12 2))
                                                 12)
                                         (record "4c\t4c\t4c"
                                                 TOKEN
                                                 (list (token "4c" SPINE-DATA 13 0)
                                                       (token "4c" SPINE-DATA 13 1)
                                                       (token "4c" SPINE-DATA 13 2))
                                                 13)
                                         (record "=3\t=3\t=3"
                                                 TOKEN
                                                 (list (token "=3" MEASURE 14 0)
                                                       (token "=3" MEASURE 14 1)
                                                       (token "=3" MEASURE 14 2))
                                                 14)
                                         (record "4c\t4c\t4c"
                                                 TOKEN
                                                 (list (token "4c" SPINE-DATA 15 0)
                                                       (token "4c" SPINE-DATA 15 1)
                                                       (token "4c" SPINE-DATA 15 2))
                                                 15)
                                         (record "4c\t4c\t4c"
                                                 TOKEN
                                                 (list (token "4c" SPINE-DATA 16 0)
                                                       (token "4c" SPINE-DATA 16 1)
                                                       (token "4c" SPINE-DATA 16 2))
                                                 16)
                                         (record "4c\t4c\t4c"
                                                 TOKEN
                                                 (list (token "4c" SPINE-DATA 17 0)
                                                       (token "4c" SPINE-DATA 17 1)
                                                       (token "4c" SPINE-DATA 17 2))
                                                 17)
                                         (record "*\t*v\t*v"
                                                 TOKEN
                                                 (list (token "*" NULL-INTERPRETATION 18 0)
                                                       (token "*v" SPINE-JOIN 18 1)
                                                       (token "*v" SPINE-JOIN 18 2))
                                                 18)
                                         (record "*v\t*v"
                                                 TOKEN
                                                 (list (token "*v" SPINE-JOIN 19 0)
                                                       (token "*v" SPINE-JOIN 19 1))
                                                 19)
                                         (record "==" TOKEN (list (token "==" MEASURE 20 0)) 20)
                                         (record "*-"
                                                 TOKEN
                                                 (list (token "*-" SPINE-TERMINATOR 21 0))
                                                 21))))
              (list (global-spine KERN
                                  (list (list (token "**kern" EXCLUSIVE-INTERPRETATION 0 0))
                                        (list (token "*clefG2" CLEF 1 0))
                                        (list (token "*k[]" KEY-SIG 2 0))
                                        (list (token "*a:" KEY-LABEL 3 0))
                                        (list (token "*M3/4" TIME-SIG 4 0))
                                        (list (token "*^" SPINE-SPLIT 5 0))
                                        (list (token "*" NULL-INTERPRETATION 6 0)
                                              (token "*^" SPINE-SPLIT 6 1))
                                        (list (token "4c" SPINE-DATA 7 0)
                                              (token "4c" SPINE-DATA 7 1)
                                              (token "4c" SPINE-DATA 7 2))
                                        (list (token "4c" SPINE-DATA 8 0)
                                              (token "4c" SPINE-DATA 8 1)
                                              (token "4c" SPINE-DATA 8 2))
                                        (list (token "4c" SPINE-DATA 9 0)
                                              (token "4c" SPINE-DATA 9 1)
                                              (token "4c" SPINE-DATA 9 2))
                                        (list (token "=2" MEASURE 10 0)
                                              (token "=2" MEASURE 10 1)
                                              (token "=2" MEASURE 10 2))
                                        (list (token "4c" SPINE-DATA 11 0)
                                              (token "4c" SPINE-DATA 11 1)
                                              (token "4c" SPINE-DATA 11 2))
                                        (list (token "4c" SPINE-DATA 12 0)
                                              (token "4c" SPINE-DATA 12 1)
                                              (token "4c" SPINE-DATA 12 2))
                                        (list (token "4c" SPINE-DATA 13 0)
                                              (token "4c" SPINE-DATA 13 1)
                                              (token "4c" SPINE-DATA 13 2))
                                        (list (token "=3" MEASURE 14 0)
                                              (token "=3" MEASURE 14 1)
                                              (token "=3" MEASURE 14 2))
                                        (list (token "4c" SPINE-DATA 15 0)
                                              (token "4c" SPINE-DATA 15 1)
                                              (token "4c" SPINE-DATA 15 2))
                                        (list (token "4c" SPINE-DATA 16 0)
                                              (token "4c" SPINE-DATA 16 1)
                                              (token "4c" SPINE-DATA 16 2))
                                        (list (token "4c" SPINE-DATA 17 0)
                                              (token "4c" SPINE-DATA 17 1)
                                              (token "4c" SPINE-DATA 17 2))
                                        (list (token "*" NULL-INTERPRETATION 18 0)
                                              (token "*v" SPINE-JOIN 18 1)
                                              (token "*v" SPINE-JOIN 18 2))
                                        (list (token "*v" SPINE-JOIN 19 0)
                                              (token "*v" SPINE-JOIN 19 1))
                                        (list (token "==" MEASURE 20 0))
                                        (list (token "*-" SPINE-TERMINATOR 21 0)))
                                  0)))
(check-expect (hgraph->hfile
               (hgraph (root (list (list (leaf (token "**kern" EXCLUSIVE-INTERPRETATION 0 0))
                                         (leaf (token "*clefG2" CLEF 1 0))
                                         (leaf (token "*k[]" KEY-SIG 2 0))
                                         (leaf (token "*a:" KEY-LABEL 3 0))
                                         (leaf (token "*M3/4" TIME-SIG 4 0))
                                         (parent (token "*^" SPINE-SPLIT 5 0)
                                                 (list (leaf (token "*" NULL-INTERPRETATION 6 0))
                                                       (leaf (token "4c" SPINE-DATA 7 0))
                                                       (leaf (token "4c" SPINE-DATA 8 0))
                                                       (leaf (token "4c" SPINE-DATA 9 0))
                                                       (leaf (token "=2" MEASURE 10 0))
                                                       (leaf (token "4c" SPINE-DATA 11 0))
                                                       (leaf (token "4c" SPINE-DATA 12 0))
                                                       (leaf (token "4c" SPINE-DATA 13 0))
                                                       (leaf (token "=3" MEASURE 14 0))
                                                       (leaf (token "4c" SPINE-DATA 15 0))
                                                       (leaf (token "4c" SPINE-DATA 16 0))
                                                       (leaf (token "4c" SPINE-DATA 17 0))
                                                       (leaf (token "*" NULL-INTERPRETATION 18 0))
                                                       (leaf (token "*v" SPINE-JOIN 19 0)))
                                                 (list (parent (token "*^" SPINE-SPLIT 6 1)
                                                               (list (leaf (token "4c" SPINE-DATA 7 1))
                                                                     (leaf (token "4c" SPINE-DATA 8 1))
                                                                     (leaf (token "4c" SPINE-DATA 9 1))
                                                                     (leaf (token "=2" MEASURE 10 1))
                                                                     (leaf (token "4c" SPINE-DATA 11 1))
                                                                     (leaf (token "4c" SPINE-DATA 12 1))
                                                                     (leaf (token "4c" SPINE-DATA 13 1))
                                                                     (leaf (token "=3" MEASURE 14 1))
                                                                     (leaf (token "4c" SPINE-DATA 15 1))
                                                                     (leaf (token "4c" SPINE-DATA 16 1))
                                                                     (leaf (token "4c" SPINE-DATA 17 1))
                                                                     (leaf (token "*v" SPINE-JOIN 18 1)))
                                                               (list (leaf (token "4c" SPINE-DATA 7 2))
                                                                     (leaf (token "4c" SPINE-DATA 8 2))
                                                                     (leaf (token "4c" SPINE-DATA 9 2))
                                                                     (leaf (token "=2" MEASURE 10 2))
                                                                     (leaf (token "4c" SPINE-DATA 11 2))
                                                                     (leaf (token "4c" SPINE-DATA 12 2))
                                                                     (leaf (token "4c" SPINE-DATA 13 2))
                                                                     (leaf (token "=3" MEASURE 14 2))
                                                                     (leaf (token "4c" SPINE-DATA 15 2))
                                                                     (leaf (token "4c" SPINE-DATA 16 2))
                                                                     (leaf (token "4c" SPINE-DATA 17 2))
                                                                     (leaf (token "*v" SPINE-JOIN 18 2))))
                                                       (leaf (token "*v" SPINE-JOIN 19 1))))
                                         (leaf (token "==" MEASURE 20 0))
                                         (leaf (token "*-" SPINE-TERMINATOR 21 0)))))))
              (hfile (list (record "**kern"
                                   TOKEN
                                   (list (token "**kern" EXCLUSIVE-INTERPRETATION 0 0))
                                   0)
                           (record "*clefG2" TOKEN (list (token "*clefG2" CLEF 1 0)) 1)
                           (record "*k[]" TOKEN (list (token "*k[]" KEY-SIG 2 0)) 2)
                           (record "*a:" TOKEN (list (token "*a:" KEY-LABEL 3 0)) 3)
                           (record "*M3/4" TOKEN (list (token "*M3/4" TIME-SIG 4 0)) 4)
                           (record "*^" TOKEN (list (token "*^" SPINE-SPLIT 5 0)) 5)
                           (record "*\t*^"
                                   TOKEN
                                   (list (token "*" NULL-INTERPRETATION 6 0)
                                         (token "*^" SPINE-SPLIT 6 1))
                                   6)
                           (record "4c\t4c\t4c"
                                   TOKEN
                                   (list (token "4c" SPINE-DATA 7 0)
                                         (token "4c" SPINE-DATA 7 1)
                                         (token "4c" SPINE-DATA 7 2))
                                   7)
                           (record "4c\t4c\t4c"
                                   TOKEN
                                   (list (token "4c" SPINE-DATA 8 0)
                                         (token "4c" SPINE-DATA 8 1)
                                         (token "4c" SPINE-DATA 8 2))
                                   8)
                           (record "4c\t4c\t4c"
                                   TOKEN
                                   (list (token "4c" SPINE-DATA 9 0)
                                         (token "4c" SPINE-DATA 9 1)
                                         (token "4c" SPINE-DATA 9 2))
                                   9)
                           (record "=2\t=2\t=2"
                                   TOKEN
                                   (list (token "=2" MEASURE 10 0)
                                         (token "=2" MEASURE 10 1)
                                         (token "=2" MEASURE 10 2))
                                   10)
                           (record "4c\t4c\t4c"
                                   TOKEN
                                   (list (token "4c" SPINE-DATA 11 0)
                                         (token "4c" SPINE-DATA 11 1)
                                         (token "4c" SPINE-DATA 11 2))
                                   11)
                           (record "4c\t4c\t4c"
                                   TOKEN
                                   (list (token "4c" SPINE-DATA 12 0)
                                         (token "4c" SPINE-DATA 12 1)
                                         (token "4c" SPINE-DATA 12 2))
                                   12)
                           (record "4c\t4c\t4c"
                                   TOKEN
                                   (list (token "4c" SPINE-DATA 13 0)
                                         (token "4c" SPINE-DATA 13 1)
                                         (token "4c" SPINE-DATA 13 2))
                                   13)
                           (record "=3\t=3\t=3"
                                   TOKEN
                                   (list (token "=3" MEASURE 14 0)
                                         (token "=3" MEASURE 14 1)
                                         (token "=3" MEASURE 14 2))
                                   14)
                           (record "4c\t4c\t4c"
                                   TOKEN
                                   (list (token "4c" SPINE-DATA 15 0)
                                         (token "4c" SPINE-DATA 15 1)
                                         (token "4c" SPINE-DATA 15 2))
                                   15)
                           (record "4c\t4c\t4c"
                                   TOKEN
                                   (list (token "4c" SPINE-DATA 16 0)
                                         (token "4c" SPINE-DATA 16 1)
                                         (token "4c" SPINE-DATA 16 2))
                                   16)
                           (record "4c\t4c\t4c"
                                   TOKEN
                                   (list (token "4c" SPINE-DATA 17 0)
                                         (token "4c" SPINE-DATA 17 1)
                                         (token "4c" SPINE-DATA 17 2))
                                   17)
                           (record "*\t*v\t*v"
                                   TOKEN
                                   (list (token "*" NULL-INTERPRETATION 18 0)
                                         (token "*v" SPINE-JOIN 18 1)
                                         (token "*v" SPINE-JOIN 18 2))
                                   18)
                           (record "*v\t*v"
                                   TOKEN
                                   (list (token "*v" SPINE-JOIN 19 0)
                                         (token "*v" SPINE-JOIN 19 1))
                                   19)
                           (record "==" TOKEN (list (token "==" MEASURE 20 0)) 20)
                           (record "*-" TOKEN (list (token "*-" SPINE-TERMINATOR 21 1)) 21))))
(check-expect (lolot->lor
               (list (list (token "**kern" EXCLUSIVE-INTERPRETATION 0 0))
                     (list (token "*clefG2" CLEF 1 0))
                     (list (token "*k[]" KEY-SIG 2 0))
                     (list (token "*a:" KEY-LABEL 3 0))
                     (list (token "*M3/4" TIME-SIG 4 0))
                     (list (token "*^" SPINE-SPLIT 5 0))
                     (list (token "*" NULL-INTERPRETATION 6 0)
                           (token "*^" SPINE-SPLIT 6 1))
                     (list (token "4c" SPINE-DATA 7 0)
                           (token "4c" SPINE-DATA 7 1)
                           (token "4c" SPINE-DATA 7 2))
                     (list (token "4c" SPINE-DATA 8 0)
                           (token "4c" SPINE-DATA 8 1)
                           (token "4c" SPINE-DATA 8 2))
                     (list (token "4c" SPINE-DATA 9 0)
                           (token "4c" SPINE-DATA 9 1)
                           (token "4c" SPINE-DATA 9 2))
                     (list (token "=2" MEASURE 10 0)
                           (token "=2" MEASURE 10 1)
                           (token "=2" MEASURE 10 2))
                     (list (token "4c" SPINE-DATA 11 0)
                           (token "4c" SPINE-DATA 11 1)
                           (token "4c" SPINE-DATA 11 2))
                     (list (token "4c" SPINE-DATA 12 0)
                           (token "4c" SPINE-DATA 12 1)
                           (token "4c" SPINE-DATA 12 2))
                     (list (token "4c" SPINE-DATA 13 0)
                           (token "4c" SPINE-DATA 13 1)
                           (token "4c" SPINE-DATA 13 2))
                     (list (token "=3" MEASURE 14 0)
                           (token "=3" MEASURE 14 1)
                           (token "=3" MEASURE 14 2))
                     (list (token "4c" SPINE-DATA 15 0)
                           (token "4c" SPINE-DATA 15 1)
                           (token "4c" SPINE-DATA 15 2))
                     (list (token "4c" SPINE-DATA 16 0)
                           (token "4c" SPINE-DATA 16 1)
                           (token "4c" SPINE-DATA 16 2))
                     (list (token "4c" SPINE-DATA 17 0)
                           (token "4c" SPINE-DATA 17 1)
                           (token "4c" SPINE-DATA 17 2))
                     (list (token "*" NULL-INTERPRETATION 18 0)
                           (token "*v" SPINE-JOIN 18 1)
                           (token "*v" SPINE-JOIN 18 2))
                     (list (token "*v" SPINE-JOIN 19 0)
                           (token "*v" SPINE-JOIN 19 1))
                     (list (token "==" MEASURE 20 0))
                     (list (token "*-" SPINE-TERMINATOR 21 0))))
              (list (record "**kern"
                            TOKEN
                            (list (token "**kern" EXCLUSIVE-INTERPRETATION 0 0))
                            0)
                    (record "*clefG2" TOKEN (list (token "*clefG2" CLEF 1 0)) 1)
                    (record "*k[]" TOKEN (list (token "*k[]" KEY-SIG 2 0)) 2)
                    (record "*a:" TOKEN (list (token "*a:" KEY-LABEL 3 0)) 3)
                    (record "*M3/4" TOKEN (list (token "*M3/4" TIME-SIG 4 0)) 4)
                    (record "*^" TOKEN (list (token "*^" SPINE-SPLIT 5 0)) 5)
                    (record "*\t*^"
                            TOKEN
                            (list (token "*" NULL-INTERPRETATION 6 0)
                                  (token "*^" SPINE-SPLIT 6 1))
                            6)
                    (record "4c\t4c\t4c"
                            TOKEN
                            (list (token "4c" SPINE-DATA 7 0)
                                  (token "4c" SPINE-DATA 7 1)
                                  (token "4c" SPINE-DATA 7 2))
                            7)
                    (record "4c\t4c\t4c"
                            TOKEN
                            (list (token "4c" SPINE-DATA 8 0)
                                  (token "4c" SPINE-DATA 8 1)
                                  (token "4c" SPINE-DATA 8 2))
                            8)
                    (record "4c\t4c\t4c"
                            TOKEN
                            (list (token "4c" SPINE-DATA 9 0)
                                  (token "4c" SPINE-DATA 9 1)
                                  (token "4c" SPINE-DATA 9 2))
                            9)
                    (record "=2\t=2\t=2"
                            TOKEN
                            (list (token "=2" MEASURE 10 0)
                                  (token "=2" MEASURE 10 1)
                                  (token "=2" MEASURE 10 2))
                            10)
                    (record "4c\t4c\t4c"
                            TOKEN
                            (list (token "4c" SPINE-DATA 11 0)
                                  (token "4c" SPINE-DATA 11 1)
                                  (token "4c" SPINE-DATA 11 2))
                            11)
                    (record "4c\t4c\t4c"
                            TOKEN
                            (list (token "4c" SPINE-DATA 12 0)
                                  (token "4c" SPINE-DATA 12 1)
                                  (token "4c" SPINE-DATA 12 2))
                            12)
                    (record "4c\t4c\t4c"
                            TOKEN
                            (list (token "4c" SPINE-DATA 13 0)
                                  (token "4c" SPINE-DATA 13 1)
                                  (token "4c" SPINE-DATA 13 2))
                            13)
                    (record "=3\t=3\t=3"
                            TOKEN
                            (list (token "=3" MEASURE 14 0)
                                  (token "=3" MEASURE 14 1)
                                  (token "=3" MEASURE 14 2))
                            14)
                    (record "4c\t4c\t4c"
                            TOKEN
                            (list (token "4c" SPINE-DATA 15 0)
                                  (token "4c" SPINE-DATA 15 1)
                                  (token "4c" SPINE-DATA 15 2))
                            15)
                    (record "4c\t4c\t4c"
                            TOKEN
                            (list (token "4c" SPINE-DATA 16 0)
                                  (token "4c" SPINE-DATA 16 1)
                                  (token "4c" SPINE-DATA 16 2))
                            16)
                    (record "4c\t4c\t4c"
                            TOKEN
                            (list (token "4c" SPINE-DATA 17 0)
                                  (token "4c" SPINE-DATA 17 1)
                                  (token "4c" SPINE-DATA 17 2))
                            17)
                    (record "*\t*v\t*v"
                            TOKEN
                            (list (token "*" NULL-INTERPRETATION 18 0)
                                  (token "*v" SPINE-JOIN 18 1)
                                  (token "*v" SPINE-JOIN 18 2))
                            18)
                    (record "*v\t*v"
                            TOKEN
                            (list (token "*v" SPINE-JOIN 19 0)
                                  (token "*v" SPINE-JOIN 19 1))
                            19)
                    (record "==" TOKEN (list (token "==" MEASURE 20 0)) 20)
                    (record "*-" TOKEN (list (token "*-" SPINE-TERMINATOR 21 1)) 21)))
(check-expect (hgraph->lolot
               (hgraph (root (list (list (leaf (token "**kern" EXCLUSIVE-INTERPRETATION 0 0))
                                         (leaf (token "*clefG2" CLEF 1 0))
                                         (leaf (token "*k[]" KEY-SIG 2 0))
                                         (leaf (token "*a:" KEY-LABEL 3 0))
                                         (leaf (token "*M3/4" TIME-SIG 4 0))
                                         (parent (token "*^" SPINE-SPLIT 5 0)
                                                 (list (leaf (token "*" NULL-INTERPRETATION 6 0))
                                                       (leaf (token "4c" SPINE-DATA 7 0))
                                                       (leaf (token "4c" SPINE-DATA 8 0))
                                                       (leaf (token "4c" SPINE-DATA 9 0))
                                                       (leaf (token "=2" MEASURE 10 0))
                                                       (leaf (token "4c" SPINE-DATA 11 0))
                                                       (leaf (token "4c" SPINE-DATA 12 0))
                                                       (leaf (token "4c" SPINE-DATA 13 0))
                                                       (leaf (token "=3" MEASURE 14 0))
                                                       (leaf (token "4c" SPINE-DATA 15 0))
                                                       (leaf (token "4c" SPINE-DATA 16 0))
                                                       (leaf (token "4c" SPINE-DATA 17 0))
                                                       (leaf (token "*" NULL-INTERPRETATION 18 0))
                                                       (leaf (token "*v" SPINE-JOIN 19 0)))
                                                 (list (parent (token "*^" SPINE-SPLIT 6 1)
                                                               (list (leaf (token "4c" SPINE-DATA 7 1))
                                                                     (leaf (token "4c" SPINE-DATA 8 1))
                                                                     (leaf (token "4c" SPINE-DATA 9 1))
                                                                     (leaf (token "=2" MEASURE 10 1))
                                                                     (leaf (token "4c" SPINE-DATA 11 1))
                                                                     (leaf (token "4c" SPINE-DATA 12 1))
                                                                     (leaf (token "4c" SPINE-DATA 13 1))
                                                                     (leaf (token "=3" MEASURE 14 1))
                                                                     (leaf (token "4c" SPINE-DATA 15 1))
                                                                     (leaf (token "4c" SPINE-DATA 16 1))
                                                                     (leaf (token "4c" SPINE-DATA 17 1))
                                                                     (leaf (token "*v" SPINE-JOIN 18 1)))
                                                               (list (leaf (token "4c" SPINE-DATA 7 2))
                                                                     (leaf (token "4c" SPINE-DATA 8 2))
                                                                     (leaf (token "4c" SPINE-DATA 9 2))
                                                                     (leaf (token "=2" MEASURE 10 2))
                                                                     (leaf (token "4c" SPINE-DATA 11 2))
                                                                     (leaf (token "4c" SPINE-DATA 12 2))
                                                                     (leaf (token "4c" SPINE-DATA 13 2))
                                                                     (leaf (token "=3" MEASURE 14 2))
                                                                     (leaf (token "4c" SPINE-DATA 15 2))
                                                                     (leaf (token "4c" SPINE-DATA 16 2))
                                                                     (leaf (token "4c" SPINE-DATA 17 2))
                                                                     (leaf (token "*v" SPINE-JOIN 18 2))))
                                                       (leaf (token "*v" SPINE-JOIN 19 1))))
                                         (leaf (token "==" MEASURE 20 0))
                                         (leaf (token "*-" SPINE-TERMINATOR 21 0)))))))
              (list (list (token "**kern" EXCLUSIVE-INTERPRETATION 0 0))
                    (list (token "*clefG2" CLEF 1 0))
                    (list (token "*k[]" KEY-SIG 2 0))
                    (list (token "*a:" KEY-LABEL 3 0))
                    (list (token "*M3/4" TIME-SIG 4 0))
                    (list (token "*^" SPINE-SPLIT 5 0))
                    (list (token "*" NULL-INTERPRETATION 6 0)
                          (token "*^" SPINE-SPLIT 6 1))
                    (list (token "4c" SPINE-DATA 7 0)
                          (token "4c" SPINE-DATA 7 1)
                          (token "4c" SPINE-DATA 7 2))
                    (list (token "4c" SPINE-DATA 8 0)
                          (token "4c" SPINE-DATA 8 1)
                          (token "4c" SPINE-DATA 8 2))
                    (list (token "4c" SPINE-DATA 9 0)
                          (token "4c" SPINE-DATA 9 1)
                          (token "4c" SPINE-DATA 9 2))
                    (list (token "=2" MEASURE 10 0)
                          (token "=2" MEASURE 10 1)
                          (token "=2" MEASURE 10 2))
                    (list (token "4c" SPINE-DATA 11 0)
                          (token "4c" SPINE-DATA 11 1)
                          (token "4c" SPINE-DATA 11 2))
                    (list (token "4c" SPINE-DATA 12 0)
                          (token "4c" SPINE-DATA 12 1)
                          (token "4c" SPINE-DATA 12 2))
                    (list (token "4c" SPINE-DATA 13 0)
                          (token "4c" SPINE-DATA 13 1)
                          (token "4c" SPINE-DATA 13 2))
                    (list (token "=3" MEASURE 14 0)
                          (token "=3" MEASURE 14 1)
                          (token "=3" MEASURE 14 2))
                    (list (token "4c" SPINE-DATA 15 0)
                          (token "4c" SPINE-DATA 15 1)
                          (token "4c" SPINE-DATA 15 2))
                    (list (token "4c" SPINE-DATA 16 0)
                          (token "4c" SPINE-DATA 16 1)
                          (token "4c" SPINE-DATA 16 2))
                    (list (token "4c" SPINE-DATA 17 0)
                          (token "4c" SPINE-DATA 17 1)
                          (token "4c" SPINE-DATA 17 2))
                    (list (token "*" NULL-INTERPRETATION 18 0)
                          (token "*v" SPINE-JOIN 18 1)
                          (token "*v" SPINE-JOIN 18 2))
                    (list (token "*v" SPINE-JOIN 19 0)
                          (token "*v" SPINE-JOIN 19 1))
                    (list (token "==" MEASURE 20 0))
                    (list (token "*-" SPINE-TERMINATOR 21 0))))
(check-expect (hfile->hgraph (hfile (list (record "**kern"
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
                                          (record "*\t*^"
                                                  TOKEN
                                                  (list (token "*" NULL-INTERPRETATION 6 0)
                                                        (token "*^" SPINE-SPLIT 6 1))
                                                  6)
                                          (record "4c\t4c\t4c"
                                                  TOKEN
                                                  (list (token "4c" SPINE-DATA 7 0)
                                                        (token "4c" SPINE-DATA 7 1)
                                                        (token "4c" SPINE-DATA 7 2))
                                                  7)
                                          (record "4c\t4c\t4c"
                                                  TOKEN
                                                  (list (token "4c" SPINE-DATA 8 0)
                                                        (token "4c" SPINE-DATA 8 1)
                                                        (token "4c" SPINE-DATA 8 2))
                                                  8)
                                          (record "4c\t4c\t4c"
                                                  TOKEN
                                                  (list (token "4c" SPINE-DATA 9 0)
                                                        (token "4c" SPINE-DATA 9 1)
                                                        (token "4c" SPINE-DATA 9 2))
                                                  9)
                                          (record "=2\t=2\t=2"
                                                  TOKEN
                                                  (list (token "=2" MEASURE 10 0)
                                                        (token "=2" MEASURE 10 1)
                                                        (token "=2" MEASURE 10 2))
                                                  10)
                                          (record "4c\t4c\t4c"
                                                  TOKEN
                                                  (list (token "4c" SPINE-DATA 11 0)
                                                        (token "4c" SPINE-DATA 11 1)
                                                        (token "4c" SPINE-DATA 11 2))
                                                  11)
                                          (record "4c\t4c\t4c"
                                                  TOKEN
                                                  (list (token "4c" SPINE-DATA 12 0)
                                                        (token "4c" SPINE-DATA 12 1)
                                                        (token "4c" SPINE-DATA 12 2))
                                                  12)
                                          (record "4c\t4c\t4c"
                                                  TOKEN
                                                  (list (token "4c" SPINE-DATA 13 0)
                                                        (token "4c" SPINE-DATA 13 1)
                                                        (token "4c" SPINE-DATA 13 2))
                                                  13)
                                          (record "=3\t=3\t=3"
                                                  TOKEN
                                                  (list (token "=3" MEASURE 14 0)
                                                        (token "=3" MEASURE 14 1)
                                                        (token "=3" MEASURE 14 2))
                                                  14)
                                          (record "4c\t4c\t4c"
                                                  TOKEN
                                                  (list (token "4c" SPINE-DATA 15 0)
                                                        (token "4c" SPINE-DATA 15 1)
                                                        (token "4c" SPINE-DATA 15 2))
                                                  15)
                                          (record "4c\t4c\t4c"
                                                  TOKEN
                                                  (list (token "4c" SPINE-DATA 16 0)
                                                        (token "4c" SPINE-DATA 16 1)
                                                        (token "4c" SPINE-DATA 16 2))
                                                  16)
                                          (record "4c\t4c\t4c"
                                                  TOKEN
                                                  (list (token "4c" SPINE-DATA 17 0)
                                                        (token "4c" SPINE-DATA 17 1)
                                                        (token "4c" SPINE-DATA 17 2))
                                                  17)
                                          (record "*\t*v\t*v"
                                                  TOKEN
                                                  (list (token "*" NULL-INTERPRETATION 18 0)
                                                        (token "*v" SPINE-JOIN 18 1)
                                                        (token "*v" SPINE-JOIN 18 2))
                                                  18)
                                          (record "*v\t*v"
                                                  TOKEN
                                                  (list (token "*v" SPINE-JOIN 19 0)
                                                        (token "*v" SPINE-JOIN 19 1))
                                                  19)
                                          (record "==" TOKEN (list (token "==" MEASURE 20 0)) 20)
                                          (record "*-"
                                                  TOKEN
                                                  (list (token "*-" SPINE-TERMINATOR 21 0))
                                                  21))))
              (hgraph (root (list (list (leaf (token "**kern" EXCLUSIVE-INTERPRETATION 0 0))
                                        (leaf (token "*clefG2" CLEF 1 0))
                                        (leaf (token "*k[]" KEY-SIG 2 0))
                                        (leaf (token "*a:" KEY-LABEL 3 0))
                                        (leaf (token "*M3/4" TIME-SIG 4 0))
                                        (parent (token "*^" SPINE-SPLIT 5 0)
                                                (list (leaf (token "*" NULL-INTERPRETATION 6 0))
                                                      (leaf (token "4c" SPINE-DATA 7 0))
                                                      (leaf (token "4c" SPINE-DATA 8 0))
                                                      (leaf (token "4c" SPINE-DATA 9 0))
                                                      (leaf (token "=2" MEASURE 10 0))
                                                      (leaf (token "4c" SPINE-DATA 11 0))
                                                      (leaf (token "4c" SPINE-DATA 12 0))
                                                      (leaf (token "4c" SPINE-DATA 13 0))
                                                      (leaf (token "=3" MEASURE 14 0))
                                                      (leaf (token "4c" SPINE-DATA 15 0))
                                                      (leaf (token "4c" SPINE-DATA 16 0))
                                                      (leaf (token "4c" SPINE-DATA 17 0))
                                                      (leaf (token "*" NULL-INTERPRETATION 18 0))
                                                      (leaf (token "*v" SPINE-JOIN 19 0)))
                                                (list (parent (token "*^" SPINE-SPLIT 6 1)
                                                              (list (leaf (token "4c" SPINE-DATA 7 1))
                                                                    (leaf (token "4c" SPINE-DATA 8 1))
                                                                    (leaf (token "4c" SPINE-DATA 9 1))
                                                                    (leaf (token "=2" MEASURE 10 1))
                                                                    (leaf (token "4c" SPINE-DATA 11 1))
                                                                    (leaf (token "4c" SPINE-DATA 12 1))
                                                                    (leaf (token "4c" SPINE-DATA 13 1))
                                                                    (leaf (token "=3" MEASURE 14 1))
                                                                    (leaf (token "4c" SPINE-DATA 15 1))
                                                                    (leaf (token "4c" SPINE-DATA 16 1))
                                                                    (leaf (token "4c" SPINE-DATA 17 1))
                                                                    (leaf (token "*v" SPINE-JOIN 18 1)))
                                                              (list (leaf (token "4c" SPINE-DATA 7 2))
                                                                    (leaf (token "4c" SPINE-DATA 8 2))
                                                                    (leaf (token "4c" SPINE-DATA 9 2))
                                                                    (leaf (token "=2" MEASURE 10 2))
                                                                    (leaf (token "4c" SPINE-DATA 11 2))
                                                                    (leaf (token "4c" SPINE-DATA 12 2))
                                                                    (leaf (token "4c" SPINE-DATA 13 2))
                                                                    (leaf (token "=3" MEASURE 14 2))
                                                                    (leaf (token "4c" SPINE-DATA 15 2))
                                                                    (leaf (token "4c" SPINE-DATA 16 2))
                                                                    (leaf (token "4c" SPINE-DATA 17 2))
                                                                    (leaf (token "*v" SPINE-JOIN 18 2))))
                                                      (leaf (token "*v" SPINE-JOIN 19 1))))
                                        (leaf (token "==" MEASURE 20 0))
                                        (leaf (token "*-" SPINE-TERMINATOR 21 0)))))))
(check-expect (branch->lot (list (leaf (token "**kern" EXCLUSIVE-INTERPRETATION 0 0))
                                 (leaf (token "*clefG2" CLEF 1 0))
                                 (leaf (token "*k[]" KEY-SIG 2 0))
                                 (leaf (token "*a:" KEY-LABEL 3 0))
                                 (leaf (token "*M3/4" TIME-SIG 4 0))
                                 (parent (token "*^" SPINE-SPLIT 5 0)
                                         (list (leaf (token "*" NULL-INTERPRETATION 6 0))
                                               (leaf (token "4c" SPINE-DATA 7 0))
                                               (leaf (token "4c" SPINE-DATA 8 0))
                                               (leaf (token "4c" SPINE-DATA 9 0))
                                               (leaf (token "=2" MEASURE 10 0))
                                               (leaf (token "4c" SPINE-DATA 11 0))
                                               (leaf (token "4c" SPINE-DATA 12 0))
                                               (leaf (token "4c" SPINE-DATA 13 0))
                                               (leaf (token "=3" MEASURE 14 0))
                                               (leaf (token "4c" SPINE-DATA 15 0))
                                               (leaf (token "4c" SPINE-DATA 16 0))
                                               (leaf (token "4c" SPINE-DATA 17 0))
                                               (leaf (token "*" NULL-INTERPRETATION 18 0))
                                               (leaf (token "*v" SPINE-JOIN 19 0)))
                                         (list (parent (token "*^" SPINE-SPLIT 6 1)
                                                       (list (leaf (token "4c" SPINE-DATA 7 1))
                                                             (leaf (token "4c" SPINE-DATA 8 1))
                                                             (leaf (token "4c" SPINE-DATA 9 1))
                                                             (leaf (token "=2" MEASURE 10 1))
                                                             (leaf (token "4c" SPINE-DATA 11 1))
                                                             (leaf (token "4c" SPINE-DATA 12 1))
                                                             (leaf (token "4c" SPINE-DATA 13 1))
                                                             (leaf (token "=3" MEASURE 14 1))
                                                             (leaf (token "4c" SPINE-DATA 15 1))
                                                             (leaf (token "4c" SPINE-DATA 16 1))
                                                             (leaf (token "4c" SPINE-DATA 17 1))
                                                             (leaf (token "*v" SPINE-JOIN 18 1)))
                                                       (list (leaf (token "4c" SPINE-DATA 7 2))
                                                             (leaf (token "4c" SPINE-DATA 8 2))
                                                             (leaf (token "4c" SPINE-DATA 9 2))
                                                             (leaf (token "=2" MEASURE 10 2))
                                                             (leaf (token "4c" SPINE-DATA 11 2))
                                                             (leaf (token "4c" SPINE-DATA 12 2))
                                                             (leaf (token "4c" SPINE-DATA 13 2))
                                                             (leaf (token "=3" MEASURE 14 2))
                                                             (leaf (token "4c" SPINE-DATA 15 2))
                                                             (leaf (token "4c" SPINE-DATA 16 2))
                                                             (leaf (token "4c" SPINE-DATA 17 2))
                                                             (leaf (token "*v" SPINE-JOIN 18 2))))
                                               (leaf (token "*v" SPINE-JOIN 19 1))))
                                 (leaf (token "==" MEASURE 20 0))
                                 (leaf (token "*-" SPINE-TERMINATOR 21 0))))
              (list (token "**kern" EXCLUSIVE-INTERPRETATION 0 0)
                    (token "*clefG2" CLEF 1 0)
                    (token "*k[]" KEY-SIG 2 0)
                    (token "*a:" KEY-LABEL 3 0)
                    (token "*M3/4" TIME-SIG 4 0)
                    (token "*^" SPINE-SPLIT 5 0)
                    (token "*" NULL-INTERPRETATION 6 0)
                    (token "4c" SPINE-DATA 7 0)
                    (token "4c" SPINE-DATA 8 0)
                    (token "4c" SPINE-DATA 9 0)
                    (token "=2" MEASURE 10 0)
                    (token "4c" SPINE-DATA 11 0)
                    (token "4c" SPINE-DATA 12 0)
                    (token "4c" SPINE-DATA 13 0)
                    (token "=3" MEASURE 14 0)
                    (token "4c" SPINE-DATA 15 0)
                    (token "4c" SPINE-DATA 16 0)
                    (token "4c" SPINE-DATA 17 0)
                    (token "*" NULL-INTERPRETATION 18 0)
                    (token "*v" SPINE-JOIN 19 0)
                    (token "*^" SPINE-SPLIT 6 1)
                    (token "4c" SPINE-DATA 7 1)
                    (token "4c" SPINE-DATA 8 1)
                    (token "4c" SPINE-DATA 9 1)
                    (token "=2" MEASURE 10 1)
                    (token "4c" SPINE-DATA 11 1)
                    (token "4c" SPINE-DATA 12 1)
                    (token "4c" SPINE-DATA 13 1)
                    (token "=3" MEASURE 14 1)
                    (token "4c" SPINE-DATA 15 1)
                    (token "4c" SPINE-DATA 16 1)
                    (token "4c" SPINE-DATA 17 1)
                    (token "*v" SPINE-JOIN 18 1)
                    (token "4c" SPINE-DATA 7 2)
                    (token "4c" SPINE-DATA 8 2)
                    (token "4c" SPINE-DATA 9 2)
                    (token "=2" MEASURE 10 2)
                    (token "4c" SPINE-DATA 11 2)
                    (token "4c" SPINE-DATA 12 2)
                    (token "4c" SPINE-DATA 13 2)
                    (token "=3" MEASURE 14 2)
                    (token "4c" SPINE-DATA 15 2)
                    (token "4c" SPINE-DATA 16 2)
                    (token "4c" SPINE-DATA 17 2)
                    (token "*v" SPINE-JOIN 18 2)
                    (token "*v" SPINE-JOIN 19 1)
                    (token "==" MEASURE 20 0)
                    (token "*-" SPINE-TERMINATOR 21 0)))

(test)
