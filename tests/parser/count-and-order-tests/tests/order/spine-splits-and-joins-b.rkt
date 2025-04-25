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
(define TERM-12-0 (terminator-node (token "*-" SPINE-TERMINATOR 12 0)))
(define NULL-11-0 (token-node (token "*" NULL-INTERPRETATION 11 0) (box-immutable TERM-12-0)))
(define NULL-10-0 (token-node (token "*" NULL-INTERPRETATION 10 0)
                              (box-immutable NULL-11-0)))
(define 4c-9-0 (token-node (token "4c" SPINE-DATA 9 0) (box-immutable NULL-10-0)))
(define 4c-8-0 (token-node (token "4c" SPINE-DATA 8 0) (box-immutable 4c-9-0)))
(define 4c-7-0 (token-node (token "4c" SPINE-DATA 7 0) (box-immutable 4c-8-0)))
(define J-6-0 (token-node (token "*v" SPINE-JOIN 6 0) (box-immutable 4c-7-0)))
(define J-6-1 (token-node (token "*v" SPINE-JOIN 6 1) (box-immutable 4c-7-0)))
(define J-6-2 (token-node (token "*v" SPINE-JOIN 6 2) (box-immutable 4c-7-0)))
(define 4c-5-0 (token-node (token "4c" SPINE-DATA 5 0) (box-immutable J-6-0)))
(define 4c-5-1 (token-node (token "4c" SPINE-DATA 5 1) (box-immutable J-6-1)))
(define 4c-5-2 (token-node (token "4c" SPINE-DATA 5 2) (box-immutable J-6-2)))
(define 4c-4-0 (token-node (token "4c" SPINE-DATA 4 0) (box-immutable 4c-5-0)))
(define 4c-4-1 (token-node (token "4c" SPINE-DATA 4 1) (box-immutable 4c-5-1)))
(define 4c-4-2 (token-node (token "4c" SPINE-DATA 4 2) (box-immutable 4c-5-2)))
(define 4c-3-0 (token-node (token "4c" SPINE-DATA 3 0) (box-immutable 4c-4-0)))
(define 4c-3-1 (token-node (token "4c" SPINE-DATA 3 1) (box-immutable 4c-4-1)))
(define 4c-3-2 (token-node (token "4c" SPINE-DATA 3 2) (box-immutable 4c-4-2)))
(define NULL-2-0 (token-node (token "*" NULL-INTERPRETATION 2 0) (box-immutable 4c-3-0)))
(define S-2-1 (split-node (token "*^" SPINE-SPLIT 2 1) (box-immutable 4c-3-1)
                                                       (box-immutable 4c-3-2)))
(define S-1-0 (split-node (token "*^" SPINE-SPLIT 1 0) (box-immutable NULL-2-0)
                                                       (box-immutable S-2-1)))
(define KERN-0-0 (token-node (token "**kern" EXCLUSIVE-INTERPRETATION 0 0)
                             (box-immutable S-1-0)))

(define TERM-12-1 (terminator-node (token "*-" SPINE-TERMINATOR 12 1)))
(define J-11-1 (token-node (token "*v" SPINE-JOIN 11 1) (box-immutable TERM-12-1)))
(define J-11-2 (token-node (token "*v" SPINE-JOIN 11 2) (box-immutable TERM-12-1)))
(define J-10-1 (token-node (token "*v" SPINE-JOIN 10 1) (box-immutable J-11-1)))
(define J-10-2 (token-node (token "*v" SPINE-JOIN 10 2) (box-immutable J-11-1)))
(define NULL-10-3 (token-node (token "*" NULL-INTERPRETATION 10 3)
                              (box-immutable J-11-2)))
(define 4c-9-1 (token-node (token "4c" SPINE-DATA 9 1) (box-immutable J-10-1)))
(define 4c-9-2 (token-node (token "4c" SPINE-DATA 9 2) (box-immutable J-10-2)))
(define 4c-9-3 (token-node (token "4c" SPINE-DATA 9 3) (box-immutable NULL-10-3)))
(define 4c-8-1 (token-node (token "4c" SPINE-DATA 8 1) (box-immutable 4c-9-1)))
(define 4c-8-2 (token-node (token "4c" SPINE-DATA 8 2) (box-immutable 4c-9-2)))
(define 4c-8-3 (token-node (token "4c" SPINE-DATA 8 3) (box-immutable 4c-9-3)))
(define 4c-7-1 (token-node (token "4c" SPINE-DATA 7 1) (box-immutable 4c-8-1)))
(define 4c-7-2 (token-node (token "4c" SPINE-DATA 7 2) (box-immutable 4c-8-2)))
(define 4c-7-3 (token-node (token "4c" SPINE-DATA 7 3) (box-immutable 4c-8-3)))
(define NULL-6-3 (token-node (token "*" NULL-INTERPRETATION 6 3) (box-immutable 4c-7-1)))
(define S-6-4 (split-node (token "*^" SPINE-SPLIT 6 4) (box-immutable 4c-7-2)
                                                       (box-immutable 4c-7-3)))
