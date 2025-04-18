#lang racket/base

(require "../../../../parser/data-definitions/data-definitions.rkt"
         "../../../../parser/functions/file.rkt"
         "../../../../parser/functions/spine-parser.rkt"
         "../../../../parser/data-structures/humdrum-graph/data-definitions/data-definitions.rkt"
         "../../../../parser/data-structures/humdrum-graph/functions/hgraph-to-hfile.rkt"
         "../../../../parser/data-structures/humdrum-graph/functions/hfile-to-hgraph.rkt"
         "../../../../parser/data-structures/linked-spine/data-definitions/data-definitions.rkt"
         "../../../../parser/data-structures/linked-spine/functions/gspines-to-linked-spines.rkt"
         test-engine/racket-tests)

;; Node Definitions
(define TERM-6-0 (terminator-node (token "*-" SPINE-TERMINATOR 6 0)))
(define J-5-0 (token-node (token "*v" SPINE-JOIN 5 0) (box-immutable TERM-6-0)))
(define J-5-1 (token-node (token "*v" SPINE-JOIN 5 1) (box-immutable TERM-6-0)))
(define 4c-4-0 (token-node (token "4c" SPINE-DATA 4 0) (box-immutable J-5-0)))
(define 4c-4-1 (token-node (token "4c" SPINE-DATA 4 1) (box-immutable J-5-1)))
(define 4c-3-0 (token-node (token "4c" SPINE-DATA 3 0) (box-immutable 4c-4-0)))
(define 4c-3-1 (token-node (token "4c" SPINE-DATA 3 1) (box-immutable 4c-4-1)))
(define 4c-2-0 (token-node (token "4c" SPINE-DATA 2 0) (box-immutable 4c-3-0)))
(define 4c-2-1 (token-node (token "4c" SPINE-DATA 2 1) (box-immutable 4c-3-1)))
(define S-1-0 (split-node (token "*^" SPINE-SPLIT 1 0)
                          (box-immutable 4c-2-0)
                          (box-immutable 4c-2-1)))
(define KERN-0-0 (token-node (token "**kern" EXCLUSIVE-INTERPRETATION 0 0) (box-immutable S-1-0)))

(check-expect (path->hfile "../../data/order/spine-splits-joins-immediately.krn")
              (hfile (list (record "**kern"
                                   TOKEN
                                   (list (token "**kern" EXCLUSIVE-INTERPRETATION 0 0))
                                   0)
                           (record "*^" TOKEN (list (token "*^" SPINE-SPLIT 1 0)) 1)
                           (record "4c\t4c" TOKEN (list (token "4c" SPINE-DATA 2 0)
                                                        (token "4c" SPINE-DATA 2 1))
                                   2)
                           (record "4c\t4c" TOKEN (list (token "4c" SPINE-DATA 3 0)
                                                        (token "4c" SPINE-DATA 3 1))
                                   3)
                           (record "4c\t4c" TOKEN (list (token "4c" SPINE-DATA 4 0)
                                                        (token "4c" SPINE-DATA 4 1))
                                   4)
                           (record "*v\t*v" TOKEN (list (token "*v" SPINE-JOIN 5 0)
                                                        (token "*v" SPINE-JOIN 5 1))
                                   5)
                           (record "*-" TOKEN (list (token "*-" SPINE-TERMINATOR 6 0)) 6))))
(check-expect (spine-parser (path->hfile "../../data/order/spine-splits-joins-immediately.krn"))
              (list (global-spine KERN
                                  (list (list (token "**kern" EXCLUSIVE-INTERPRETATION 0 0))
                                        (list (token "*^" SPINE-SPLIT 1 0))
                                        (list (token "4c" SPINE-DATA 2 0)
                                              (token "4c" SPINE-DATA 2 1))
                                        (list (token "4c" SPINE-DATA 3 0)
                                              (token "4c" SPINE-DATA 3 1))
                                        (list (token "4c" SPINE-DATA 4 0)
                                              (token "4c" SPINE-DATA 4 1))
                                        (list (token "*v" SPINE-JOIN 5 0)
                                              (token "*v" SPINE-JOIN 5 1))
                                        (list (token "*-" SPINE-TERMINATOR 6 0)))
                                  0)))
(check-expect (hgraph->hfile (hgraph (root (list
                                            (list
                                             (leaf (token "**kern" EXCLUSIVE-INTERPRETATION 0 0))
                                             (parent (token "*^" SPINE-SPLIT 1 0)
                                                     (list (leaf (token "4c" SPINE-DATA 2 0))
                                                           (leaf (token "4c" SPINE-DATA 3 0))
                                                           (leaf (token "4c" SPINE-DATA 4 0))
                                                           (leaf (token "*v" SPINE-JOIN 5 0)))
                                                     (list (leaf (token "4c" SPINE-DATA 2 1))
                                                           (leaf (token "4c" SPINE-DATA 3 1))
                                                           (leaf (token "4c" SPINE-DATA 4 1))
                                                           (leaf (token "*v" SPINE-JOIN 5 1))))
                                             (leaf (token "*-" SPINE-TERMINATOR 6 0)))))))
              (path->hfile "../../data/order/spine-splits-joins-immediately.krn"))
