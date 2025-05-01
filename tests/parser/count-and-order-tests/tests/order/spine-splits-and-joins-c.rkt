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
(define TERM-12-0 (terminator-node (token "*-" 'SpineTerminator 12 0)))
(define J-11-0 (token-node (token "*v" 'SpineJoin 11 0) (box-immutable TERM-12-0)))
(define J-11-1 (token-node (token "*v" 'SpineJoin 11 1) (box-immutable TERM-12-0)))
(define NULL-10-0 (token-node (token "*" 'NullInterpretation 10 0) (box-immutable J-11-0)))
(define J-10-1 (token-node (token "*v" 'SpineJoin 10 1) (box-immutable J-11-1)))
(define J-10-2 (token-node (token "*v" 'SpineJoin 10 2) (box-immutable J-11-1)))
(define 4c-9-0 (token-node (token "4c" 'SpineData 9 0) (box-immutable NULL-10-0)))
(define 4c-9-1 (token-node (token "4c" 'SpineData 9 1) (box-immutable J-10-1)))
(define 4c-9-2 (token-node (token "4c" 'SpineData 9 2) (box-immutable J-10-2)))
(define 4c-8-0 (token-node (token "4c" 'SpineData 8 0) (box-immutable 4c-9-0)))
(define 4c-8-1 (token-node (token "4c" 'SpineData 8 1) (box-immutable 4c-9-1)))
(define 4c-8-2 (token-node (token "4c" 'SpineData 8 2) (box-immutable 4c-9-2)))
(define 4c-7-0 (token-node (token "4c" 'SpineData 7 0) (box-immutable 4c-8-0)))
(define 4c-7-1 (token-node (token "4c" 'SpineData 7 1) (box-immutable 4c-8-1)))
(define 4c-7-2 (token-node (token "4c" 'SpineData 7 2) (box-immutable 4c-8-2)))
(define S-6-0 (split-node (token "*^" 'SpineSplit 6 0)
                          (box-immutable 4c-7-0)
                          (box-immutable 4c-7-1)))
(define NULL-6-1 (token-node (token "*" 'NullInterpretation 6 1) (box-immutable 4c-7-2)))
(define 4c-5-0 (token-node (token "4c" 'SpineData 5 0) (box-immutable S-6-0)))
(define 4c-5-1 (token-node (token "4c" 'SpineData 5 1) (box-immutable NULL-6-1)))
(define 4c-4-0 (token-node (token "4c" 'SpineData 4 0) (box-immutable 4c-5-0)))
(define 4c-4-1 (token-node (token "4c" 'SpineData 4 1) (box-immutable 4c-5-1)))
(define 4c-3-0 (token-node (token "4c" 'SpineData 3 0) (box-immutable 4c-4-0)))
(define 4c-3-1 (token-node (token "4c" 'SpineData 3 1) (box-immutable 4c-4-1)))
(define NULL-2-0 (token-node (token "*" 'NullInterpretation 2 0) (box-immutable 4c-3-0)))
(define NULL-2-1 (token-node (token "*" 'NullInterpretation 2 1) (box-immutable 4c-3-1)))
(define S-1-0 (split-node (token "*^" 'SpineSplit 1 0)
                          (box-immutable NULL-2-0)
                          (box-immutable NULL-2-1)))
(define KERN-0-0 (token-node (token "**kern" 'ExclusiveInterpretation 0 0) (box-immutable S-1-0)))

(define TERM-12-1 (terminator-node (token "*-" 'SpineTerminator 12 1)))
(define NULL-11-2 (token-node (token "*" 'NullInterpretation 11 2) (box-immutable TERM-12-1)))
(define NULL-10-3 (token-node (token "*" 'NullInterpretation 10 3) (box-immutable NULL-11-2)))
(define 4c-9-3 (token-node (token "4c" 'SpineData 9 3) (box-immutable NULL-10-3)))
(define 4c-8-3 (token-node (token "4c" 'SpineData 8 3) (box-immutable 4c-9-3)))
(define 4c-7-3 (token-node (token "4c" 'SpineData 7 3) (box-immutable 4c-8-3)))
(define J-6-2 (token-node (token "*v" 'SpineJoin 6 2) (box-immutable 4c-7-3)))
(define J-6-3 (token-node (token "*v" 'SpineJoin 6 3) (box-immutable 4c-7-3)))
(define J-6-4 (token-node (token "*v" 'SpineJoin 6 4) (box-immutable 4c-7-3)))
(define 4c-5-2 (token-node (token "4c" 'SpineData 5 2) (box-immutable J-6-2)))
(define 4c-5-3 (token-node (token "4c" 'SpineData 5 3) (box-immutable J-6-3)))
(define 4c-5-4 (token-node (token "4c" 'SpineData 5 4) (box-immutable J-6-4)))
(define 4c-4-2 (token-node (token "4c" 'SpineData 4 2) (box-immutable 4c-5-2)))
(define 4c-4-3 (token-node (token "4c" 'SpineData 4 3) (box-immutable 4c-5-3)))
(define 4c-4-4 (token-node (token "4c" 'SpineData 4 4) (box-immutable 4c-5-4)))
(define 4c-3-2 (token-node (token "4c" 'SpineData 3 2) (box-immutable 4c-4-2)))
(define 4c-3-3 (token-node (token "4c" 'SpineData 3 3) (box-immutable 4c-4-3)))
(define 4c-3-4 (token-node (token "4c" 'SpineData 3 4) (box-immutable 4c-4-4)))
(define S-2-2 (split-node (token "*^" 'SpineSplit 2 2)
                          (box-immutable 4c-3-2)
                          (box-immutable 4c-3-3)))
(define NULL-2-3 (token-node (token "*" 'NullInterpretation 2 3) (box-immutable 4c-3-4)))
(define S-1-1 (split-node (token "*^" 'SpineSplit 1 1)
                          (box-immutable S-2-2)
                          (box-immutable NULL-2-3)))
(define KERN-0-1 (token-node (token "**kern" 'ExclusiveInterpretation 0 1) (box-immutable S-1-1)))

(check-expect (path->hfile "../../data/order/spine-splits-and-joins-c.krn")
              (hfile (list (record "**kern\t**kern"
                                   'ExclusiveInterpretation
                                   (list (token "**kern" 'ExclusiveInterpretation 0 0)
                                         (token "**kern" 'ExclusiveInterpretation 0 1))
                                   0)
                           (record "*^\t*^"
                                   'TandemInterpretation
                                   (list (token "*^" 'SpineSplit 1 0)
                                         (token "*^" 'SpineSplit 1 1))
                                   1)
                           (record "*\t*\t*^\t*"
                                   'TandemInterpretation
                                   (list (token "*" 'NullInterpretation 2 0)
                                         (token "*" 'NullInterpretation 2 1)
                                         (token "*^" 'SpineSplit 2 2)
                                         (token "*" 'NullInterpretation 2 3))
                                   2)
                           (record "4c\t4c\t4c\t4c\t4c"
                                   'Token
                                   (list (token "4c" 'SpineData 3 0)
                                         (token "4c" 'SpineData 3 1)
                                         (token "4c" 'SpineData 3 2)
                                         (token "4c" 'SpineData 3 3)
                                         (token "4c" 'SpineData 3 4))
                                   3)
                           (record "4c\t4c\t4c\t4c\t4c"
                                   'Token
                                   (list (token "4c" 'SpineData 4 0)
                                         (token "4c" 'SpineData 4 1)
                                         (token "4c" 'SpineData 4 2)
                                         (token "4c" 'SpineData 4 3)
                                         (token "4c" 'SpineData 4 4))
                                   4)
                           (record "4c\t4c\t4c\t4c\t4c"
                                   'Token
                                   (list (token "4c" 'SpineData 5 0)
                                         (token "4c" 'SpineData 5 1)
                                         (token "4c" 'SpineData 5 2)
                                         (token "4c" 'SpineData 5 3)
                                         (token "4c" 'SpineData 5 4))
                                   5)
                           (record "*^\t*\t*v\t*v\t*v"
                                   'TandemInterpretation
                                   (list (token "*^" 'SpineSplit 6 0)
                                         (token "*" 'NullInterpretation 6 1)
                                         (token "*v" 'SpineJoin 6 2)
                                         (token "*v" 'SpineJoin 6 3)
                                         (token "*v" 'SpineJoin 6 4))
                                   6)
                           (record "4c\t4c\t4c\t4c"
                                   'Token
                                   (list (token "4c" 'SpineData 7 0)
                                         (token "4c" 'SpineData 7 1)
                                         (token "4c" 'SpineData 7 2)
                                         (token "4c" 'SpineData 7 3))
                                   7)
                           (record "4c\t4c\t4c\t4c"
                                   'Token
                                   (list (token "4c" 'SpineData 8 0)
                                         (token "4c" 'SpineData 8 1)
                                         (token "4c" 'SpineData 8 2)
                                         (token "4c" 'SpineData 8 3))
                                   8)
                           (record "4c\t4c\t4c\t4c"
                                   'Token
                                   (list (token "4c" 'SpineData 9 0)
                                         (token "4c" 'SpineData 9 1)
                                         (token "4c" 'SpineData 9 2)
                                         (token "4c" 'SpineData 9 3))
                                   9)
                           (record "*\t*v\t*v\t*"
                                   'TandemInterpretation
                                   (list (token "*" 'NullInterpretation 10 0)
                                         (token "*v" 'SpineJoin 10 1)
                                         (token "*v" 'SpineJoin 10 2)
                                         (token "*" 'NullInterpretation 10 3))
                                   10)
                           (record "*v\t*v\t*"
                                   'TandemInterpretation
                                   (list (token "*v" 'SpineJoin 11 0)
                                         (token "*v" 'SpineJoin 11 1)
                                         (token "*" 'NullInterpretation 11 2))
                                   11)
                           (record "*-\t*-"
                                   'TandemInterpretation
                                   (list (token "*-" 'SpineTerminator 12 0)
                                         (token "*-" 'SpineTerminator 12 1))
                                   12))))
(check-expect (spine-parser (path->hfile "../../data/order/spine-splits-and-joins-c.krn"))
              (list (global-spine 'Kern
                                  (list (list (token "**kern" 'ExclusiveInterpretation 0 0))
                                        (list (token "*^" 'SpineSplit 1 0))
                                        (list (token "*" 'NullInterpretation 2 0)
                                              (token "*" 'NullInterpretation 2 1))
                                        (list (token "4c" 'SpineData 3 0)
                                              (token "4c" 'SpineData 3 1))
                                        (list (token "4c" 'SpineData 4 0)
                                              (token "4c" 'SpineData 4 1))
                                        (list (token "4c" 'SpineData 5 0)
                                              (token "4c" 'SpineData 5 1))
                                        (list (token "*^" 'SpineSplit 6 0)
                                              (token "*" 'NullInterpretation 6 1))
                                        (list (token "4c" 'SpineData 7 0)
                                              (token "4c" 'SpineData 7 1)
                                              (token "4c" 'SpineData 7 2))
                                        (list (token "4c" 'SpineData 8 0)
                                              (token "4c" 'SpineData 8 1)
                                              (token "4c" 'SpineData 8 2))
                                        (list (token "4c" 'SpineData 9 0)
                                              (token "4c" 'SpineData 9 1)
                                              (token "4c" 'SpineData 9 2))
                                        (list (token "*" 'NullInterpretation 10 0)
                                              (token "*v" 'SpineJoin 10 1)
                                              (token "*v" 'SpineJoin 10 2))
                                        (list (token "*v" 'SpineJoin 11 0)
                                              (token "*v" 'SpineJoin 11 1))
                                        (list (token "*-" 'SpineTerminator 12 0)))
                                  0)
                    (global-spine 'Kern
                                  (list (list (token "**kern" 'ExclusiveInterpretation 0 1))
                                        (list (token "*^" 'SpineSplit 1 1))
                                        (list (token "*^" 'SpineSplit 2 2)
                                              (token "*" 'NullInterpretation 2 3))
                                        (list (token "4c" 'SpineData 3 2)
                                              (token "4c" 'SpineData 3 3)
                                              (token "4c" 'SpineData 3 4))
                                        (list (token "4c" 'SpineData 4 2)
                                              (token "4c" 'SpineData 4 3)
                                              (token "4c" 'SpineData 4 4))
                                        (list (token "4c" 'SpineData 5 2)
                                              (token "4c" 'SpineData 5 3)
                                              (token "4c" 'SpineData 5 4))
                                        (list (token "*v" 'SpineJoin 6 2)
                                              (token "*v" 'SpineJoin 6 3)
                                              (token "*v" 'SpineJoin 6 4))
                                        (list (token "4c" 'SpineData 7 3))
                                        (list (token "4c" 'SpineData 8 3))
                                        (list (token "4c" 'SpineData 9 3))
                                        (list (token "*" 'NullInterpretation 10 3))
                                        (list (token "*" 'NullInterpretation 11 2))
                                        (list (token "*-" 'SpineTerminator 12 1)))
                                  1)))
#|
(check-expect(hgraph->hfile ) )
|#
#|
(check-expect(tokens->records ) )
|#
#|
(check-expect(hgraph->tokens ) )
|#
#|
(check-expect(hfile->hgraph ) )
|#
(check-expect (gspines->linked-spines (spine-parser (path->hfile "../../data/order/spine-splits-and-joins-c.krn"))
                                      (path->hfile "../../data/order/spine-splits-and-joins-c.krn"))
              (list (linked-spine KERN-0-0) (linked-spine KERN-0-1)))
(check-expect (extract-spine-arity (path->hfile "../../data/order/spine-splits-and-joins-c.krn"))
              (spine-arity 2 (list (list 1 1)
                                   (list 1 1)
                                   (list 2 2)
                                   (list 2 3)
                                   (list 2 3)
                                   (list 2 3)
                                   (list 2 3)
                                   (list 3 1)
                                   (list 3 1)
                                   (list 3 1)
                                   (list 3 1)
                                   (list 2 1)
                                   (list 1 1))))

(test)
