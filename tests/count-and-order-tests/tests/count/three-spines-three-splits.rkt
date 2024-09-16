#lang racket/base

(require test-engine/racket-tests)

(check-expect (path->hfile ) )
(check-expect (spine-parser ) )
(check-expect (ab-hgraph->hfile ) )
(check-expect (lolot->lor ) )
(check-expect (ab-hgraph->lolot ) )
(check-expect (hfile->ab-hgraph ) )
(check-expect (branch->lot ) )
**kern	**kern	**kern
*clefG2	*clefG2	*clefG2
*k[]	*k[]	*k[]
*a:	*a:	*a:
*M3/4	*M3/4	*M3/4
*^	*	*
*	*^	*	*
*	*	*^	*	*
*	*	*	*	*^	*
*	*	*	*	*	*^	*
*	*	*	*	*	*	*^	*
*	*	*	*	*	*	*	*	*^
*	*	*	*	*	*	*	*	*	*^
*	*	*	*	*	*	*	*	*	*	*^
4c	4c	4c	4c	4c	4c	4c	4c	4c	4c	4c	4c
4c	4c	4c	4c	4c	4c	4c	4c	4c	4c	4c	4c
4c	4c	4c	4c	4c	4c	4c	4c	4c	4c	4c	4c
=2	=2	=2	=2	=2	=2	=2	=2	=2	=2	=2	=2
4c	4c	4c	4c	4c	4c	4c	4c	4c	4c	4c	4c
4c	4c	4c	4c	4c	4c	4c	4c	4c	4c	4c	4c
4c	4c	4c	4c	4c	4c	4c	4c	4c	4c	4c	4c
=3	=3	=3	=3	=3	=3	=3	=3	=3	=3	=3	=3
4c	4c	4c	4c	4c	4c	4c	4c	4c	4c	4c	4c
4c	4c	4c	4c	4c	4c	4c	4c	4c	4c	4c	4c
4c	4c	4c	4c	4c	4c	4c	4c	4c	4c	4c	4c
*	*	*	*	*	*	*	*	*	*	*v	*v
*	*	*	*	*	*	*	*	*	*v	*v
*	*	*	*	*	*	*	*	*v	*v
*	*	*	*	*	*	*v	*v	*
*	*	*	*	*	*v	*v	*
*	*	*	*	*v	*v	*
*	*	*v	*v	*	*
*	*v	*v	*	*
*v	*v	*	*
==	==	==
*-	*-	*-
