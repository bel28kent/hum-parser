#lang racket/base

(require "../../../../parser/data-definitions/data-definitions.rkt"
         "../../../../parser/functions/file.rkt"
         "../../../../parser/functions/spine-parser.rkt"
         "../../../../data-structures/abstract-humdrum-graph/data-definitions/data-definitions.rkt"
         "../../../../data-structures/abstract-humdrum-graph/functions/ab-hgraph-to-hfile.rkt"
         "../../../../data-structures/abstract-humdrum-graph/functions/hfile-to-ab-hgraph.rkt"
         test-engine/racket-tests)

(check-expect (path->hfile "../../data/count/one-spine-two-splits.krn")
              (hfile (list (record "**kern"
                                   TOKEN
                                   (list (token "**kern" EXCLUSIVE-INTERPRETATION 0))
                                   0)
                           (record "*clefG2" TOKEN (list (token "*clefG2" CLEF 1)) 1)
                           (record "*k[]" TOKEN (list (token "*k[]" KEY-SIG 2)) 2)
                           (record "*a:" TOKEN (list (token "*a:" KEY-LABEL 3)) 3)
                           (record "*M3/4" TOKEN (list (token "*M3/4" TIME-SIG 4)) 4)
                           (record "*^" TOKEN (list (token "*^" SPINE-SPLIT 5)) 5)
                           (record "*\t*^"
                                   TOKEN
                                   (list (token "*" NULL-INTERPRETATION 6)
                                         (token "*^" SPINE-SPLIT 6))
                                   6)
                           (record "4c\t4c\t4c"
                                   TOKEN
                                   (list (token "4c" SPINE-DATA 7)
                                         (token "4c" SPINE-DATA 7)
                                         (token "4c" SPINE-DATA 7))
                                   7)
                           (record "4c\t4c\t4c"
                                   TOKEN
                                   (list (token "4c" SPINE-DATA 8)
                                         (token "4c" SPINE-DATA 8)
                                         (token "4c" SPINE-DATA 8))
                                   8)
                           (record "4c\t4c\t4c"
                                   TOKEN
                                   (list (token "4c" SPINE-DATA 9)
                                         (token "4c" SPINE-DATA 9)
                                         (token "4c" SPINE-DATA 9))
                                   9)
                           (record "=2\t=2\t=2"
                                   TOKEN
                                   (list (token "=2" MEASURE 10)
                                         (token "=2" MEASURE 10)
                                         (token "=2" MEASURE 10))
                                   10)
                           (record "4c\t4c\t4c"
                                   TOKEN
                                   (list (token "4c" SPINE-DATA 11)
                                         (token "4c" SPINE-DATA 11)
                                         (token "4c" SPINE-DATA 11))
                                   11)
                           (record "4c\t4c\t4c"
                                   TOKEN
                                   (list (token "4c" SPINE-DATA 12)
                                         (token "4c" SPINE-DATA 12)
                                         (token "4c" SPINE-DATA 12))
                                   12)
                           (record "4c\t4c\t4c"
                                   TOKEN
                                   (list (token "4c" SPINE-DATA 13)
                                         (token "4c" SPINE-DATA 13)
                                         (token "4c" SPINE-DATA 13))
                                   13)
                           (record "=3\t=3\t=3"
                                   TOKEN
                                   (list (token "=3" MEASURE 14)
                                         (token "=3" MEASURE 14)
                                         (token "=3" MEASURE 14))
                                   14)
                           (record "4c\t4c\t4c"
                                   TOKEN
                                   (list (token "4c" SPINE-DATA 15)
                                         (token "4c" SPINE-DATA 15)
                                         (token "4c" SPINE-DATA 15))
                                   15)
                           (record "4c\t4c\t4c"
                                   TOKEN
                                   (list (token "4c" SPINE-DATA 16)
                                         (token "4c" SPINE-DATA 16)
                                         (token "4c" SPINE-DATA 16))
                                   16)
                           (record "4c\t4c\t4c"
                                   TOKEN
                                   (list (token "4c" SPINE-DATA 17)
                                         (token "4c" SPINE-DATA 17)
                                         (token "4c" SPINE-DATA 17))
                                   17)
                           (record "*\t*v\t*v"
                                   TOKEN
                                   (list (token "*" NULL-INTERPRETATION 18)
                                         (token "*v" SPINE-JOIN 18)
                                         (token "*v" SPINE-JOIN 18))
                                   18)
                           (record "*v\t*v"
                                   TOKEN
                                   (list (token "*v" SPINE-JOIN 19)
                                         (token "*v" SPINE-JOIN 19))
                                   19)
                           (record "==" TOKEN (list (token "==" MEASURE 20)) 20)
                           (record "*-" TOKEN (list (token "*-" SPINE-TERMINATOR 21)) 21))))
