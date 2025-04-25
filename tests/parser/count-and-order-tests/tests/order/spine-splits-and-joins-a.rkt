#lang racket/base

(require "../../../../parser/data-definitions/data-definitions.rkt"
         "../../../../parser/functions/file.rkt"
         "../../../../parser/functions/spine-parser.rkt"
         "../../../../parser/data-structures/humdrum-graph/data-definitions/data-definitions.rkt"
         "../../../../parser/data-structures/humdrum-graph/functions/hfile-to-hgraph.rkt"
         "../../../../parser/data-structures/humdrum-graph/functions/hgraph-to-hfile.rkt"
         "../../../../parser/data-structures/linked-spine/data-definitions/data-definitions.rkt"
         "../../../../parser/data-structures/linked-spine/functions/gspines-to-linked-spines.rkt"
         test-engine/racket-tests)

;; Node Definitions
(define TERM-16-0 (terminator-node (token "*-" SPINE-TERMINATOR 16 0)))
(define J-15-0 (token-node (token "*v" SPINE-JOIN 15 0) (box-immutable TERM-16-0)))
(define J-15-1 (token-node (token "*v" SPINE-JOIN 15 1) (box-immutable TERM-16-0)))
(define NULL-14-0 (token-node (token "*" NULL-INTERPRETATION 14 0) (box-immutable J-15-0)))
(define J-14-1 (token-node (token "*v" SPINE-JOIN 14 1) (box-immutable J-15-1)))
(define J-14-2 (token-node (token "*v" SPINE-JOIN 14 2) (box-immutable J-15-1)))
(define 4c-13-0 (token-node (token "4c" SPINE-DATA 13 0) (box-immutable NULL-14-0)))
(define 4c-13-1 (token-node (token "4c" SPINE-DATA 13 1) (box-immutable J-14-1)))
(define 4c-13-2 (token-node (token "4c" SPINE-DATA 13 2) (box-immutable J-14-2)))
(define 4c-12-0 (token-node (token "4c" SPINE-DATA 12 0) (box-immutable 4c-13-0)))
(define 4c-12-1 (token-node (token "4c" SPINE-DATA 12 1) (box-immutable 4c-13-1)))
(define 4c-12-2 (token-node (token "4c" SPINE-DATA 12 2) (box-immutable 4c-13-2)))
(define 4c-11-0 (token-node (token "4c" SPINE-DATA 11 0) (box-immutable 4c-12-0)))
(define 4c-11-1 (token-node (token "4c" SPINE-DATA 11 1) (box-immutable 4c-12-1)))
(define 4c-11-2 (token-node (token "4c" SPINE-DATA 11 2) (box-immutable 4c-12-2)))
(define J-10-0 (token-node (token "*v" SPINE-JOIN 10 0) (box-immutable 4c-11-0)))
(define J-10-1 (token-node (token "*v" SPINE-JOIN 10 1) (box-immutable 4c-11-0)))
(define S-10-2 (split-node (token "*^" SPINE-SPLIT 10 2) (box-immutable 4c-11-1)
                                                         (box-immutable 4c-11-2)))
(define 4c-9-0 (token-node (token "4c" SPINE-DATA 9 0) (box-immutable J-10-0)))
(define 4c-9-1 (token-node (token "4c" SPINE-DATA 9 1) (box-immutable J-10-1)))
(define 4c-9-2 (token-node (token "4c" SPINE-DATA 9 2) (box-immutable S-10-2)))
(define 4c-8-0 (token-node (token "4c" SPINE-DATA 8 0) (box-immutable 4c-9-0)))
(define 4c-8-1 (token-node (token "4c" SPINE-DATA 8 1) (box-immutable 4c-9-1)))
(define 4c-8-2 (token-node (token "4c" SPINE-DATA 8 2) (box-immutable 4c-9-2)))
(define 4c-7-0 (token-node (token "4c" SPINE-DATA 7 0) (box-immutable 4c-8-0)))
(define 4c-7-1 (token-node (token "4c" SPINE-DATA 7 1) (box-immutable 4c-8-1)))
(define 4c-7-2 (token-node (token "4c" SPINE-DATA 7 2) (box-immutable 4c-8-2)))
(define S-6-0 (split-node (token "*^" SPINE-SPLIT 6 0) (box-immutable 4c-7-0)
                                                       (box-immutable 4c-7-1)))
(define J-6-1 (token-node (token "*v" SPINE-JOIN 6 1) (box-immutable 4c-7-2)))
(define J-6-2 (token-node (token "*v" SPINE-JOIN 6 2) (box-immutable 4c-7-2)))
(define 4c-5-0 (token-node (token "4c" SPINE-DATA 5 0) (box-immutable S-6-0)))
(define 4c-5-1 (token-node (token "4c" SPINE-DATA 5 1) (box-immutable J-6-1)))
(define 4c-5-2 (token-node (token "4c" SPINE-DATA 5 2) (box-immutable J-6-2)))
(define 4c-4-0 (token-node (token "4c" SPINE-DATA 4 0) (box-immutable 4c-5-0)))
(define 4c-4-1 (token-node (token "4c" SPINE-DATA 4 1) (box-immutable 4c-5-1)))
(define 4c-4-2 (token-node (token "4c" SPINE-DATA 4 2) (box-immutable 4c-5-2)))
(define 4c-3-0 (token-node (token "4c" SPINE-DATA 3 0) (box-immutable 4c-4-0)))
(define 4c-3-1 (token-node (token "4c" SPINE-DATA 3 1) (box-immutable 4c-4-1)))
(define 4c-3-2 (token-node (token "4c" SPINE-DATA 3 2) (box-immutable 4c-4-2)))
(define N-2-0 (token-node (token "*" NULL-INTERPRETATION 2 0) (box-immutable 4c-3-0)))
(define S-2-1 (split-node (token "*^" SPINE-SPLIT 2 1) (box-immutable 4c-3-1)
                                                       (box-immutable 4c-3-2)))
(define S-1-0 (split-node (token "*^" SPINE-SPLIT 1 0) (box-immutable N-2-0)
                                                       (box-immutable S-2-1)))
(define KERN-0-0 (token-node (token "**kern" EXCLUSIVE-INTERPRETATION 0 0)
                             (box-immutable S-1-0)))

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
(check-expect (gspines->linked-spines (spine-parser
                                        (path->hfile "../../data/order/spine-splits-and-joins-a.krn"))
                                      (path->hfile "../../data/order/spine-splits-and-joins-a.krn"))
              (list (linked-spine KERN-0-0)))
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

(test)
