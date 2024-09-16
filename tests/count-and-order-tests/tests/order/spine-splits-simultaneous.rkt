#lang racket/base

(require test-engine/racket-tests)

(check-expect (path->hfile ) )
(check-expect (spine-parser ) )
(check-expect (ab-hgraph->hfile ) )
(check-expect (lolot->lor ) )
(check-expect (ab-hgraph->lolot ) )
(check-expect (hfile->ab-hgraph ) )
(check-expect (branch->lot ) )
**kern
*^
*^	*^
4c	4c	4c	4c
4c	4c	4c	4c
4c	4c	4c	4c
*	*	*v	*v
*	*v	*v
*v	*v
*-