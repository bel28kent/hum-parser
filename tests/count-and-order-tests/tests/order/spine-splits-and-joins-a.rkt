#lang racket/base

(require "../../../../parser/data-definitions/data-definitions.rkt"
         "../../../../parser/functions/file.rkt"
         "../../../../parser/functions/spine-parser.rkt"
         "../../../../parser/data-structures/humdrum-graph/data-definitions/data-definitions.rkt"
         "../../../../parser/data-structures/humdrum-graph/functions/hfile-to-hgraph.rkt"
         "../../../../parser/data-structures/humdrum-graph/functions/hgraph-to-hfile.rkt"
         test-engine/racket-tests)

(check-expect (path->hfile "../../data/order/spine-splits-and-joins-a.krn")
              (hfile (list (record "**kern"
                                   TOKEN
                                   (list (token "**kern" EXCLUSIVE-INTERPRETATION 0 0))
                                   0)
                           (record "*^" TOKEN (list (token "*^" SPINE-SPLIT 1 0)) 1)
                           (record "*\t*^"
                                   TOKEN
                                   (list (token "*" NULL-INTERPRETATION 2 0)
                                         (token "*^" SPINE-SPLIT 2 1))
                                   2)
                           (record "4c\t4c\t4c"
                                   TOKEN
                                   (list (token "4c" SPINE-DATA 3 0)
                                         (token "4c" SPINE-DATA 3 1)
                                         (token "4c" SPINE-DATA 3 2))
                                   3)
                           (record "4c\t4c\t4c"
                                   TOKEN
                                   (list (token "4c" SPINE-DATA 4 0)
                                         (token "4c" SPINE-DATA 4 1)
                                         (token "4c" SPINE-DATA 4 2))
                                   4)
                           (record "4c\t4c\t4c"
                                   TOKEN
                                   (list (token "4c" SPINE-DATA 5 0)
                                         (token "4c" SPINE-DATA 5 1)
                                         (token "4c" SPINE-DATA 5 2))
                                   5)
                           (record "*^\t*v\t*v"
                                   TOKEN
                                   (list (token "*^" SPINE-SPLIT 6 0)
                                         (token "*v" SPINE-JOIN 6 1)
                                         (token "*v" SPINE-JOIN 6 2))
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
                           (record "*v\t*v\t*^"
                                   TOKEN
                                   (list (token "*v" SPINE-JOIN 10 0)
                                         (token "*v" SPINE-JOIN 10 1)
                                         (token "*^" SPINE-SPLIT 10 2))
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
                           (record "*\t*v\t*v"
                                   TOKEN
                                   (list (token "*" NULL-INTERPRETATION 14 0)
                                         (token "*v" SPINE-JOIN 14 1)
                                         (token "*v" SPINE-JOIN 14 2))
                                   14)
                           (record "*v\t*v"
                                   TOKEN
                                   (list (token "*v" SPINE-JOIN 15 0)
                                         (token "*v" SPINE-JOIN 15 1))
                                   15)
                           (record "*-" TOKEN (list (token "*-" SPINE-TERMINATOR 16 0)) 16))))
(check-expect (spine-parser (path->hfile "../../data/order/spine-splits-and-joins-a.krn"))
              (list (global-spine KERN
                                  (list  (list (token "**kern" EXCLUSIVE-INTERPRETATION 0 0))
                                         (list (token "*^" SPINE-SPLIT 1 0))
                                         (list (token "*" NULL-INTERPRETATION 2 0)
                                               (token "*^" SPINE-SPLIT 2 1))
                                         (list (token "4c" SPINE-DATA 3 0)
                                               (token "4c" SPINE-DATA 3 1)
                                               (token "4c" SPINE-DATA 3 2))
                                         (list (token "4c" SPINE-DATA 4 0)
                                               (token "4c" SPINE-DATA 4 1)
                                               (token "4c" SPINE-DATA 4 2))
                                         (list (token "4c" SPINE-DATA 5 0)
                                               (token "4c" SPINE-DATA 5 1)
                                               (token "4c" SPINE-DATA 5 2))
                                         (list (token "*^" SPINE-SPLIT 6 0)
                                               (token "*v" SPINE-JOIN 6 1)
                                               (token "*v" SPINE-JOIN 6 2))
                                         (list (token "4c" SPINE-DATA 7 0)
                                               (token "4c" SPINE-DATA 7 1)
                                               (token "4c" SPINE-DATA 7 2))
                                         (list (token "4c" SPINE-DATA 8 0)
                                               (token "4c" SPINE-DATA 8 1)
                                               (token "4c" SPINE-DATA 8 2))
                                         (list (token "4c" SPINE-DATA 9 0)
                                               (token "4c" SPINE-DATA 9 1)
                                               (token "4c" SPINE-DATA 9 2))
                                         (list (token "*v" SPINE-JOIN 10 0)
                                               (token "*v" SPINE-JOIN 10 1)
                                               (token "*^" SPINE-SPLIT 10 2))
                                         (list (token "4c" SPINE-DATA 11 0)
                                               (token "4c" SPINE-DATA 11 1)
                                               (token "4c" SPINE-DATA 11 2))
                                         (list (token "4c" SPINE-DATA 12 0)
                                               (token "4c" SPINE-DATA 12 1)
                                               (token "4c" SPINE-DATA 12 2))
                                         (list (token "4c" SPINE-DATA 13 0)
                                               (token "4c" SPINE-DATA 13 1)
                                               (token "4c" SPINE-DATA 13 2))
                                         (list (token "*" NULL-INTERPRETATION 14 0)
                                               (token "*v" SPINE-JOIN 14 1)
                                               (token "*v" SPINE-JOIN 14 2))
                                         (list (token "*v" SPINE-JOIN 15 0)
                                               (token "*v" SPINE-JOIN 15 1))
                                         (list (token "*-" SPINE-TERMINATOR 16 0)))
                                  0)))
#|
(check-expect (hgraph->hfile ) )
|#
#|
(check-expect (lolot->lor ) )
|#
#|
(check-expect (hgraph->lolot ) )
|#
#|
(check-expect (hfile->hgraph ) )
|#
#|
(check-expect (branch->lot ) )
|#

(test)
