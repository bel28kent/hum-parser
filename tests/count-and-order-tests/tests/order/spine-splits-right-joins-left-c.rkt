#lang racket/base

(require "../../../../parser/data-definitions/data-definitions.rkt"
         "../../../../parser/functions/file.rkt"
         "../../../../parser/functions/spine-parser.rkt"
         "../../../../data-structures/abstract-humdrum-graph/data-definitions/data-definitions.rkt"
         "../../../../data-structures/abstract-humdrum-graph/functions/ab-hgraph-to-hfile.rkt"
         "../../../../data-structures/abstract-humdrum-graph/functions/hfile-to-ab-hgraph.rkt"
         test-engine/racket-tests
         racket/list) ; TODO remove

(check-expect (path->hfile "../../data/order/spine-splits-right-joins-left-c.krn") (hfile empty))
(check-expect (spine-parser (path->hfile "../../data/order/spine-splits-right-joins-left-c.krn"))
              empty)
(check-expect (ab-hgraph->hfile (ab-hgraph (root empty)))
              (path->hfile "../../data/order/spine-splits-right-joins-left-c.krn"))
(check-expect (lolot->lor empty) empty)
(check-expect (ab-hgraph->lolot (ab-hgraph (root empty))) empty)
(check-expect (hfile->ab-hgraph
               (path->hfile "../../data/order/spine-splits-right-joins-left-c.krn"))
              (ab-hgraph (root empty)))
(check-expect (branch->lot  empty) empty)
#|
**kern
*^
*	*^
*	*	*^
4c	4c	4c	4c
4c	4c	4c	4c
4c	4c	4c	4c
*v	*v	*	*
4a	4b	4c
4c	4d	4e
*v	*v	*
4e	4f	4g
*v	*v
*-
|#

(test)
