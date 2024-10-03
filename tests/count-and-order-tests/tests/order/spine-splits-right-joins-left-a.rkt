#lang racket/base

(require "../../../../parser/data-definitions/data-definitions.rkt"
         "../../../../parser/functions/file.rkt"
         "../../../../parser/functions/spine-parser.rkt"
         "../../../../data-structures/abstract-humdrum-graph/data-definitions/data-definitions.rkt"
         "../../../../data-structures/abstract-humdrum-graph/functions/ab-hgraph-to-hfile.rkt"
         "../../../../data-structures/abstract-humdrum-graph/functions/hfile-to-ab-hgraph.rkt"
         test-engine/racket-tests
         racket/list) ; TODO remove

(check-expect (path->hfile "../../data/order/spine-splits-right-joins-left-a.krn")
              (hfile (list (record "**kern" TOKEN
                                   (list (token "**kern" EXCLUSIVE-INTERPRETATION 0))
                                   0)
                           (record "*^" TOKEN
                                   (list (token "*^" SPINE-SPLIT 1))
                                   1)
                           (record "*\t*^" TOKEN
                                   (list (token "*" NULL-INTERPRETATION 2)
                                         (token "*^" SPINE-SPLIT 2))
                                   2)
                           (record "4c\t4c\t4c" TOKEN
                                   (list (token "4c" SPINE-DATA 3)
                                         (token "4c" SPINE-DATA 3)
                                         (token "4c" SPINE-DATA 3))
                                   3)
                           (record "4c\t4c\t4c" TOKEN
                                   (list (token "4c" SPINE-DATA 4)
                                         (token "4c" SPINE-DATA 4)
                                         (token "4c" SPINE-DATA 4))
                                   4)
                           (record "4c\t4c\t4c" TOKEN
                                   (list (token "4c" SPINE-DATA 5)
                                         (token "4c" SPINE-DATA 5)
                                         (token "4c" SPINE-DATA 5))
                                   5)
                           (record "*v\t*v\t*" TOKEN
                                   (list (token "*v" SPINE-JOIN 6)
                                         (token "*v" SPINE-JOIN 6)
                                         (token "*" NULL-INTERPRETATION 6))
                                   6)
                           (record "*v\t*v" TOKEN
                                   (list (token "*v" SPINE-JOIN 7)
                                         (token "*v" SPINE-JOIN 7))
                                   7)
                           (record "*-" TOKEN
                                   (list (token "*-" SPINE-TERMINATOR 8))
                                   8))))
(check-expect (spine-parser (path->hfile "../../data/order/spine-splits-right-joins-left-a.krn"))
              (list (global-spine KERN
                                  (list (list (token "**kern" EXCLUSIVE-INTERPRETATION 0))
                                        (list (token "*^" SPINE-SPLIT 1))
                                        (list (token "*" NULL-INTERPRETATION 2)
                                              (token "*^" SPINE-SPLIT 2))
                                        (list (token "4c" SPINE-DATA 3)
                                              (token "4c" SPINE-DATA 3)
                                              (token "4c" SPINE-DATA 3))
                                        (list (token "4c" SPINE-DATA 4)
                                              (token "4c" SPINE-DATA 4)
                                              (token "4c" SPINE-DATA 4))
                                        (list (token "4c" SPINE-DATA 5)
                                              (token "4c" SPINE-DATA 5)
                                              (token "4c" SPINE-DATA 5))
                                        (list (token "*v" SPINE-JOIN 6)
                                              (token "*v" SPINE-JOIN 6)
                                              (token "*" NULL-INTERPRETATION 6))
                                        (list (token "*v" SPINE-JOIN 7)
                                              (token "*v" SPINE-JOIN 7))
                                        (list (token "*-" SPINE-TERMINATOR 8)))
                                  0)))
(check-expect (ab-hgraph->hfile
               (ab-hgraph (root (list (list (leaf (token "**kern" EXCLUSIVE-INTERPRETATION 0))
                                            (parent (token "*^" SPINE-SPLIT 1)
                                                    (list (leaf (token "*" NULL-INTERPRETATION 2))
                                                          (leaf (token "4c" SPINE-DATA 3))
                                                          (leaf (token "4c" SPINE-DATA 4))
                                                          (leaf (token "4c" SPINE-DATA 5))
                                                          (leaf (token "*v" SPINE-JOIN 6)))
                                                    (list (parent (token "*^" SPINE-SPLIT 2)
                                                                  (list (leaf (token "4c" SPINE-DATA 3))
                                                                        (leaf (token "4c" SPINE-DATA 4))
                                                                        (leaf (token "4c" SPINE-DATA 5))
                                                                        (leaf (token "*v" SPINE-JOIN 6)))
                                                                  (list (leaf (token "4c" SPINE-DATA 3))
                                                                        (leaf (token "4c" SPINE-DATA 4))
                                                                        (leaf (token "4c" SPINE-DATA 5))
                                                                        (leaf (token "*" NULL-INTERPRETATION 6))
                                                                        (leaf (token "*v" SPINE-JOIN 7))))
                                                          (leaf (token "*v" SPINE-JOIN 7))))
                                            (leaf (token "*-" SPINE-TERMINATOR 8)))))))
              (path->hfile "../../data/order/spine-splits-right-joins-left-a.krn"))