(check-expect (spine-parser (hfile (list (record "**kern"
                                                 TOKEN
                                                 (list (token "**kern" EXCLUSIVE-INTERPRETATION 0))
                                                 0)
                                         (record "*clefG2" TOKEN (list (token "*clefG2" CLEF 1)) 1)
                                         (record "*k[]" TOKEN (list (token "*k[]" KEY-SIG 2)) 2)
                                         (record "*a:" TOKEN (list (token "*a:" KEY-LABEL 3)) 3)
                                         (record "*M3/4" TOKEN (list (token "*M3/4" TIME-SIG 4)) 4)
                                         (record "*^" TOKEN (list (token "*^" SPINE-SPLIT 5)) 5)
                                         (record "*\t*^"
                                                 TOKEN
                                                 (list (token "*" NULL-INTERPRETATION 6)
                                                       (token "*^" SPINE-SPLIT 6))
                                                 6)
                                         (record "4c\t4c\t4c"
                                                 TOKEN
                                                 (list (token "4c" SPINE-DATA 7)
                                                       (token "4c" SPINE-DATA 7)
                                                       (token "4c" SPINE-DATA 7))
                                                 7)
                                         (record "4c\t4c\t4c"
                                                 TOKEN
                                                 (list (token "4c" SPINE-DATA 8)
                                                       (token "4c" SPINE-DATA 8)
                                                       (token "4c" SPINE-DATA 8))
                                                 8)
                                         (record "4c\t4c\t4c"
                                                 TOKEN
                                                 (list (token "4c" SPINE-DATA 9)
                                                       (token "4c" SPINE-DATA 9)
                                                       (token "4c" SPINE-DATA 9))
                                                 9)
                                         (record "=2\t=2\t=2"
                                                 TOKEN
                                                 (list (token "=2" MEASURE 10)
                                                       (token "=2" MEASURE 10)
                                                       (token "=2" MEASURE 10))
                                                 10)
                                         (record "4c\t4c\t4c"
                                                 TOKEN
                                                 (list (token "4c" SPINE-DATA 11)
                                                       (token "4c" SPINE-DATA 11)
                                                       (token "4c" SPINE-DATA 11))
                                                 11)
                                         (record "4c\t4c\t4c"
                                                 TOKEN
                                                 (list (token "4c" SPINE-DATA 12)
                                                       (token "4c" SPINE-DATA 12)
                                                       (token "4c" SPINE-DATA 12))
                                                 12)
                                         (record "4c\t4c\t4c"
                                                 TOKEN
                                                 (list (token "4c" SPINE-DATA 13)
                                                       (token "4c" SPINE-DATA 13)
                                                       (token "4c" SPINE-DATA 13))
                                                 13)
                                         (record "=3\t=3\t=3"
                                                 TOKEN
                                                 (list (token "=3" MEASURE 14)
                                                       (token "=3" MEASURE 14)
                                                       (token "=3" MEASURE 14))
                                                 14)
                                         (record "4c\t4c\t4c"
                                                 TOKEN
                                                 (list (token "4c" SPINE-DATA 15)
                                                       (token "4c" SPINE-DATA 15)
                                                       (token "4c" SPINE-DATA 15))
                                                 15)
                                         (record "4c\t4c\t4c"
                                                 TOKEN
                                                 (list (token "4c" SPINE-DATA 16)
                                                       (token "4c" SPINE-DATA 16)
                                                       (token "4c" SPINE-DATA 16))
                                                 16)
                                         (record "4c\t4c\t4c"
                                                 TOKEN
                                                 (list (token "4c" SPINE-DATA 17)
                                                       (token "4c" SPINE-DATA 17)
                                                       (token "4c" SPINE-DATA 17))
                                                 17)
                                         (record "*\t*v\t*v"
                                                 TOKEN
                                                 (list (token "*" NULL-INTERPRETATION 18)
                                                       (token "*v" SPINE-JOIN 18)
                                                       (token "*v" SPINE-JOIN 18))
                                                 18)
                                         (record "*v\t*v"
                                                 TOKEN
                                                 (list (token "*v" SPINE-JOIN 19)
                                                       (token "*v" SPINE-JOIN 19))
                                                 19)
                                         (record "==" TOKEN (list (token "==" MEASURE 20)) 20)
                                         (record "*-"
                                                 TOKEN
                                                 (list (token "*-" SPINE-TERMINATOR 21))
                                                 21))))
              (list (global-spine KERN
                                  (list (list (token "**kern" EXCLUSIVE-INTERPRETATION 0))
                                        (list (token "*clefG2" CLEF 1))
                                        (list (token "*k[]" KEY-SIG 2))
                                        (list (token "*a:" KEY-LABEL 3))
                                        (list (token "*M3/4" TIME-SIG 4))
                                        (list (token "*^" SPINE-SPLIT 5))
                                        (list (token "*" NULL-INTERPRETATION 6)
                                              (token "*^" SPINE-SPLIT 6))
                                        (list (token "4c" SPINE-DATA 7)
                                              (token "4c" SPINE-DATA 7)
                                              (token "4c" SPINE-DATA 7))
                                        (list (token "4c" SPINE-DATA 8)
                                              (token "4c" SPINE-DATA 8)
                                              (token "4c" SPINE-DATA 8))
                                        (list (token "4c" SPINE-DATA 9)
                                              (token "4c" SPINE-DATA 9)
                                              (token "4c" SPINE-DATA 9))
                                        (list (token "=2" MEASURE 10)
                                              (token "=2" MEASURE 10)
                                              (token "=2" MEASURE 10))
                                        (list (token "4c" SPINE-DATA 11)
                                              (token "4c" SPINE-DATA 11)
                                              (token "4c" SPINE-DATA 11))
                                        (list (token "4c" SPINE-DATA 12)
                                              (token "4c" SPINE-DATA 12)
                                              (token "4c" SPINE-DATA 12))
                                        (list (token "4c" SPINE-DATA 13)
                                              (token "4c" SPINE-DATA 13)
                                              (token "4c" SPINE-DATA 13))
                                        (list (token "=3" MEASURE 14)
                                              (token "=3" MEASURE 14)
                                              (token "=3" MEASURE 14))
                                        (list (token "4c" SPINE-DATA 15)
                                              (token "4c" SPINE-DATA 15)
                                              (token "4c" SPINE-DATA 15))
                                        (list (token "4c" SPINE-DATA 16)
                                              (token "4c" SPINE-DATA 16)
                                              (token "4c" SPINE-DATA 16))
                                        (list (token "4c" SPINE-DATA 17)
                                              (token "4c" SPINE-DATA 17)
                                              (token "4c" SPINE-DATA 17))
                                        (list (token "*" NULL-INTERPRETATION 18)
                                              (token "*v" SPINE-JOIN 18)
                                              (token "*v" SPINE-JOIN 18))
                                        (list (token "*v" SPINE-JOIN 19)
                                              (token "*v" SPINE-JOIN 19))
                                        (list (token "==" MEASURE 20))
                                        (list (token "*-" SPINE-TERMINATOR 21)))
                                  0)))
