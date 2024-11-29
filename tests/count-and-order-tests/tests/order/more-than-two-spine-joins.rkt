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

;; Node definitions
(define TERM-NODE (terminator-node (box-immutable (token "*-" SPINE-TERMINATOR 7 0))))
(define J-3 (token-node (token "*v" SPINE-JOIN 6 2) TERM-NODE))
(define J-2 (token-node (token "*v" SPINE-JOIN 6 1) TERM-NODE))
(define J-1 (token-node (token "*v" SPINE-JOIN 6 0) TERM-NODE))
(define 4c-5-3 (token-node (token "4c" SPINE-DATA 5 2) (box-immutable J-3)))
(define 4c-5-2 (token-node (token "4c" SPINE-DATA 5 1) (box-immutable J-2)))
(define 4c-5-1 (token-node (token "4c" SPINE-DATA 5 0) (box-immutable J-1)))
(define 4c-4-3 (token-node (token "4c" SPINE-DATA 4 2) (box-immutable 4c-5-3)))
(define 4c-4-2 (token-node (token "4c" SPINE-DATA 4 1) (box-immutable 4c-5-2)))
(define 4c-4-1 (token-node (token "4c" SPINE-DATA 4 0) (box-immutable 4c-5-1)))
(define 4c-3-3 (token-node (token "4c" SPINE-DATA 3 2) (box-immutable 4c-4-3)))
(define 4c-3-2 (token-node (token "4c" SPINE-DATA 3 1) (box-immutable 4c-4-2)))
(define 4c-3-1 (token-node (token "4c" SPINE-DATA 3 0) (box-immutable 4c-4-1)))
(define SPLIT-2 (split-node (token "*^" SPINE-SPLIT 2 1) (box-immutable 4c-3-2)
                                                         (box-immutable 4c-3-3)))
(define NULL-2 (token-node (token "*" NULL-INTERPRETATION 2 0) (box-immutable 4c-3-1)))
(define SPLIT-1 (split-node (token "*^" SPINE-SPLIT 1 0) (box-immutable NULL-2)
                                                         (box-immutable SPLIT-2)))
(define KERN-0 (token-node (token "**kern" EXCLUSIVE-INTERPRETATION 0 0)
                           (box-immutable SPLIT-1)))


(check-expect (path->hfile "../../data/order/more-than-two-spine-joins.krn")
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
                           (record "*v\t*v\t*v"
                                   TOKEN
                                   (list (token "*v" SPINE-JOIN 6 0)
                                         (token "*v" SPINE-JOIN 6 1)
                                         (token "*v" SPINE-JOIN 6 2))
                                   6)
                           (record "*-" TOKEN (list (token "*-" SPINE-TERMINATOR 7 0)) 7))))
(check-expect (spine-parser (path->hfile "../../data/order/more-than-two-spine-joins.krn"))
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
                                        (list (token "*-" SPINE-TERMINATOR 7 0)))
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
                                        (path->hfile "../../data/order/more-than-two-spine-joins.krn")))
              (list (linked-spine KERN-0)))

(test)