(check-expect (lolot->lor (list (list (token "**kern" EXCLUSIVE-INTERPRETATION 0))
                                (list (token "*^" SPINE-SPLIT 1))
                                (list (token "*" NULL-INTERPRETATION 2)
                                      (token "*^" SPINE-SPLIT 2))
                                (list (token "4c" SPINE-DATA 3)
                                      (token "4c" SPINE-DATA 3)
                                      (token "4c" SPINE-DATA 3))
                                (list (token "4c" SPINE-DATA 4)
                                      (token "4c" SPINE-DATA 4)
                                      (token "4c" SPINE-DATA 4))
                                (list (token "4c" SPINE-DATA 5)
                                      (token "4c" SPINE-DATA 5)
                                      (token "4c" SPINE-DATA 5))
                                (list (token "*v" SPINE-JOIN 6)
                                      (token "*v" SPINE-JOIN 6)
                                      (token "*" NULL-INTERPRETATION 6))
                                (list (token "*v" SPINE-JOIN 7)
                                      (token "*v" SPINE-JOIN 7))
                                (list (token "*-" SPINE-TERMINATOR 8))))
              (list (record "**kern" TOKEN
                            (list (token "**kern" EXCLUSIVE-INTERPRETATION 0))
                            0)
                    (record "*^" TOKEN
                            (list (token "*^" SPINE-SPLIT 1))
                            1)
                    (record "*\t*^" TOKEN
                            (list (token "*" NULL-INTERPRETATION 2)
                                  (token "*^" SPINE-SPLIT 2))
                            2)
                    (record "4c\t4c\t4c" TOKEN
                            (list (token "4c" SPINE-DATA 3)
                                  (token "4c" SPINE-DATA 3)
                                  (token "4c" SPINE-DATA 3))
                            3)
                    (record "4c\t4c\t4c" TOKEN
                            (list (token "4c" SPINE-DATA 4)
                                  (token "4c" SPINE-DATA 4)
                                  (token "4c" SPINE-DATA 4))
                            4)
                    (record "4c\t4c\t4c" TOKEN
                            (list (token "4c" SPINE-DATA 5)
                                  (token "4c" SPINE-DATA 5)
                                  (token "4c" SPINE-DATA 5))
                            5)
                    (record "*v\t*v\t*" TOKEN
                            (list (token "*v" SPINE-JOIN 6)
                                  (token "*v" SPINE-JOIN 6)
                                  (token "*" NULL-INTERPRETATION 6))
                            6)
                    (record "*v\t*v" TOKEN
                            (list (token "*v" SPINE-JOIN 7)
                                  (token "*v" SPINE-JOIN 7))
                            7)
                    (record "*-" TOKEN
                            (list (token "*-" SPINE-TERMINATOR 8))
                            8)))
(check-expect (ab-hgraph->lolot
               (ab-hgraph (root (list (list (leaf (token "**kern" EXCLUSIVE-INTERPRETATION 0))
                                            (parent (token "*^" SPINE-SPLIT 1)
                                                    (list (leaf (token "*" NULL-INTERPRETATION 2))
                                                          (leaf (token "4c" SPINE-DATA 3))
                                                          (leaf (token "4c" SPINE-DATA 4))
                                                          (leaf (token "4c" SPINE-DATA 5))
                                                          (leaf (token "*v" SPINE-JOIN 6)))
                                                    (list (parent (token "*^" SPINE-SPLIT 2)
                                                                  (list (leaf (token "4c" SPINE-DATA 3))
                                                                        (leaf (token "4c" SPINE-DATA 4))
                                                                        (leaf (token "4c" SPINE-DATA 5))
                                                                        (leaf (token "*v" SPINE-JOIN 6)))
                                                                  (list (leaf (token "4c" SPINE-DATA 3))
                                                                        (leaf (token "4c" SPINE-DATA 4))
                                                                        (leaf (token "4c" SPINE-DATA 5))
                                                                        (leaf (token "*" NULL-INTERPRETATION 6))
                                                                        (leaf (token "*v" SPINE-JOIN 7))))
                                                          (leaf (token "*v" SPINE-JOIN 7))))
                                            (leaf (token "*-" SPINE-TERMINATOR 8)))))))
              (list (list (token "**kern" EXCLUSIVE-INTERPRETATION 0))
                    (list (token "*^" SPINE-SPLIT 1))
                    (list (token "*" NULL-INTERPRETATION 2)
                          (token "*^" SPINE-SPLIT 2))
                    (list (token "4c" SPINE-DATA 3)
                          (token "4c" SPINE-DATA 3)
                          (token "4c" SPINE-DATA 3))
                    (list (token "4c" SPINE-DATA 4)
                          (token "4c" SPINE-DATA 4)
                          (token "4c" SPINE-DATA 4))
                    (list (token "4c" SPINE-DATA 5)
                          (token "4c" SPINE-DATA 5)
                          (token "4c" SPINE-DATA 5))
                    (list (token "*v" SPINE-JOIN 6)
                          (token "*v" SPINE-JOIN 6)
                          (token "*" NULL-INTERPRETATION 6))
                    (list (token "*v" SPINE-JOIN 7)
                          (token "*v" SPINE-JOIN 7))
                    (list (token "*-" SPINE-TERMINATOR 8))))