(check-expect (ab-hgraph->hfile
              (ab-hgraph (root (list (list (leaf (token "**kern" EXCLUSIVE-INTERPRETATION 0))
                                           (leaf (token "*clefG2" CLEF 1))
                                           (leaf (token "*k[]" KEY-SIG 2))
                                           (leaf (token "*a:" KEY-LABEL 3))
                                           (leaf (token "*M3/4" TIME-SIG 4))
                                           (parent (token "*^" SPINE-SPLIT 5)
                                                   (list (leaf (token "*" NULL-INTERPRETATION 6))
                                                         (leaf (token "4c" SPINE-DATA 7))
                                                         (leaf (token "4c" SPINE-DATA 8))
                                                         (leaf (token "4c" SPINE-DATA 9))
                                                         (leaf (token "=2" MEASURE 10))
                                                         (leaf (token "4c" SPINE-DATA 11))
                                                         (leaf (token "4c" SPINE-DATA 12))
                                                         (leaf (token "4c" SPINE-DATA 13))
                                                         (leaf (token "=3" MEASURE 14))
                                                         (leaf (token "4c" SPINE-DATA 15))
                                                         (leaf (token "4c" SPINE-DATA 16))
                                                         (leaf (token "4c" SPINE-DATA 17))
                                                         (leaf (token "*" NULL-INTERPRETATION 18))
                                                         (leaf (token "*v" SPINE-JOIN 19)))
                                                   (list (parent (token "*^" SPINE-SPLIT 6)
                                                                 (list (leaf (token "4c" SPINE-DATA 7))
                                                                       (leaf (token "4c" SPINE-DATA 8))
                                                                       (leaf (token "4c" SPINE-DATA 9))
                                                                       (leaf (token "=2" MEASURE 10))
                                                                       (leaf (token "4c" SPINE-DATA 11))
                                                                       (leaf (token "4c" SPINE-DATA 12))
                                                                       (leaf (token "4c" SPINE-DATA 13))
                                                                       (leaf (token "=3" MEASURE 14))
                                                                       (leaf (token "4c" SPINE-DATA 15))
                                                                       (leaf (token "4c" SPINE-DATA 16))
                                                                       (leaf (token "4c" SPINE-DATA 17))
                                                                       (leaf (token "*v" SPINE-JOIN 18)))
                                                                 (list (leaf (token "4c" SPINE-DATA 7))
                                                                       (leaf (token "4c" SPINE-DATA 8))
                                                                       (leaf (token "4c" SPINE-DATA 9))
                                                                       (leaf (token "=2" MEASURE 10))
                                                                       (leaf (token "4c" SPINE-DATA 11))
                                                                       (leaf (token "4c" SPINE-DATA 12))
                                                                       (leaf (token "4c" SPINE-DATA 13))
                                                                       (leaf (token "=3" MEASURE 14))
                                                                       (leaf (token "4c" SPINE-DATA 15))
                                                                       (leaf (token "4c" SPINE-DATA 16))
                                                                       (leaf (token "4c" SPINE-DATA 17))
                                                                       (leaf (token "*v" SPINE-JOIN 18))))
                                                         (leaf (token "*v" SPINE-JOIN 19))))
                                           (leaf (token "==" MEASURE 20))
                                           (leaf (token "*-" SPINE-TERMINATOR 21)))))))
              (hfile (list (record "**kern"
                                   TOKEN
                                   (list (token "**kern" EXCLUSIVE-INTERPRETATION 0))
                                   0)
                           (record "*clefG2" TOKEN (list (token "*clefG2" CLEF 1)) 1)
                           (record "*k[]" TOKEN (list (token "*k[]" KEY-SIG 2)) 2)
                           (record "*a:" TOKEN (list (token "*a:" KEY-LABEL 3)) 3)
                           (record "*M3/4" TOKEN (list (token "*M3/4" TIME-SIG 4)) 4)
                           (record "*^" TOKEN (list (token "*^" SPINE-SPLIT 5)) 5)
                           (record "*\t*^"
                                   TOKEN
                                   (list (token "*" NULL-INTERPRETATION 6)
                                         (token "*^" SPINE-SPLIT 6))
                                   6)
                           (record "4c\t4c\t4c"
                                   TOKEN
                                   (list (token "4c" SPINE-DATA 7)
                                         (token "4c" SPINE-DATA 7)
                                         (token "4c" SPINE-DATA 7))
                                   7)
                           (record "4c\t4c\t4c"
                                   TOKEN
                                   (list (token "4c" SPINE-DATA 8)
                                         (token "4c" SPINE-DATA 8)
                                         (token "4c" SPINE-DATA 8))
                                   8)
                           (record "4c\t4c\t4c"
                                   TOKEN
                                   (list (token "4c" SPINE-DATA 9)
                                         (token "4c" SPINE-DATA 9)
                                         (token "4c" SPINE-DATA 9))
                                   9)
                           (record "=2\t=2\t=2"
                                   TOKEN
                                   (list (token "=2" MEASURE 10)
                                         (token "=2" MEASURE 10)
                                         (token "=2" MEASURE 10))
                                   10)
                           (record "4c\t4c\t4c"
                                   TOKEN
                                   (list (token "4c" SPINE-DATA 11)
                                         (token "4c" SPINE-DATA 11)
                                         (token "4c" SPINE-DATA 11))
                                   11)
                           (record "4c\t4c\t4c"
                                   TOKEN
                                   (list (token "4c" SPINE-DATA 12)
                                         (token "4c" SPINE-DATA 12)
                                         (token "4c" SPINE-DATA 12))
                                   12)
                           (record "4c\t4c\t4c"
                                   TOKEN
                                   (list (token "4c" SPINE-DATA 13)
                                         (token "4c" SPINE-DATA 13)
                                         (token "4c" SPINE-DATA 13))
                                   13)
                           (record "=3\t=3\t=3"
                                   TOKEN
                                   (list (token "=3" MEASURE 14)
                                         (token "=3" MEASURE 14)
                                         (token "=3" MEASURE 14))
                                   14)
                           (record "4c\t4c\t4c"
                                   TOKEN
                                   (list (token "4c" SPINE-DATA 15)
                                         (token "4c" SPINE-DATA 15)
                                         (token "4c" SPINE-DATA 15))
                                   15)
                           (record "4c\t4c\t4c"
                                   TOKEN
                                   (list (token "4c" SPINE-DATA 16)
                                         (token "4c" SPINE-DATA 16)
                                         (token "4c" SPINE-DATA 16))
                                   16)
                           (record "4c\t4c\t4c"
                                   TOKEN
                                   (list (token "4c" SPINE-DATA 17)
                                         (token "4c" SPINE-DATA 17)
                                         (token "4c" SPINE-DATA 17))
                                   17)
                           (record "*\t*v\t*v"
                                   TOKEN
                                   (list (token "*" NULL-INTERPRETATION 18)
                                         (token "*v" SPINE-JOIN 18)
                                         (token "*v" SPINE-JOIN 18))
                                   18)
                           (record "*v\t*v"
                                   TOKEN
                                   (list (token "*v" SPINE-JOIN 19)
                                         (token "*v" SPINE-JOIN 19))
                                   19)
                           (record "==" TOKEN (list (token "==" MEASURE 20)) 20)
                           (record "*-" TOKEN (list (token "*-" SPINE-TERMINATOR 21)) 21))))
