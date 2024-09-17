#lang racket/base

(require "../../../../parser/data-definitions/data-definitions.rkt"
         "../../../../parser/functions/file.rkt"
         "../../../../parser/functions/spine-parser.rkt"
         "../../../../data-structures/abstract-humdrum-graph/data-definitions/data-definitions.rkt"
         "../../../../data-structures/abstract-humdrum-graph/functions/ab-hgraph-to-hfile.rkt"
         "../../../../data-structures/abstract-humdrum-graph/functions/hfile-to-ab-hgraph.rkt"
         test-engine/racket-tests)

(check-expect (path->hfile "../../data/order/spine-splits-joins-successively.krn") )
(check-expect (spine-parser ) )
(check-expect (ab-hgraph->hfile ) )
(check-expect (lolot->lor ) )
(check-expect (ab-hgraph->lolot ) )
(check-expect (hfile->ab-hgraph ) )
(check-expect (branch->lot ) )
**kern
*^
*	*^
4c	4c	4c
4c	4c	4c
4c	4c	4c
*	*v	*v
*v	*v
*-

(test)
