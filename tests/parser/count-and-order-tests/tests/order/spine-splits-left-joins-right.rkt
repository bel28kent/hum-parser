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

;; Node definitions
(define TERM-8-0 (terminator-node (token "*-" 'SpineTerminator 8 0)))
(define J-7-0 (token-node (token "*v" 'SpineJoin 7 0) (box-immutable TERM-8-0)))
(define J-7-1 (token-node (token "*v" 'SpineJoin 7 1) (box-immutable TERM-8-0)))
(define NULL-6-0 (token-node (token "*" 'NullInterpretation 6 0) (box-immutable J-7-0)))
(define J-6-1 (token-node (token "*v" 'SpineJoin 6 1) (box-immutable J-7-1)))
(define J-6-2 (token-node (token "*v" 'SpineJoin 6 2) (box-immutable J-7-1)))
(define 4c-5-0 (token-node (token "4c" 'SpineData 5 0) (box-immutable NULL-6-0)))
(define 4c-5-1 (token-node (token "4c" 'SpineData 5 1) (box-immutable J-6-1)))
(define 4c-5-2 (token-node (token "4c" 'SpineData 5 2) (box-immutable J-6-2)))
(define 4c-4-0 (token-node (token "4c" 'SpineData 4 0) (box-immutable 4c-5-0)))
(define 4c-4-1 (token-node (token "4c" 'SpineData 4 1) (box-immutable 4c-5-1)))
(define 4c-4-2 (token-node (token "4c" 'SpineData 4 2) (box-immutable 4c-5-2)))
(define 4c-3-0 (token-node (token "4c" 'SpineData 3 0) (box-immutable 4c-4-0)))
(define 4c-3-1 (token-node (token "4c" 'SpineData 3 1) (box-immutable 4c-4-1)))
(define 4c-3-2 (token-node (token "4c" 'SpineData 3 2) (box-immutable 4c-4-2)))
(define S-2-0 (split-node (token "*^" 'SpineSplit 2 0)
                          (box-immutable 4c-3-0)
                          (box-immutable 4c-3-1)))
(define NULL-2-1 (token-node (token "*" 'NullInterpretation 2 1) (box-immutable 4c-3-2)))
(define S-1-0 (split-node (token "*^" 'SpineSplit 1 0)
                          (box-immutable S-2-0)
                          (box-immutable NULL-2-1)))
(define KERN-0-0 (token-node (token "**kern" 'ExclusiveInterpretation 0 0) (box-immutable S-1-0)))

(check-expect (path->hfile "../../data/order/spine-splits-left-joins-right.krn")
              (hfile (list (record "**kern" 'ExclusiveInterpretation
                                   (list (token "**kern" 'ExclusiveInterpretation 0 0))
                                   0)
                           (record "*^" 'TandemInterpretation
                                   (list (token "*^" 'SpineSplit 1 0))
                                   1)
                           (record "*^\t*" 'TandemInterpretation
                                   (list (token "*^" 'SpineSplit 2 0)
                                         (token "*" 'NullInterpretation 2 1))
                                   2)
                           (record "4c\t4c\t4c" 'Token
                                   (list (token "4c" 'SpineData 3 0)
                                         (token "4c" 'SpineData 3 1)
                                         (token "4c" 'SpineData 3 2))
                                   3)
                           (record "4c\t4c\t4c" 'Token
                                   (list (token "4c" 'SpineData 4 0)
                                         (token "4c" 'SpineData 4 1)
                                         (token "4c" 'SpineData 4 2))
                                   4)
                           (record "4c\t4c\t4c" 'Token
                                   (list (token "4c" 'SpineData 5 0)
                                         (token "4c" 'SpineData 5 1)
                                         (token "4c" 'SpineData 5 2))
                                   5)
                           (record "*\t*v\t*v" 'TandemInterpretation
                                   (list (token "*" 'NullInterpretation 6 0)
                                         (token "*v" 'SpineJoin 6 1)
                                         (token "*v" 'SpineJoin 6 2))
                                   6)
                           (record "*v\t*v" 'TandemInterpretation
                                   (list (token "*v" 'SpineJoin 7 0)
                                         (token "*v" 'SpineJoin 7 1))
                                   7)
                           (record "*-" 'TandemInterpretation
                                   (list (token "*-" 'SpineTerminator 8 0))
                                   8))))
(check-expect (spine-parser (path->hfile "../../data/order/spine-splits-left-joins-right.krn"))
              (list (global-spine 'Kern
                                  (list (list (token "**kern" 'ExclusiveInterpretation 0 0))
                                        (list (token "*^" 'SpineSplit 1 0))
                                        (list (token "*^" 'SpineSplit 2 0)
                                              (token "*" 'NullInterpretation 2 1))
                                        (list (token "4c" 'SpineData 3 0)
                                              (token "4c" 'SpineData 3 1)
                                              (token "4c" 'SpineData 3 2))
                                        (list (token "4c" 'SpineData 4 0)
                                              (token "4c" 'SpineData 4 1)
                                              (token "4c" 'SpineData 4 2))
                                        (list (token "4c" 'SpineData 5 0)
                                              (token "4c" 'SpineData 5 1)
                                              (token "4c" 'SpineData 5 2))
                                        (list (token "*" 'NullInterpretation 6 0)
                                              (token "*v" 'SpineJoin 6 1)
                                              (token "*v" 'SpineJoin 6 2))
                                        (list (token "*v" 'SpineJoin 7 0)
                                              (token "*v" 'SpineJoin 7 1))
                                        (list (token "*-" 'SpineTerminator 8 0)))
                                  0)))
(check-expect (hgraph->hfile
               (hgraph (root (list (list (leaf (token  "**kern" 'ExclusiveInterpretation 0 0))
                                            (parent (token  "*^" 'SpineSplit 1 0)
                                                    (list (parent (token  "*^" 'SpineSplit 2 0)
                                                                  (list (leaf (token  "4c" 'SpineData 3 0))
                                                                        (leaf (token  "4c" 'SpineData 4 0))
                                                                        (leaf (token  "4c" 'SpineData 5 0))
                                                                        (leaf (token  "*" 'NullInterpretation 6 0))
                                                                        (leaf (token  "*v" 'SpineJoin 7 0)))
                                                                  (list (leaf (token  "4c" 'SpineData 3 1))
                                                                        (leaf (token  "4c" 'SpineData 4 1))
                                                                        (leaf (token  "4c" 'SpineData 5 1))
                                                                        (leaf (token  "*v" 'SpineJoin 6 1))))
                                                          (leaf (token  "*v" 'SpineJoin 7 0)))
                                                    (list (leaf (token  "*" 'NullInterpretation 2 1))
                                                          (leaf (token  "4c" 'SpineData 3 2))
                                                          (leaf (token  "4c" 'SpineData 4 2))
                                                          (leaf (token  "4c" 'SpineData 5 2))
                                                          (leaf (token  "*v" 'SpineJoin 6 2))))
                                            (leaf (token  "*-" 'SpineTerminator 8 0)))))))
              (path->hfile "../../data/order/spine-splits-left-joins-right.krn"))
(check-expect (tokens->records (list (list (token "**kern" 'ExclusiveInterpretation 0 0))
                                (list (token "*^" 'SpineSplit 1 0))
                                (list (token "*^" 'SpineSplit 2 0)
                                      (token "*" 'NullInterpretation 2 1))
                                (list (token "4c" 'SpineData 3 0)
                                      (token "4c" 'SpineData 3 1)
                                      (token "4c" 'SpineData 3 2))
                                (list (token "4c" 'SpineData 4 0)
                                      (token "4c" 'SpineData 4 1)
                                      (token "4c" 'SpineData 4 2))
                                (list (token "4c" 'SpineData 5 0)
                                      (token "4c" 'SpineData 5 1)
                                      (token "4c" 'SpineData 5 2))
                                (list (token "*" 'NullInterpretation 6 0)
                                      (token "*v" 'SpineJoin 6 1)
                                      (token "*v" 'SpineJoin 6 2))
                                (list (token "*v" 'SpineJoin 7 0)
                                      (token "*v" 'SpineJoin 7 1))
                                (list (token "*-" 'SpineTerminator 8 0))))
              (list (record "**kern" 'ExclusiveInterpretation
                            (list (token "**kern" 'ExclusiveInterpretation 0 0))
                            0)
                    (record "*^" 'TandemInterpretation
                            (list (token "*^" 'SpineSplit 1 0))
                            1)
                    (record "*^\t*" 'TandemInterpretation
                            (list (token "*^" 'SpineSplit 2 0)
                                  (token "*" 'NullInterpretation 2 1))
                            2)
                    (record "4c\t4c\t4c" 'Token
                            (list (token "4c" 'SpineData 3 0)
                                  (token "4c" 'SpineData 3 1)
                                  (token "4c" 'SpineData 3 2))
                            3)
                    (record "4c\t4c\t4c" 'Token
                            (list (token "4c" 'SpineData 4 0)
                                  (token "4c" 'SpineData 4 1)
                                  (token "4c" 'SpineData 4 2))
                            4)
                    (record "4c\t4c\t4c" 'Token
                            (list (token "4c" 'SpineData 5 0)
                                  (token "4c" 'SpineData 5 1)
                                  (token "4c" 'SpineData 5 2))
                            5)
                    (record "*\t*v\t*v" 'TandemInterpretation
                            (list (token "*" 'NullInterpretation 6 0)
                                  (token "*v" 'SpineJoin 6 1)
                                  (token "*v" 'SpineJoin 6 2))
                            6)
                    (record "*v\t*v" 'TandemInterpretation
                            (list (token "*v" 'SpineJoin 7 0)
                                  (token "*v" 'SpineJoin 7 1))
                            7)
                    (record "*-" 'TandemInterpretation
                            (list (token "*-" 'SpineTerminator 8 0))
                            8)))
(check-expect (hgraph->tokens
               (hgraph (root (list (list (leaf (token  "**kern" 'ExclusiveInterpretation 0 0))
                                            (parent (token  "*^" 'SpineSplit 1 0)
                                                    (list (parent (token  "*^" 'SpineSplit 2 0)
                                                                  (list (leaf (token  "4c" 'SpineData 3 0))
                                                                        (leaf (token  "4c" 'SpineData 4 0))
                                                                        (leaf (token  "4c" 'SpineData 5 0))
                                                                        (leaf (token  "*" 'NullInterpretation 6 0))
                                                                        (leaf (token  "*v" 'SpineJoin 7 0)))
                                                                  (list (leaf (token  "4c" 'SpineData 3 1))
                                                                        (leaf (token  "4c" 'SpineData 4 1))
                                                                        (leaf (token  "4c" 'SpineData 5 1))
                                                                        (leaf (token  "*v" 'SpineJoin 6 1))))
                                                          (leaf (token  "*v" 'SpineJoin 7 0)))
                                                    (list (leaf (token  "*" 'NullInterpretation 2 1))
                                                          (leaf (token  "4c" 'SpineData 3 2))
                                                          (leaf (token  "4c" 'SpineData 4 2))
                                                          (leaf (token  "4c" 'SpineData 5 2))
                                                          (leaf (token  "*v" 'SpineJoin 6 2))))
                                            (leaf (token  "*-" 'SpineTerminator 8 0)))))))
              (list (list (token "**kern" 'ExclusiveInterpretation 0 0))
                    (list (token "*^" 'SpineSplit 1 0))
                    (list (token "*^" 'SpineSplit 2 0)
                          (token "*" 'NullInterpretation 2 1))
                    (list (token "4c" 'SpineData 3 0)
                          (token "4c" 'SpineData 3 1)
                          (token "4c" 'SpineData 3 2))
                    (list (token "4c" 'SpineData 4 0)
                          (token "4c" 'SpineData 4 1)
                          (token "4c" 'SpineData 4 2))
                    (list (token "4c" 'SpineData 5 0)
                          (token "4c" 'SpineData 5 1)
                          (token "4c" 'SpineData 5 2))
                    (list (token "*" 'NullInterpretation 6 0)
                          (token "*v" 'SpineJoin 6 1)
                          (token "*v" 'SpineJoin 6 2))
                    (list (token "*v" 'SpineJoin 7 0)
                          (token "*v" 'SpineJoin 7 1))
                    (list (token "*-" 'SpineTerminator 8 0))))
(check-expect (hfile->hgraph (path->hfile "../../data/order/spine-splits-left-joins-right.krn"))
              (hgraph (root (list (list (leaf (token  "**kern" 'ExclusiveInterpretation 0 0))
                                           (parent (token  "*^" 'SpineSplit 1 0)
                                                   (list (parent (token  "*^" 'SpineSplit 2 0)
                                                                 (list (leaf (token  "4c" 'SpineData 3 0))
                                                                       (leaf (token  "4c" 'SpineData 4 0))
                                                                       (leaf (token  "4c" 'SpineData 5 0))
                                                                       (leaf (token  "*" 'NullInterpretation 6 0))
                                                                       (leaf (token  "*v" 'SpineJoin 7 0)))
                                                                 (list (leaf (token  "4c" 'SpineData 3 1))
                                                                       (leaf (token  "4c" 'SpineData 4 1))
                                                                       (leaf (token  "4c" 'SpineData 5 1))
                                                                       (leaf (token  "*v" 'SpineJoin 6 1))))
                                                         (leaf (token  "*v" 'SpineJoin 7 0)))
                                                   (list (leaf (token  "*" 'NullInterpretation 2 1))
                                                         (leaf (token  "4c" 'SpineData 3 2))
                                                         (leaf (token  "4c" 'SpineData 4 2))
                                                         (leaf (token  "4c" 'SpineData 5 2))
                                                         (leaf (token  "*v" 'SpineJoin 6 2))))
                                           (leaf (token  "*-" 'SpineTerminator 8 0)))))))
(check-expect (gspines->linked-spines (spine-parser (path->hfile "../../data/order/spine-splits-left-joins-right.krn"))
                                      (path->hfile "../../data/order/spine-splits-left-joins-right.krn"))
              (list (linked-spine KERN-0-0)))
(check-expect (extract-spine-arity (path->hfile "../../data/order/spine-splits-left-joins-right.krn"))
              (spine-arity 1 (list (list 1)
                                   (list 1)
                                   (list 2)
                                   (list 3)
                                   (list 3)
                                   (list 3)
                                   (list 3)
                                   (list 2)
                                   (list 1))))

(test)