(check-expect (lolot->lor
              (list (list (token "**kern" EXCLUSIVE-INTERPRETATION 0))
                    (list (token "*clefG2" CLEF 1))
                    (list (token "*k[]" KEY-SIG 2))
                    (list (token "*a:" KEY-LABEL 3))
                    (list (token "*M3/4" TIME-SIG 4))
                    (list (token "*^" SPINE-SPLIT 5))
                    (list (token "*" NULL-INTERPRETATION 6) (token "*^" SPINE-SPLIT 6))
                    (list (token "4c" SPINE-DATA 7)
                          (token "4c" SPINE-DATA 7)
                          (token "4c" SPINE-DATA 7))
                    (list (token "4c" SPINE-DATA 8)
                          (token "4c" SPINE-DATA 8)
                          (token "4c" SPINE-DATA 8))
                    (list (token "4c" SPINE-DATA 9)
                          (token "4c" SPINE-DATA 9)
                          (token "4c" SPINE-DATA 9))
                    (list (token "=2" MEASURE 10) (token "=2" MEASURE 10) (token "=2" MEASURE 10))
                    (list (token "4c" SPINE-DATA 11)
                          (token "4c" SPINE-DATA 11)
                          (token "4c" SPINE-DATA 11))
                    (list (token "4c" SPINE-DATA 12)
                          (token "4c" SPINE-DATA 12)
                          (token "4c" SPINE-DATA 12))
                    (list (token "4c" SPINE-DATA 13)
                          (token "4c" SPINE-DATA 13)
                          (token "4c" SPINE-DATA 13))
                    (list (token "=3" MEASURE 14) (token "=3" MEASURE 14) (token "=3" MEASURE 14))
                    (list (token "4c" SPINE-DATA 15)
                          (token "4c" SPINE-DATA 15)
                          (token "4c" SPINE-DATA 15))
                    (list (token "4c" SPINE-DATA 16)
                          (token "4c" SPINE-DATA 16)
                          (token "4c" SPINE-DATA 16))
                    (list (token "4c" SPINE-DATA 17)
                          (token "4c" SPINE-DATA 17)
                          (token "4c" SPINE-DATA 17))
                    (list (token "*" NULL-INTERPRETATION 18)
                          (token "*v" SPINE-JOIN 18)
                          (token "*v" SPINE-JOIN 18))
                    (list (token "*v" SPINE-JOIN 19) (token "*v" SPINE-JOIN 19))
                    (list (token "==" MEASURE 20))
                    (list (token "*-" SPINE-TERMINATOR 21))))
              (list (record "**kern"
                            TOKEN
                            (list (token "**kern" EXCLUSIVE-INTERPRETATION 0))
                            0)
                    (record "*clefG2" TOKEN (list (token "*clefG2" CLEF 1)) 1)
                    (record "*k[]" TOKEN (list (token "*k[]" KEY-SIG 2)) 2)
                    (record "*a:" TOKEN (list (token "*a:" KEY-LABEL 3)) 3)
                    (record "*M3/4" TOKEN (list (token "*M3/4" TIME-SIG 4)) 4)
                    (record "*^" TOKEN (list (token "*^" SPINE-SPLIT 5)) 5)
                    (record "*\t*^"
                            TOKEN
                            (list (token "*" NULL-INTERPRETATION 6)
                                  (token "*^" SPINE-SPLIT 6))
                            6)
                    (record "4c\t4c\t4c"
                            TOKEN
                            (list (token "4c" SPINE-DATA 7)
                                  (token "4c" SPINE-DATA 7)
                                  (token "4c" SPINE-DATA 7))
                            7)
                    (record "4c\t4c\t4c"
                            TOKEN
                            (list (token "4c" SPINE-DATA 8)
                                  (token "4c" SPINE-DATA 8)
                                  (token "4c" SPINE-DATA 8))
                            8)
                    (record "4c\t4c\t4c"
                            TOKEN
                            (list (token "4c" SPINE-DATA 9)
                                  (token "4c" SPINE-DATA 9)
                                  (token "4c" SPINE-DATA 9))
                            9)
                    (record "=2\t=2\t=2"
                            TOKEN
                            (list (token "=2" MEASURE 10)
                                  (token "=2" MEASURE 10)
                                  (token "=2" MEASURE 10))
                            10)
                    (record "4c\t4c\t4c"
                            TOKEN
                            (list (token "4c" SPINE-DATA 11)
                                  (token "4c" SPINE-DATA 11)
                                  (token "4c" SPINE-DATA 11))
                            11)
                    (record "4c\t4c\t4c"
                            TOKEN
                            (list (token "4c" SPINE-DATA 12)
                                  (token "4c" SPINE-DATA 12)
                                  (token "4c" SPINE-DATA 12))
                            12)
                    (record "4c\t4c\t4c"
                            TOKEN
                            (list (token "4c" SPINE-DATA 13)
                                  (token "4c" SPINE-DATA 13)
                                  (token "4c" SPINE-DATA 13))
                            13)
                    (record "=3\t=3\t=3"
                            TOKEN
                            (list (token "=3" MEASURE 14)
                                  (token "=3" MEASURE 14)
                                  (token "=3" MEASURE 14))
                            14)
                    (record "4c\t4c\t4c"
                            TOKEN
                            (list (token "4c" SPINE-DATA 15)
                                  (token "4c" SPINE-DATA 15)
                                  (token "4c" SPINE-DATA 15))
                            15)
                    (record "4c\t4c\t4c"
                            TOKEN
                            (list (token "4c" SPINE-DATA 16)
                                  (token "4c" SPINE-DATA 16)
                                  (token "4c" SPINE-DATA 16))
                            16)
                    (record "4c\t4c\t4c"
                            TOKEN
                            (list (token "4c" SPINE-DATA 17)
                                  (token "4c" SPINE-DATA 17)
                                  (token "4c" SPINE-DATA 17))
                            17)
                    (record "*\t*v\t*v"
                            TOKEN
                            (list (token "*" NULL-INTERPRETATION 18)
                                  (token "*v" SPINE-JOIN 18)
                                  (token "*v" SPINE-JOIN 18))
                            18)
                    (record "*v\t*v"
                            TOKEN
                            (list (token "*v" SPINE-JOIN 19)
                                  (token "*v" SPINE-JOIN 19))
                            19)
                    (record "==" TOKEN (list (token "==" MEASURE 20)) 20)
                    (record "*-" TOKEN (list (token "*-" SPINE-TERMINATOR 21)) 21)))