(define 4c-5-3 (token-node (token "4c" SPINE-DATA 5 3) (box-immutable NULL-6-3)))
(define 4c-5-4 (token-node (token "4c" SPINE-DATA 5 4) (box-immutable S-6-4)))
(define 4c-4-3 (token-node (token "4c" SPINE-DATA 4 3) (box-immutable 4c-5-3)))
(define 4c-4-4 (token-node (token "4c" SPINE-DATA 4 4) (box-immutable 4c-5-4)))
(define 4c-3-3 (token-node (token "4c" SPINE-DATA 3 3) (box-immutable 4c-4-3)))
(define 4c-3-4 (token-node (token "4c" SPINE-DATA 3 4) (box-immutable 4c-4-4)))
(define NULL-2-2 (token-node (token "*" NULL-INTERPRETATION 2 2) (box-immutable 4c-3-3)))
(define NULL-2-3 (token-node (token "*" NULL-INTERPRETATION 2 3) (box-immutable 4c-3-4)))
(define S-1-1 (split-node (token "*^" SPINE-SPLIT 1 1) (box-immutable NULL-2-2)
                                                       (box-immutable NULL-2-3)))
(define KERN-0-1 (token-node (token "**kern" EXCLUSIVE-INTERPRETATION 0 1)
                           (box-immutable S-1-1)))

(check-expect (path->hfile "../../data/order/spine-splits-and-joins-b.krn")
              (hfile (list (record "**kern\t**kern"
                                   TOKEN
                                   (list (token "**kern" EXCLUSIVE-INTERPRETATION 0 0)
                                         (token "**kern" EXCLUSIVE-INTERPRETATION 0 1))
                                   0)
                           (record "*^\t*^"
                                   TOKEN
                                   (list (token "*^" SPINE-SPLIT 1 0)
                                         (token "*^" SPINE-SPLIT 1 1))
                                   1)
                           (record "*\t*^\t*\t*"
                                   TOKEN
                                   (list (token "*" NULL-INTERPRETATION 2 0)
                                         (token "*^" SPINE-SPLIT 2 1)
                                         (token "*" NULL-INTERPRETATION 2 2)
                                         (token "*" NULL-INTERPRETATION 2 3))
                                   2)
                           (record "4c\t4c\t4c\t4c\t4c"
                                   TOKEN
                                   (list (token "4c" SPINE-DATA 3 0)
                                         (token "4c" SPINE-DATA 3 1)
                                         (token "4c" SPINE-DATA 3 2)
                                         (token "4c" SPINE-DATA 3 3)
                                         (token "4c" SPINE-DATA 3 4))
                                   3)
                           (record "4c\t4c\t4c\t4c\t4c"
                                   TOKEN
                                   (list (token "4c" SPINE-DATA 4 0)
                                         (token "4c" SPINE-DATA 4 1)
                                         (token "4c" SPINE-DATA 4 2)
                                         (token "4c" SPINE-DATA 4 3)
                                         (token "4c" SPINE-DATA 4 4))
                                   4)
                           (record "4c\t4c\t4c\t4c\t4c"
                                   TOKEN
                                   (list (token "4c" SPINE-DATA 5 0)
                                         (token "4c" SPINE-DATA 5 1)
                                         (token "4c" SPINE-DATA 5 2)
                                         (token "4c" SPINE-DATA 5 3)
                                         (token "4c" SPINE-DATA 5 4))
                                   5)
                           (record "*v\t*v\t*v\t*\t*^"
                                   TOKEN
                                   (list (token "*v" SPINE-JOIN 6 0)
                                         (token "*v" SPINE-JOIN 6 1)
                                         (token "*v" SPINE-JOIN 6 2)
                                         (token "*" NULL-INTERPRETATION 6 3)
                                         (token "*^" SPINE-SPLIT 6 4))
                                   6)
                           (record "4c\t4c\t4c\t4c"
                                   TOKEN
                                   (list (token "4c" SPINE-DATA 7 0)
                                         (token "4c" SPINE-DATA 7 1)
                                         (token "4c" SPINE-DATA 7 2)
                                         (token "4c" SPINE-DATA 7 3))
                                   7)
                           (record "4c\t4c\t4c\t4c"
                                   TOKEN
                                   (list (token "4c" SPINE-DATA 8 0)
                                         (token "4c" SPINE-DATA 8 1)
                                         (token "4c" SPINE-DATA 8 2)
                                         (token "4c" SPINE-DATA 8 3))
                                   8)
                           (record "4c\t4c\t4c\t4c"
                                   TOKEN
                                   (list (token "4c" SPINE-DATA 9 0)
                                         (token "4c" SPINE-DATA 9 1)
                                         (token "4c" SPINE-DATA 9 2)
                                         (token "4c" SPINE-DATA 9 3))
                                   9)
                           (record "*\t*v\t*v\t*"
                                   TOKEN
                                   (list (token "*" NULL-INTERPRETATION 10 0)
                                         (token "*v" SPINE-JOIN 10 1)
                                         (token "*v" SPINE-JOIN 10 2)
                                         (token "*" NULL-INTERPRETATION 10 3))
                                   10)
                           (record "*\t*v\t*v"
                                   TOKEN
                                   (list (token "*" NULL-INTERPRETATION 11 0)
                                         (token "*v" SPINE-JOIN 11 1)
                                         (token "*v" SPINE-JOIN 11 2))
                                   11)
                           (record "*-\t*-"
                                   TOKEN
                                   (list (token "*-" SPINE-TERMINATOR 12 0)
                                         (token "*-" SPINE-TERMINATOR 12 1))
                                   12))))
