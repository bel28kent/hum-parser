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

;; Node Definitions
(define TERM-16-0 (terminator-node (token "*-" 'SpineTerminator 16 0)))
(define J-15-0 (token-node (token "*v" 'SpineJoin 15 0) (box-immutable TERM-16-0)))
(define J-15-1 (token-node (token "*v" 'SpineJoin 15 1) (box-immutable TERM-16-0)))
(define NULL-14-0 (token-node (token "*" 'NullInterpretation 14 0) (box-immutable J-15-0)))
(define J-14-1 (token-node (token "*v" 'SpineJoin 14 1) (box-immutable J-15-1)))
(define J-14-2 (token-node (token "*v" 'SpineJoin 14 2) (box-immutable J-15-1)))
(define 4c-13-0 (token-node (token "4c" 'SpineData 13 0) (box-immutable NULL-14-0)))
(define 4c-13-1 (token-node (token "4c" 'SpineData 13 1) (box-immutable J-14-1)))
(define 4c-13-2 (token-node (token "4c" 'SpineData 13 2) (box-immutable J-14-2)))
(define 4c-12-0 (token-node (token "4c" 'SpineData 12 0) (box-immutable 4c-13-0)))
(define 4c-12-1 (token-node (token "4c" 'SpineData 12 1) (box-immutable 4c-13-1)))
(define 4c-12-2 (token-node (token "4c" 'SpineData 12 2) (box-immutable 4c-13-2)))
(define 4c-11-0 (token-node (token "4c" 'SpineData 11 0) (box-immutable 4c-12-0)))
(define 4c-11-1 (token-node (token "4c" 'SpineData 11 1) (box-immutable 4c-12-1)))
(define 4c-11-2 (token-node (token "4c" 'SpineData 11 2) (box-immutable 4c-12-2)))
(define J-10-0 (token-node (token "*v" 'SpineJoin 10 0) (box-immutable 4c-11-0)))
(define J-10-1 (token-node (token "*v" 'SpineJoin 10 1) (box-immutable 4c-11-0)))
(define S-10-2 (split-node (token "*^" 'SpineSplit 10 2) (box-immutable 4c-11-1)
                                                         (box-immutable 4c-11-2)))
(define 4c-9-0 (token-node (token "4c" 'SpineData 9 0) (box-immutable J-10-0)))
(define 4c-9-1 (token-node (token "4c" 'SpineData 9 1) (box-immutable J-10-1)))
(define 4c-9-2 (token-node (token "4c" 'SpineData 9 2) (box-immutable S-10-2)))
(define 4c-8-0 (token-node (token "4c" 'SpineData 8 0) (box-immutable 4c-9-0)))
(define 4c-8-1 (token-node (token "4c" 'SpineData 8 1) (box-immutable 4c-9-1)))
(define 4c-8-2 (token-node (token "4c" 'SpineData 8 2) (box-immutable 4c-9-2)))
(define 4c-7-0 (token-node (token "4c" 'SpineData 7 0) (box-immutable 4c-8-0)))
(define 4c-7-1 (token-node (token "4c" 'SpineData 7 1) (box-immutable 4c-8-1)))
(define 4c-7-2 (token-node (token "4c" 'SpineData 7 2) (box-immutable 4c-8-2)))
(define S-6-0 (split-node (token "*^" 'SpineSplit 6 0) (box-immutable 4c-7-0)
                                                       (box-immutable 4c-7-1)))
(define J-6-1 (token-node (token "*v" 'SpineJoin 6 1) (box-immutable 4c-7-2)))
(define J-6-2 (token-node (token "*v" 'SpineJoin 6 2) (box-immutable 4c-7-2)))
(define 4c-5-0 (token-node (token "4c" 'SpineData 5 0) (box-immutable S-6-0)))
(define 4c-5-1 (token-node (token "4c" 'SpineData 5 1) (box-immutable J-6-1)))
(define 4c-5-2 (token-node (token "4c" 'SpineData 5 2) (box-immutable J-6-2)))
(define 4c-4-0 (token-node (token "4c" 'SpineData 4 0) (box-immutable 4c-5-0)))
(define 4c-4-1 (token-node (token "4c" 'SpineData 4 1) (box-immutable 4c-5-1)))
(define 4c-4-2 (token-node (token "4c" 'SpineData 4 2) (box-immutable 4c-5-2)))
(define 4c-3-0 (token-node (token "4c" 'SpineData 3 0) (box-immutable 4c-4-0)))
(define 4c-3-1 (token-node (token "4c" 'SpineData 3 1) (box-immutable 4c-4-1)))
(define 4c-3-2 (token-node (token "4c" 'SpineData 3 2) (box-immutable 4c-4-2)))
(define N-2-0 (token-node (token "*" 'NullInterpretation 2 0) (box-immutable 4c-3-0)))
(define S-2-1 (split-node (token "*^" 'SpineSplit 2 1) (box-immutable 4c-3-1)
                                                       (box-immutable 4c-3-2)))
(define S-1-0 (split-node (token "*^" 'SpineSplit 1 0) (box-immutable N-2-0)
                                                       (box-immutable S-2-1)))
(define KERN-0-0 (token-node (token "**kern" 'ExclusiveInterpretation 0 0)
                             (box-immutable S-1-0)))

(check-expect (path->hfile "../../data/order/spine-splits-and-joins-a.krn")
              (hfile (list (record "**kern"
                                   'ExclusiveInterpretation
                                   (list (token "**kern" 'ExclusiveInterpretation 0 0))
                                   0)
                           (record "*^" 'TandemInterpretation (list (token "*^" 'SpineSplit 1 0)) 1)
                           (record "*\t*^"
                                   'TandemInterpretation
                                   (list (token "*" 'NullInterpretation 2 0)
                                         (token "*^" 'SpineSplit 2 1))
                                   2)
                           (record "4c\t4c\t4c"
                                   'Token
                                   (list (token "4c" 'SpineData 3 0)
                                         (token "4c" 'SpineData 3 1)
                                         (token "4c" 'SpineData 3 2))
                                   3)
                           (record "4c\t4c\t4c"
                                   'Token
                                   (list (token "4c" 'SpineData 4 0)
                                         (token "4c" 'SpineData 4 1)
                                         (token "4c" 'SpineData 4 2))
                                   4)
                           (record "4c\t4c\t4c"
                                   'Token
                                   (list (token "4c" 'SpineData 5 0)
                                         (token "4c" 'SpineData 5 1)
                                         (token "4c" 'SpineData 5 2))
                                   5)
                           (record "*^\t*v\t*v"
                                   'TandemInterpretation
                                   (list (token "*^" 'SpineSplit 6 0)
                                         (token "*v" 'SpineJoin 6 1)
                                         (token "*v" 'SpineJoin 6 2))
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
                           (record "*v\t*v\t*^"
                                   'TandemInterpretation
                                   (list (token "*v" 'SpineJoin 10 0)
                                         (token "*v" 'SpineJoin 10 1)
                                         (token "*^" 'SpineSplit 10 2))
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
                           (record "*\t*v\t*v"
                                   'TandemInterpretation
                                   (list (token "*" 'NullInterpretation 14 0)
                                         (token "*v" 'SpineJoin 14 1)
                                         (token "*v" 'SpineJoin 14 2))
                                   14)
                           (record "*v\t*v"
                                   'TandemInterpretation
                                   (list (token "*v" 'SpineJoin 15 0)
                                         (token "*v" 'SpineJoin 15 1))
                                   15)
                           (record "*-" 'TandemInterpretation (list (token "*-" 'SpineTerminator 16 0)) 16))))
(check-expect (spine-parser (path->hfile "../../data/order/spine-splits-and-joins-a.krn"))
              (list (global-spine 'Kern
                                  (list  (list (token "**kern" 'ExclusiveInterpretation 0 0))
                                         (list (token "*^" 'SpineSplit 1 0))
                                         (list (token "*" 'NullInterpretation 2 0)
                                               (token "*^" 'SpineSplit 2 1))
                                         (list (token "4c" 'SpineData 3 0)
                                               (token "4c" 'SpineData 3 1)
                                               (token "4c" 'SpineData 3 2))
                                         (list (token "4c" 'SpineData 4 0)
                                               (token "4c" 'SpineData 4 1)
                                               (token "4c" 'SpineData 4 2))
                                         (list (token "4c" 'SpineData 5 0)
                                               (token "4c" 'SpineData 5 1)
                                               (token "4c" 'SpineData 5 2))
                                         (list (token "*^" 'SpineSplit 6 0)
                                               (token "*v" 'SpineJoin 6 1)
                                               (token "*v" 'SpineJoin 6 2))
                                         (list (token "4c" 'SpineData 7 0)
                                               (token "4c" 'SpineData 7 1)
                                               (token "4c" 'SpineData 7 2))
                                         (list (token "4c" 'SpineData 8 0)
                                               (token "4c" 'SpineData 8 1)
                                               (token "4c" 'SpineData 8 2))
                                         (list (token "4c" 'SpineData 9 0)
                                               (token "4c" 'SpineData 9 1)
                                               (token "4c" 'SpineData 9 2))
                                         (list (token "*v" 'SpineJoin 10 0)
                                               (token "*v" 'SpineJoin 10 1)
                                               (token "*^" 'SpineSplit 10 2))
                                         (list (token "4c" 'SpineData 11 0)
                                               (token "4c" 'SpineData 11 1)
                                               (token "4c" 'SpineData 11 2))
                                         (list (token "4c" 'SpineData 12 0)
                                               (token "4c" 'SpineData 12 1)
                                               (token "4c" 'SpineData 12 2))
                                         (list (token "4c" 'SpineData 13 0)
                                               (token "4c" 'SpineData 13 1)
                                               (token "4c" 'SpineData 13 2))
                                         (list (token "*" 'NullInterpretation 14 0)
                                               (token "*v" 'SpineJoin 14 1)
                                               (token "*v" 'SpineJoin 14 2))
                                         (list (token "*v" 'SpineJoin 15 0)
                                               (token "*v" 'SpineJoin 15 1))
                                         (list (token "*-" 'SpineTerminator 16 0)))
                                  0)))
#|
(check-expect (hgraph->hfile ) )
|#
#|
(check-expect (tokens->records ) )
|#
#|
(check-expect (hgraph->tokens ) )
|#
#|
(check-expect (hfile->hgraph ) )
|#
(check-expect (gspines->linked-spines (spine-parser
                                        (path->hfile "../../data/order/spine-splits-and-joins-a.krn"))
                                      (path->hfile "../../data/order/spine-splits-and-joins-a.krn"))
              (list (linked-spine KERN-0-0)))
(check-expect (extract-spine-arity (path->hfile "../../data/order/spine-splits-and-joins-a.krn"))
              (spine-arity 1 (list (list 1)
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