(check-expect (ab-hgraph->lolot
              (ab-hgraph (root (list (list (leaf (token "**kern" EXCLUSIVE-INTERPRETATION 0))
                                           (leaf (token "*clefG2" CLEF 1))
                                           (leaf (token "*k[]" KEY-SIG 2))
                                           (leaf (token "*a:" KEY-LABEL 3))
                                           (leaf (token "*M3/4" TIME-SIG 4))
                                           (parent (token "*^" SPINE-SPLIT 5)
                                                   (list (leaf (token "*" NULL-INTERPRETATION 6))
                                                         (leaf (token "4c" SPINE-DATA 7))
                                                         (leaf (token "4c" SPINE-DATA 8))
                                                         (leaf (token "4c" SPINE-DATA 9))
                                                         (leaf (token "=2" MEASURE 10))
                                                         (leaf (token "4c" SPINE-DATA 11))
                                                         (leaf (token "4c" SPINE-DATA 12))
                                                         (leaf (token "4c" SPINE-DATA 13))
                                                         (leaf (token "=3" MEASURE 14))
                                                         (leaf (token "4c" SPINE-DATA 15))
                                                         (leaf (token "4c" SPINE-DATA 16))
                                                         (leaf (token "4c" SPINE-DATA 17))
                                                         (leaf (token "*" NULL-INTERPRETATION 18))
                                                         (leaf (token "*v" SPINE-JOIN 19)))
                                                   (list (parent (token "*^" SPINE-SPLIT 6)
                                                                 (list (leaf (token "4c" SPINE-DATA 7))
                                                                       (leaf (token "4c" SPINE-DATA 8))
                                                                       (leaf (token "4c" SPINE-DATA 9))
                                                                       (leaf (token "=2" MEASURE 10))
                                                                       (leaf (token "4c" SPINE-DATA 11))
                                                                       (leaf (token "4c" SPINE-DATA 12))
                                                                       (leaf (token "4c" SPINE-DATA 13))
                                                                       (leaf (token "=3" MEASURE 14))
                                                                       (leaf (token "4c" SPINE-DATA 15))
                                                                       (leaf (token "4c" SPINE-DATA 16))
                                                                       (leaf (token "4c" SPINE-DATA 17))
                                                                       (leaf (token "*v" SPINE-JOIN 18)))
                                                                 (list (leaf (token "4c" SPINE-DATA 7))
                                                                       (leaf (token "4c" SPINE-DATA 8))
                                                                       (leaf (token "4c" SPINE-DATA 9))
                                                                       (leaf (token "=2" MEASURE 10))
                                                                       (leaf (token "4c" SPINE-DATA 11))
                                                                       (leaf (token "4c" SPINE-DATA 12))
                                                                       (leaf (token "4c" SPINE-DATA 13))
                                                                       (leaf (token "=3" MEASURE 14))
                                                                       (leaf (token "4c" SPINE-DATA 15))
                                                                       (leaf (token "4c" SPINE-DATA 16))
                                                                       (leaf (token "4c" SPINE-DATA 17))
                                                                       (leaf (token "*v" SPINE-JOIN 18))))
                                                         (leaf (token "*v" SPINE-JOIN 19))))
                                           (leaf (token "==" MEASURE 20))
                                           (leaf (token "*-" SPINE-TERMINATOR 21)))))))
              (list (list (token "**kern" EXCLUSIVE-INTERPRETATION 0))
                    (list (token "*clefG2" CLEF 1))
                    (list (token "*k[]" KEY-SIG 2))
                    (list (token "*a:" KEY-LABEL 3))
                    (list (token "*M3/4" TIME-SIG 4))
                    (list (token "*^" SPINE-SPLIT 5))
                    (list (token "*" NULL-INTERPRETATION 6) (token "*^" SPINE-SPLIT 6))
                    (list (token "4c" SPINE-DATA 7)
                          (token "4c" SPINE-DATA 7)
                          (token "4c" SPINE-DATA 7))
                    (list (token "4c" SPINE-DATA 8)
                          (token "4c" SPINE-DATA 8)
                          (token "4c" SPINE-DATA 8))
                    (list (token "4c" SPINE-DATA 9)
                          (token "4c" SPINE-DATA 9)
                          (token "4c" SPINE-DATA 9))
                    (list (token "=2" MEASURE 10) (token "=2" MEASURE 10) (token "=2" MEASURE 10))
                    (list (token "4c" SPINE-DATA 11)
                          (token "4c" SPINE-DATA 11)
                          (token "4c" SPINE-DATA 11))
                    (list (token "4c" SPINE-DATA 12)
                          (token "4c" SPINE-DATA 12)
                          (token "4c" SPINE-DATA 12))
                    (list (token "4c" SPINE-DATA 13)
                          (token "4c" SPINE-DATA 13)
                          (token "4c" SPINE-DATA 13))
                    (list (token "=3" MEASURE 14) (token "=3" MEASURE 14) (token "=3" MEASURE 14))
                    (list (token "4c" SPINE-DATA 15)
                          (token "4c" SPINE-DATA 15)
                          (token "4c" SPINE-DATA 15))
                    (list (token "4c" SPINE-DATA 16)
                          (token "4c" SPINE-DATA 16)
                          (token "4c" SPINE-DATA 16))
                    (list (token "4c" SPINE-DATA 17)
                          (token "4c" SPINE-DATA 17)
                          (token "4c" SPINE-DATA 17))
                    (list (token "*" NULL-INTERPRETATION 18)
                          (token "*v" SPINE-JOIN 18)
                          (token "*v" SPINE-JOIN 18))
                    (list (token "*v" SPINE-JOIN 19) (token "*v" SPINE-JOIN 19))
                    (list (token "==" MEASURE 20))
                    (list (token "*-" SPINE-TERMINATOR 21))))