(check-expect (spine-parser (path->hfile "../../data/order/spine-splits-and-joins-b.krn"))
              (list (global-spine KERN
                                  (list (list (token "**kern" EXCLUSIVE-INTERPRETATION 0 0))
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
                                        (list (token "*v" SPINE-JOIN 6 0)
                                              (token "*v" SPINE-JOIN 6 1)
                                              (token "*v" SPINE-JOIN 6 2))
                                        (list (token "4c" SPINE-DATA 7 0))
                                        (list (token "4c" SPINE-DATA 8 0))
                                        (list (token "4c" SPINE-DATA 9 0))
                                        (list (token "*" NULL-INTERPRETATION 10 0))
                                        (list (token "*" NULL-INTERPRETATION 11 0))
                                        (list (token "*-" SPINE-TERMINATOR 12 0)))
                                        0)
                    (global-spine KERN
                                  (list (list (token "**kern" EXCLUSIVE-INTERPRETATION 0 1))
                                        (list (token "*^" SPINE-SPLIT 1 1))
                                        (list (token "*" NULL-INTERPRETATION 2 2)
                                              (token "*" NULL-INTERPRETATION 2 3))
                                        (list (token "4c" SPINE-DATA 3 3)
                                              (token "4c" SPINE-DATA 3 4))
                                        (list (token "4c" SPINE-DATA 4 3)
                                              (token "4c" SPINE-DATA 4 4))
                                        (list (token "4c" SPINE-DATA 5 3)
                                              (token "4c" SPINE-DATA 5 4))
                                        (list (token "*" NULL-INTERPRETATION 6 3)
                                              (token "*^" SPINE-SPLIT 6 4))
                                        (list (token "4c" SPINE-DATA 7 1)
                                              (token "4c" SPINE-DATA 7 2)
                                              (token "4c" SPINE-DATA 7 3))
                                        (list (token "4c" SPINE-DATA 8 1)
                                              (token "4c" SPINE-DATA 8 2)
                                              (token "4c" SPINE-DATA 8 3))
                                        (list (token "4c" SPINE-DATA 9 1)
                                              (token "4c" SPINE-DATA 9 2)
                                              (token "4c" SPINE-DATA 9 3))
                                        (list (token "*v" SPINE-JOIN 10 1)
                                              (token "*v" SPINE-JOIN 10 2)
                                              (token "*" NULL-INTERPRETATION 10 3))
                                        (list (token "*v" SPINE-JOIN 11 1)
                                              (token "*v" SPINE-JOIN 11 2))
                                        (list (token "*-" SPINE-TERMINATOR 12 1)))
                                  1)))
#|
(check-expect(hgraph->hfile ) )
|#
#|
(check-expect(lolot->lor ) )
|#
#|
(check-expect(hgraph->lolot ) )
|#
#|
(check-expect(hfile->hgraph ) )
|#
#|
(check-expect(branch->lot ) )
|#
(check-expect (gspines->linked-spines (spine-parser
                                        (path->hfile "../../data/order/spine-splits-and-joins-b.krn"))
                                      (path->hfile "../../data/order/spine-splits-and-joins-b.krn"))
              (list (linked-spine KERN-0-0) (linked-spine KERN-0-1)))
(check-expect (extract-spine-arity S-J-B) (spine-arity 2 (list (list 1 1)
                                                               (list 1 1)
                                                               (list 2 2)
                                                               (list 3 2)
                                                               (list 3 2)
                                                               (list 3 2)
                                                               (list 3 2)
                                                               (list 1 3)
                                                               (list 1 3)
                                                               (list 1 3)
                                                               (list 1 3)
                                                               (list 1 2)
                                                               (list 1 1))))

(test)
