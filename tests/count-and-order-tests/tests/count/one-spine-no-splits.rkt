#lang racket/base

(require test-engine/racket-tests)

(check-expect (path->hfile "../../data/count/one-spine-no-splits.krn") )
(check-expect (spine-parser ) )
(check-expect (ab-hgraph->hfile ) )
(check-expect (lolot->lor ) )
(check-expect (ab-hgraph->lolot ) )
(check-expect (hfile->ab-hgraph ) )
(check-expect (branch->lot ) )
**kern
*clefG2
*k[]
*a:
*M3/4
4c
4c
4c
=2
4c
4c
4c
=3
4c
4c
4c
==
*-

(test)