(check-expect (hfile->ab-hgraph (hfile (list (record "**kern"
                                                     TOKEN
                                                     (list (token "**kern" EXCLUSIVE-INTERPRETATION 0))
                                                     0)
                                             (record "*clefG2"
                                                     TOKEN
                                                     (list (token "*clefG2" CLEF 1))
                                                     1)
                                             (record "*k[]"
                                                     TOKEN
                                                     (list (token "*k[]" KEY-SIG 2))
                                                     2)
                                             (record "*a:"
                                                     TOKEN
                                                     (list (token "*a:" KEY-LABEL 3))
                                                     3)
                                             (record "*M3/4"
                                                     TOKEN
                                                     (list (token "*M3/4" TIME-SIG 4))
                                                     4)
                                             (record "*^"
                                                     TOKEN
                                                     (list (token "*^" SPINE-SPLIT 5))
                                                     5)
                                             (record "*\t*^"
                                                     TOKEN
                                                     (list (token "*" NULL-INTERPRETATION 6)
                                                           (token "*^" SPINE-SPLIT 6))
                                                     6)
                                             (record "4c\t4c\t4c"
                                                     TOKEN
                                                     (list (token "4c" SPINE-DATA 7)
                                                           (token "4c" SPINE-DATA 7)
                                                           (token "4c" SPINE-DATA 7))
                                                     7)
                                             (record "4c\t4c\t4c"
                                                     TOKEN
                                                     (list (token "4c" SPINE-DATA 8)
                                                           (token "4c" SPINE-DATA 8)
                                                           (token "4c" SPINE-DATA 8))
                                                     8)
                                             (record "4c\t4c\t4c"
                                                     TOKEN
                                                     (list (token "4c" SPINE-DATA 9)
                                                           (token "4c" SPINE-DATA 9)
                                                           (token "4c" SPINE-DATA 9))
                                                     9)
                                             (record "=2\t=2\t=2"
                                                     TOKEN
                                                     (list (token "=2" MEASURE 10)
                                                           (token "=2" MEASURE 10)
                                                           (token "=2" MEASURE 10))
                                                     10)
                                             (record "4c\t4c\t4c"
                                                     TOKEN
                                                     (list (token "4c" SPINE-DATA 11)
                                                           (token "4c" SPINE-DATA 11)
                                                           (token "4c" SPINE-DATA 11))
                                                     11)
                                             (record "4c\t4c\t4c"
                                                     TOKEN
                                                     (list (token "4c" SPINE-DATA 12)
                                                           (token "4c" SPINE-DATA 12)
                                                           (token "4c" SPINE-DATA 12))
                                                     12)
                                             (record "4c\t4c\t4c"
                                                     TOKEN
                                                     (list (token "4c" SPINE-DATA 13)
                                                           (token "4c" SPINE-DATA 13)
                                                           (token "4c" SPINE-DATA 13))
                                                     13)
                                             (record "=3\t=3\t=3"
                                                     TOKEN
                                                     (list (token "=3" MEASURE 14)
                                                           (token "=3" MEASURE 14)
                                                           (token "=3" MEASURE 14))
                                                     14)
                                             (record "4c\t4c\t4c"
                                                     TOKEN
                                                     (list (token "4c" SPINE-DATA 15)
                                                           (token "4c" SPINE-DATA 15)
                                                           (token "4c" SPINE-DATA 15))
                                                     15)
                                             (record "4c\t4c\t4c"
                                                     TOKEN
                                                     (list (token "4c" SPINE-DATA 16)
                                                           (token "4c" SPINE-DATA 16)
                                                           (token "4c" SPINE-DATA 16))
                                                     16)
                                             (record "4c\t4c\t4c"
                                                     TOKEN
                                                     (list (token "4c" SPINE-DATA 17)
                                                           (token "4c" SPINE-DATA 17)
                                                           (token "4c" SPINE-DATA 17))
                                                     17)
                                             (record "*\t*v\t*v"
                                                     TOKEN
                                                     (list (token "*" NULL-INTERPRETATION 18)
                                                           (token "*v" SPINE-JOIN 18)
                                                           (token "*v" SPINE-JOIN 18))
                                                     18)
                                             (record "*v\t*v"
                                                     TOKEN
                                                     (list (token "*v" SPINE-JOIN 19)
                                                           (token "*v" SPINE-JOIN 19))
                                                     19)
                                             (record "==" TOKEN (list (token "==" MEASURE 20)) 20)
                                             (record "*-"
                                                     TOKEN
                                                     (list (token "*-" SPINE-TERMINATOR 21))
                                                     21)))
                                ab-hgraph)
              (ab-hgraph (root (list (list (leaf (token "**kern" EXCLUSIVE-INTERPRETATION 0))
                                           (leaf (token "*clefG2" CLEF 1))
                                           (leaf (token "*k[]" KEY-SIG 2))
                                           (leaf (token "*a:" KEY-LABEL 3))
                                           (leaf (token "*M3/4" TIME-SIG 4))
                                           (parent (token "*^" SPINE-SPLIT 5)
                                                   (list (leaf (token "*" NULL-INTERPRETATION 6))
                                                         (leaf (token "4c" SPINE-DATA 7))
                                                         (leaf (token "4c" SPINE-DATA 8))
                                                         (leaf (token "4c" SPINE-DATA 9))
                                                         (leaf (token "=2" MEASURE 10))
                                                         (leaf (token "4c" SPINE-DATA 11))
                                                         (leaf (token "4c" SPINE-DATA 12))
                                                         (leaf (token "4c" SPINE-DATA 13))
                                                         (leaf (token "=3" MEASURE 14))
                                                         (leaf (token "4c" SPINE-DATA 15))
                                                         (leaf (token "4c" SPINE-DATA 16))
                                                         (leaf (token "4c" SPINE-DATA 17))
                                                         (leaf (token "*" NULL-INTERPRETATION 18))
                                                         (leaf (token "*v" SPINE-JOIN 19)))
                                                   (list (parent (token "*^" SPINE-SPLIT 6)
                                                                 (list (leaf (token "4c" SPINE-DATA 7))
                                                                       (leaf (token "4c" SPINE-DATA 8))
                                                                       (leaf (token "4c" SPINE-DATA 9))
                                                                       (leaf (token "=2" MEASURE 10))
                                                                       (leaf (token "4c" SPINE-DATA 11))
                                                                       (leaf (token "4c" SPINE-DATA 12))
                                                                       (leaf (token "4c" SPINE-DATA 13))
                                                                       (leaf (token "=3" MEASURE 14))
                                                                       (leaf (token "4c" SPINE-DATA 15))
                                                                       (leaf (token "4c" SPINE-DATA 16))
                                                                       (leaf (token "4c" SPINE-DATA 17))
                                                                       (leaf (token "*v" SPINE-JOIN 18)))
                                                                 (list (leaf (token "4c" SPINE-DATA 7))
                                                                       (leaf (token "4c" SPINE-DATA 8))
                                                                       (leaf (token "4c" SPINE-DATA 9))
                                                                       (leaf (token "=2" MEASURE 10))
                                                                       (leaf (token "4c" SPINE-DATA 11))
                                                                       (leaf (token "4c" SPINE-DATA 12))
                                                                       (leaf (token "4c" SPINE-DATA 13))
                                                                       (leaf (token "=3" MEASURE 14))
                                                                       (leaf (token "4c" SPINE-DATA 15))
                                                                       (leaf (token "4c" SPINE-DATA 16))
                                                                       (leaf (token "4c" SPINE-DATA 17))
                                                                       (leaf (token "*v" SPINE-JOIN 18))))
                                                         (leaf (token "*v" SPINE-JOIN 19))))
                                           (leaf (token "==" MEASURE 20))
                                           (leaf (token "*-" SPINE-TERMINATOR 21)))))))
