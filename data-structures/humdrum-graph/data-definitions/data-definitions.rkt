#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hum-parser: data structures: HumdrumGraph
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require "../../../parser/data-definitions/data-definitions.rkt"
         "../../abstract-humdrum-graph/data-definitions/data-definitions.rkt")

(provide (all-defined-out))

#|
    A HumdrumGraph is a subtype of AbstractHumdrumGraph.

    A HumdrumGraph is identical to a HumdrumTree, with this difference.
    The HumdrumGraph allows for the spine join that ends a parent to
    be interpreted as a join in a graph, i.e. traversing the parent's
    left sub-branch and right sub-branch will both lead to the node that
    follows the spine join. (The HumdrumTree only allows for the left
    sub-branch to continue to the next node.)
|#

(struct humdrum-graph () #:super struct:abstract-humdrum-graph
                         #:constructor-name hgraph
                         #:transparent)

;; Examples: See
;;    ../../abstract-humdrum-graph/data-definitions/data-definitions.rkt