(check-expect (hfile->ab-hgraph (path->hfile "../../data/order/spine-splits-right-joins-left-a.krn")
                                ab-hgraph)
              (ab-hgraph (root (list (list (leaf (token "**kern" EXCLUSIVE-INTERPRETATION 0))
                                           (parent (token "*^" SPINE-SPLIT 1)
                                                   (list (leaf (token "*" NULL-INTERPRETATION 2))
                                                         (leaf (token "4c" SPINE-DATA 3))
                                                         (leaf (token "4c" SPINE-DATA 4))
                                                         (leaf (token "4c" SPINE-DATA 5))
                                                         (leaf (token "*v" SPINE-JOIN 6)))
                                                   (list (parent (token "*^" SPINE-SPLIT 2)
                                                                 (list (leaf (token "4c" SPINE-DATA 3))
                                                                       (leaf (token "4c" SPINE-DATA 4))
                                                                       (leaf (token "4c" SPINE-DATA 5))
                                                                       (leaf (token "*v" SPINE-JOIN 6)))
                                                                 (list (leaf (token "4c" SPINE-DATA 3))
                                                                       (leaf (token "4c" SPINE-DATA 4))
                                                                       (leaf (token "4c" SPINE-DATA 5))
                                                                       (leaf (token "*" NULL-INTERPRETATION 6))
                                                                       (leaf (token "*v" SPINE-JOIN 7))))
                                                         (leaf (token "*v" SPINE-JOIN 7))))
                                           (leaf (token "*-" SPINE-TERMINATOR 8)))))))
(check-expect (branch->lot (list (leaf (token "**kern" EXCLUSIVE-INTERPRETATION 0))
                                 (parent (token "*^" SPINE-SPLIT 1)
                                         (list (leaf (token "*" NULL-INTERPRETATION 2))
                                               (leaf (token "4c" SPINE-DATA 3))
                                               (leaf (token "4c" SPINE-DATA 4))
                                               (leaf (token "4c" SPINE-DATA 5))
                                               (leaf (token "*v" SPINE-JOIN 6)))
                                         (list (parent (token "*^" SPINE-SPLIT 2)
                                                       (list (leaf (token "4c" SPINE-DATA 3))
                                                             (leaf (token "4c" SPINE-DATA 4))
                                                             (leaf (token "4c" SPINE-DATA 5))
                                                             (leaf (token "*v" SPINE-JOIN 6)))
                                                       (list (leaf (token "4c" SPINE-DATA 3))
                                                             (leaf (token "4c" SPINE-DATA 4))
                                                             (leaf (token "4c" SPINE-DATA 5))
                                                             (leaf (token "*" NULL-INTERPRETATION 6))
                                                             (leaf (token "*v" SPINE-JOIN 7))))
                                               (leaf (token "*v" SPINE-JOIN 7))))
                                 (leaf (token "*-" SPINE-TERMINATOR 8))))
              (list (token "**kern" EXCLUSIVE-INTERPRETATION 0)
                    (token "*^" SPINE-SPLIT 1)
                    (token "*" NULL-INTERPRETATION 2)
                    (token "4c" SPINE-DATA 3)
                    (token "4c" SPINE-DATA 4)
                    (token "4c" SPINE-DATA 5)
                    (token "*v" SPINE-JOIN 6)
                    (token "*^" SPINE-SPLIT 2)
                    (token "4c" SPINE-DATA 3)
                    (token "4c" SPINE-DATA 4)
                    (token "4c" SPINE-DATA 5)
                    (token "*v" SPINE-JOIN 6)
                    (token "4c" SPINE-DATA 3)
                    (token "4c" SPINE-DATA 4)
                    (token "4c" SPINE-DATA 5)
                    (token "*" NULL-INTERPRETATION 6)
                    (token "*v" SPINE-JOIN 7)
                    (token "*v" SPINE-JOIN 7)
                    (token "*-" SPINE-TERMINATOR 8)))

(test)