(check-expect (lolot->lor (list (list (token "**kern" EXCLUSIVE-INTERPRETATION 0 0))
                                (list (token "*^" SPINE-SPLIT 1 0))
                                (list (token "4c" SPINE-DATA 2 0) (token "4c" SPINE-DATA 2 1))
                                (list (token "4c" SPINE-DATA 3 0) (token "4c" SPINE-DATA 3 1))
                                (list (token "4c" SPINE-DATA 4 0) (token "4c" SPINE-DATA 4 1))
                                (list (token "*v" SPINE-JOIN 5 0) (token "*v" SPINE-JOIN 5 1))
                                (list (token "*-" SPINE-TERMINATOR 6 0))))
              (list (record "**kern" TOKEN (list (token "**kern" EXCLUSIVE-INTERPRETATION 0 0)) 0)
                    (record "*^" TOKEN (list (token "*^" SPINE-SPLIT 1 0)) 1)
                    (record "4c\t4c" TOKEN (list (token "4c" SPINE-DATA 2 0)
                                                 (token "4c" SPINE-DATA 2 1))
                            2)
                    (record "4c\t4c" TOKEN (list (token "4c" SPINE-DATA 3 0)
                                                 (token "4c" SPINE-DATA 3 1))
                            3)
                    (record "4c\t4c" TOKEN (list (token "4c" SPINE-DATA 4 0)
                                                 (token "4c" SPINE-DATA 4 1))
                            4)
                    (record "*v\t*v" TOKEN (list (token "*v" SPINE-JOIN 5 0)
                                                 (token "*v" SPINE-JOIN 5 1))
                            5)
                    (record "*-" TOKEN (list (token "*-" SPINE-TERMINATOR 6 0)) 6)))
(check-expect (hgraph->lolot (hgraph (root (list
                                            (list
                                             (leaf (token "**kern" EXCLUSIVE-INTERPRETATION 0 0))
                                             (parent (token "*^" SPINE-SPLIT 1 0)
                                                     (list (leaf (token "4c" SPINE-DATA 2 0))
                                                           (leaf (token "4c" SPINE-DATA 3 0))
                                                           (leaf (token "4c" SPINE-DATA 4 0))
                                                           (leaf (token "*v" SPINE-JOIN 5 0)))
                                                     (list (leaf (token "4c" SPINE-DATA 2 1))
                                                           (leaf (token "4c" SPINE-DATA 3 1))
                                                           (leaf (token "4c" SPINE-DATA 4 1))
                                                           (leaf (token "*v" SPINE-JOIN 5 1))))
                                             (leaf (token "*-" SPINE-TERMINATOR 6 0)))))))
              (list (list (token "**kern" EXCLUSIVE-INTERPRETATION 0 0))
                    (list (token "*^" SPINE-SPLIT 1 0))
                    (list (token "4c" SPINE-DATA 2 0) (token "4c" SPINE-DATA 2 1))
                    (list (token "4c" SPINE-DATA 3 0) (token "4c" SPINE-DATA 3 1))
                    (list (token "4c" SPINE-DATA 4 0) (token "4c" SPINE-DATA 4 1))
                    (list (token "*v" SPINE-JOIN 5 0) (token "*v" SPINE-JOIN 5 1))
                    (list (token "*-" SPINE-TERMINATOR 6 0))))
(check-expect (hfile->hgraph (path->hfile "../../data/order/spine-splits-joins-immediately.krn"))
              (hgraph (root (list (list (leaf (token "**kern" EXCLUSIVE-INTERPRETATION 0 0))
                                        (parent (token "*^" SPINE-SPLIT 1 0)
                                                (list (leaf (token "4c" SPINE-DATA 2 0))
                                                      (leaf (token "4c" SPINE-DATA 3 0))
                                                      (leaf (token "4c" SPINE-DATA 4 0))
                                                      (leaf (token "*v" SPINE-JOIN 5 0)))
                                                (list (leaf (token "4c" SPINE-DATA 2 1))
                                                      (leaf (token "4c" SPINE-DATA 3 1))
                                                      (leaf (token "4c" SPINE-DATA 4 1))
                                                      (leaf (token "*v" SPINE-JOIN 5 1))))
                                        (leaf (token "*-" SPINE-TERMINATOR 6 0)))))))
(check-expect (branch->lot (list (leaf (token "**kern" EXCLUSIVE-INTERPRETATION 0 0))
                                 (parent (token "*^" SPINE-SPLIT 1 0)
                                         (list (leaf (token "4c" SPINE-DATA 2 0))
                                               (leaf (token "4c" SPINE-DATA 3 0))
                                               (leaf (token "4c" SPINE-DATA 4 0))
                                               (leaf (token "*v" SPINE-JOIN 5 0)))
                                         (list (leaf (token "4c" SPINE-DATA 2 1))
                                               (leaf (token "4c" SPINE-DATA 3 1))
                                               (leaf (token "4c" SPINE-DATA 4 1))
                                               (leaf (token "*v" SPINE-JOIN 5 1))))
                                 (leaf (token "*-" SPINE-TERMINATOR 6 0))))
              (list (token "**kern" EXCLUSIVE-INTERPRETATION 0 0)
                    (token "*^" SPINE-SPLIT 1 0)
                    (token "4c" SPINE-DATA 2 0)
                    (token "4c" SPINE-DATA 3 0)
                    (token "4c" SPINE-DATA 4 0)
                    (token "*v" SPINE-JOIN 5 0)
                    (token "4c" SPINE-DATA 2 1)
                    (token "4c" SPINE-DATA 3 1)
                    (token "4c" SPINE-DATA 4 1)
                    (token "*v" SPINE-JOIN 5 1)
                    (token "*-" SPINE-TERMINATOR 6 0)))
(check-expect (gspines->linked-spines (spine-parser (path->hfile "../../data/order/spine-splits-joins-immediately.krn"))
                                      (path->hfile "../../data/order/spine-splits-joins-immediately.krn"))
              (list (linked-spine KERN-0-0)))

(test)
