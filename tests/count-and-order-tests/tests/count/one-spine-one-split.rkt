#lang racket/base

(require "../../../../parser/data-definitions/data-definitions.rkt"
         "../../../../parser/functions/file.rkt"
         "../../../../parser/functions/spine-parser.rkt"
         "../../../../data-structures/abstract-humdrum-graph/data-definitions/data-definitions.rkt"
         "../../../../data-structures/abstract-humdrum-graph/functions/ab-hgraph-to-hfile.rkt"
         "../../../../data-structures/abstract-humdrum-graph/functions/hfile-to-ab-hgraph.rkt"
         test-engine/racket-tests)

(check-expect (path->hfile "../../data/count/one-spine-one-split.krn")
              (hfile (list (record "**kern" TOKEN (list "***kern") 0)
                           (record "*clefG2" TOKEN (list "*clefG2") 1)
                           (record "*k[]" TOKEN (list "*k[]") 2)
                           (record "*a:" TOKEN (list "*a:") 3)
                           (record "*M3/4" TOKEN (list "*M3/4") 4)
                           (record "*^" TOKEN (list "*^") 5)
                           (record "4c	4c" TOKEN (list "4c" "4c") 6)
                           (record "4c	4c" TOKEN (list "4c" "4c") 7)
                           (record "4c	4c" TOKEN (list "4c" "4c") 8)
                           (record "=2	=2" TOKEN (list "=2" "=2") 9)
                           (record "4c	4c" TOKEN (list "4c" "4c") 10)
                           (record "4c	4c" TOKEN (list "4c" "4c") 11)
                           (record "4c	4c" TOKEN (list "4c" "4c") 12)
                           (record "=3	=3" TOKEN (list "=3" "=3") 13)
                           (record "4c	4c" TOKEN (list "4c" "4c") 14)
                           (record "4c	4c" TOKEN (list "4c" "4c") 15)
                           (record "4c	4c" TOKEN (list "4c" "4c") 16)
                           (record "*v	*v" TOKEN (list "*v" "*v") 17)
                           (record "==" TOKEN (list "==") 18)
                           (record "*-" TOKEN (list "*-") 19))))
(check-expect (spine-parser ) )
(check-expect (ab-hgraph->hfile )
              (path->hfile "../../data/count/one-spine-one-split.krn"))
(check-expect (lolot->lor )
              (list (record "**kern" TOKEN (list "***kern") 0)
                    (record "*clefG2" TOKEN (list "*clefG2") 1)
                    (record "*k[]" TOKEN (list "*k[]") 2)
                    (record "*a:" TOKEN (list "*a:") 3)
                    (record "*M3/4" TOKEN (list "*M3/4") 4)
                    (record "*^" TOKEN (list "*^") 5)
                    (record "4c	4c" TOKEN (list "4c" "4c") 6)
                    (record "4c	4c" TOKEN (list "4c" "4c") 7)
                    (record "4c	4c" TOKEN (list "4c" "4c") 8)
                    (record "=2	=2" TOKEN (list "=2" "=2") 9)
                    (record "4c	4c" TOKEN (list "4c" "4c") 10)
                    (record "4c	4c" TOKEN (list "4c" "4c") 11)
                    (record "4c	4c" TOKEN (list "4c" "4c") 12)
                    (record "=3	=3" TOKEN (list "=3" "=3") 13)
                    (record "4c	4c" TOKEN (list "4c" "4c") 14)
                    (record "4c	4c" TOKEN (list "4c" "4c") 15)
                    (record "4c	4c" TOKEN (list "4c" "4c") 16)
                    (record "*v	*v" TOKEN (list "*v" "*v") 17)
                    (record "==" TOKEN (list "==") 18)
                    (record "*-" TOKEN (list "*-") 19)))
(check-expect (ab-hgraph->lolot ) )
(check-expect (hfile->ab-hgraph (path->hfile "../../data/count/one-spine-one-split.krn") ab-hgraph) )
(check-expect (branch->lot ) )
**kern
*clefG2
*k[]
*a:
*M3/4
*^
4c	4c
4c	4c
4c	4c
=2	=2
4c	4c
4c	4c
4c	4c
=3	=3
4c	4c
4c	4c
4c	4c
*v	*v
==
*-

(test)
