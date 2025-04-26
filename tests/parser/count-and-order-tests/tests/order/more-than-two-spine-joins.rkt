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
(define TERM-7-0 (terminator-node (token "*-" 'SpineTerminator 7 0)))
(define J-6-0 (token-node (token "*v" 'SpineJoin 6 0) (box-immutable TERM-7-0)))
(define J-6-1 (token-node (token "*v" 'SpineJoin 6 1) (box-immutable TERM-7-0)))
(define J-6-2 (token-node (token "*v" 'SpineJoin 6 2) (box-immutable TERM-7-0)))
(define 4c-5-0 (token-node (token "4c" 'SpineData 5 0) (box-immutable J-6-0)))
(define 4c-5-1 (token-node (token "4c" 'SpineData 5 1) (box-immutable J-6-1)))
(define 4c-5-2 (token-node (token "4c" 'SpineData 5 2) (box-immutable J-6-2)))
(define 4c-4-0 (token-node (token "4c" 'SpineData 4 0) (box-immutable 4c-5-0)))
(define 4c-4-1 (token-node (token "4c" 'SpineData 4 1) (box-immutable 4c-5-1)))
(define 4c-4-2 (token-node (token "4c" 'SpineData 4 2) (box-immutable 4c-5-2)))
(define 4c-3-0 (token-node (token "4c" 'SpineData 3 0) (box-immutable 4c-4-0)))
(define 4c-3-1 (token-node (token "4c" 'SpineData 3 1) (box-immutable 4c-4-1)))
(define 4c-3-2 (token-node (token "4c" 'SpineData 3 2) (box-immutable 4c-4-2)))
(define NULL-2-0 (token-node (token "*" 'NullInterpretation 2 0) (box-immutable 4c-3-0)))
(define SPLIT-2-1 (split-node (token "*^" 'SpineSplit 2 1)
                              (box-immutable 4c-3-1)
                              (box-immutable 4c-3-2)))
(define SPLIT-1-0 (split-node (token "*^" 'SpineSplit 1 0)
                              (box-immutable NULL-2-0)
                              (box-immutable SPLIT-2-1)))
(define KERN-0-0 (token-node (token "**kern" 'ExclusiveInterpretation 0 0)
                             (box-immutable SPLIT-1-0)))


(check-expect (path->hfile "../../data/order/more-than-two-spine-joins.krn")
              (hfile (list (record "**kern"
                                   TOKEN
                                   (list (token "**kern" 'ExclusiveInterpretation 0 0))
                                   0)
                           (record "*^" TOKEN (list (token "*^" 'SpineSplit 1 0)) 1)
                           (record "*\t*^"
                                   TOKEN
                                   (list (token "*" 'NullInterpretation 2 0)
                                         (token "*^" 'SpineSplit 2 1))
                                   2)
                           (record "4c\t4c\t4c"
                                   TOKEN
                                   (list (token "4c" 'SpineData 3 0)
                                         (token "4c" 'SpineData 3 1)
                                         (token "4c" 'SpineData 3 2))
                                   3)
                           (record "4c\t4c\t4c"
                                   TOKEN
                                   (list (token "4c" 'SpineData 4 0)
                                         (token "4c" 'SpineData 4 1)
                                         (token "4c" 'SpineData 4 2))
                                   4)
                           (record "4c\t4c\t4c"
                                   TOKEN
                                   (list (token "4c" 'SpineData 5 0)
                                         (token "4c" 'SpineData 5 1)
                                         (token "4c" 'SpineData 5 2))
                                   5)
                           (record "*v\t*v\t*v"
                                   TOKEN
                                   (list (token "*v" 'SpineJoin 6 0)
                                         (token "*v" 'SpineJoin 6 1)
                                         (token "*v" 'SpineJoin 6 2))
                                   6)
                           (record "*-" TOKEN (list (token "*-" 'SpineTerminator 7 0)) 7))))
(check-expect (spine-parser (path->hfile "../../data/order/more-than-two-spine-joins.krn"))
              (list (global-spine KERN
                                  (list (list (token "**kern" 'ExclusiveInterpretation 0 0))
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
                                        (list (token "*v" 'SpineJoin 6 0)
                                              (token "*v" 'SpineJoin 6 1)
                                              (token "*v" 'SpineJoin 6 2))
                                        (list (token "*-" 'SpineTerminator 7 0)))
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
(check-expect (gspines->linked-spines (spine-parser
                                        (path->hfile "../../data/order/more-than-two-spine-joins.krn"))
                                      (path->hfile "../../data/order/more-than-two-spine-joins.krn"))
              (list (linked-spine KERN-0-0)))
(check-expect (extract-spine-arity 3-J) (spine-arity 1 (list (list 1)
                                                             (list 1)
                                                             (list 2)
                                                             (list 3)
                                                             (list 3)
                                                             (list 3)
                                                             (list 3)
                                                             (list 1))))

(test)
