#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hum-parser: data structures: HumdrumTree
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require "../../../parser/data-definitions/data-definitions.rkt"
         "../../abstract-humdrum-graph/data-definitions/data-definitions.rkt")

(provide (all-defined-out))

#|
    A HumdrumTree is a subtype of AbstractHumdrumGraph.

    The HumdrumTree differs from the HumdrumGraph in the traversal of
    a branch after a parent. In a HumdrumTree, the traversal should
    continue from the left side of the parent. Trees do not allow for
    joins, so the traversal cannot continue from both sub-branches.
    Spine joins are interpreted as joining the right sub-branch with
    the left sub-branch. When recursing through a HumdrumTree, the
    result of the recursive call on the rest of a branch should then be
    combined with the result of the function call on the left sub-branch
    of the parent. The exact implementation of this combination will
    vary between programs; the function templates provide abstract
    examples of how this can be done.
|#

(struct humdrum-tree () #:super struct:abstract-humdrum-graph
                        #:constructor-name htree
                        #:transparent)

;; Examples: See
;;    ../../abstract-humdrum-graph/data-definitions/data-definitions.rkt
