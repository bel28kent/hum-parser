#lang racket/base

(require test-engine/racket-tests)

(check-expect (path->hfile "../../data/order/two-spines-split-simultaneously.krn") )
(check-expect (spine-parser ) )
(check-expect (ab-hgraph->hfile ) )
(check-expect (lolot->lor ) )
(check-expect (ab-hgraph->lolot ) )
(check-expect (hfile->ab-hgraph ) )
(check-expect (branch->lot ) )
**kern	**kern
*^		*^
4c		4c	4c	4c
4c		4c	4c	4c
4c		4c	4c	4c
*		*	*v	*v
*v		*v	*
*-		*-

(test)