(check-expect (branch->lot (list (leaf (token "**kern" EXCLUSIVE-INTERPRETATION 0))
                                 (leaf (token "*clefG2" CLEF 1))
                                 (leaf (token "*k[]" KEY-SIG 2))
                                 (leaf (token "*a:" KEY-LABEL 3))
                                 (leaf (token "*M3/4" TIME-SIG 4))
                                 (parent (token "*^" SPINE-SPLIT 5)
                                         (list (leaf (token "*" NULL-INTERPRETATION 6))
                                               (leaf (token "4c" SPINE-DATA 7))
                                               (leaf (token "4c" SPINE-DATA 8))
                                               (leaf (token "4c" SPINE-DATA 9))
                                               (leaf (token "=2" MEASURE 10))
                                               (leaf (token "4c" SPINE-DATA 11))
                                               (leaf (token "4c" SPINE-DATA 12))
                                               (leaf (token "4c" SPINE-DATA 13))
                                               (leaf (token "=3" MEASURE 14))
                                               (leaf (token "4c" SPINE-DATA 15))
                                               (leaf (token "4c" SPINE-DATA 16))
                                               (leaf (token "4c" SPINE-DATA 17))
                                               (leaf (token "*" NULL-INTERPRETATION 18))
                                               (leaf (token "*v" SPINE-JOIN 19)))
                                         (list (parent (token "*^" SPINE-SPLIT 6)
                                                       (list (leaf (token "4c" SPINE-DATA 7))
                                                             (leaf (token "4c" SPINE-DATA 8))
                                                             (leaf (token "4c" SPINE-DATA 9))
                                                             (leaf (token "=2" MEASURE 10))
                                                             (leaf (token "4c" SPINE-DATA 11))
                                                             (leaf (token "4c" SPINE-DATA 12))
                                                             (leaf (token "4c" SPINE-DATA 13))
                                                             (leaf (token "=3" MEASURE 14))
                                                             (leaf (token "4c" SPINE-DATA 15))
                                                             (leaf (token "4c" SPINE-DATA 16))
                                                             (leaf (token "4c" SPINE-DATA 17))
                                                             (leaf (token "*v" SPINE-JOIN 18)))
                                                       (list (leaf (token "4c" SPINE-DATA 7))
                                                             (leaf (token "4c" SPINE-DATA 8))
                                                             (leaf (token "4c" SPINE-DATA 9))
                                                             (leaf (token "=2" MEASURE 10))
                                                             (leaf (token "4c" SPINE-DATA 11))
                                                             (leaf (token "4c" SPINE-DATA 12))
                                                             (leaf (token "4c" SPINE-DATA 13))
                                                             (leaf (token "=3" MEASURE 14))
                                                             (leaf (token "4c" SPINE-DATA 15))
                                                             (leaf (token "4c" SPINE-DATA 16))
                                                             (leaf (token "4c" SPINE-DATA 17))
                                                             (leaf (token "*v" SPINE-JOIN 18))))
                                               (leaf (token "*v" SPINE-JOIN 19))))
                                 (leaf (token "==" MEASURE 20))
                                 (leaf (token "*-" SPINE-TERMINATOR 21))))
              (list (token "**kern" EXCLUSIVE-INTERPRETATION 0)
                    (token "*clefG2" CLEF 1)
                    (token "*k[]" KEY-SIG 2)
                    (token "*a:" KEY-LABEL 3)
                    (token "*M3/4" TIME-SIG 4)
                    (token "*^" SPINE-SPLIT 5)
                    (token "*" NULL-INTERPRETATION 6)
                    (token "4c" SPINE-DATA 7)
                    (token "4c" SPINE-DATA 8)
                    (token "4c" SPINE-DATA 9)
                    (token "=2" MEASURE 10)
                    (token "4c" SPINE-DATA 11)
                    (token "4c" SPINE-DATA 12)
                    (token "4c" SPINE-DATA 13)
                    (token "=3" MEASURE 14)
                    (token "4c" SPINE-DATA 15)
                    (token "4c" SPINE-DATA 16)
                    (token "4c" SPINE-DATA 17)
                    (token "*" NULL-INTERPRETATION 18)
                    (token "*v" SPINE-JOIN 19)
                    (token "*^" SPINE-SPLIT 6)
                    (token "4c" SPINE-DATA 7)
                    (token "4c" SPINE-DATA 8)
                    (token "4c" SPINE-DATA 9)
                    (token "=2" MEASURE 10)
                    (token "4c" SPINE-DATA 11)
                    (token "4c" SPINE-DATA 12)
                    (token "4c" SPINE-DATA 13)
                    (token "=3" MEASURE 14)
                    (token "4c" SPINE-DATA 15)
                    (token "4c" SPINE-DATA 16)
                    (token "4c" SPINE-DATA 17)
                    (token "*v" SPINE-JOIN 18)
                    (token "4c" SPINE-DATA 7)
                    (token "4c" SPINE-DATA 8)
                    (token "4c" SPINE-DATA 9)
                    (token "=2" MEASURE 10)
                    (token "4c" SPINE-DATA 11)
                    (token "4c" SPINE-DATA 12)
                    (token "4c" SPINE-DATA 13)
                    (token "=3" MEASURE 14)
                    (token "4c" SPINE-DATA 15)
                    (token "4c" SPINE-DATA 16)
                    (token "4c" SPINE-DATA 17)
                    (token "*v" SPINE-JOIN 18)
                    (token "*v" SPINE-JOIN 19)
                    (token "==" MEASURE 20)
                    (token "*-" SPINE-TERMINATOR 21)))

(test)