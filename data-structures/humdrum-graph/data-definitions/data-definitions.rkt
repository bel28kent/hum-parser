#lang racket/base

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hum-parser: data structures: HumdrumGraph
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require racket/list
         "../../../parser/data-definitions/data-definitions.rkt")

(provide (all-defined-out))

#|
    A HumdrumGraph is a graph. A HumdrumGraph is best imagined as
    trees with branches and nodes, though it allows for joins.
    They are two-dimensional and afford vertical (depth-first)
    and horizontal (breadth-first) traversal. In a musical context,
    these are akin to melodic and harmonic analysis.

    A HumdrumGraph has an arbitrary number of branches. Each branch
    represents one global spine in a Humdrum file. Branches are
    ordered; the leftmost branch is the leftmost spine of the Humdrum
    file.

    A branch is a list of nodes. This list is also ordered, with the
    first node of each branch being the exclusive interpretation
    of the corresponding spine, and the remaining tokens following
    in the order that they would be read in a file.

    A node is either a leaf or a parent. A leaf represents a single
    token. A parent represents a spine split that creates a left and
    right sub-branch.
|#

(struct humdrum-graph (root) #:constructor-name hgraph #:transparent)

(struct root (branches) #:transparent)
; Root is (root (listof (listof Node)))
;  Represents the top of the graph.
; CONSTRAINT: branches is an ordered list,
;  matching the order of the Humdrum file.

; Node is one of:
;  - Leaf
;  - Parent
;  Represents a node of the graph, either
;    a leaf (single token), or a parent
;    (spine split token with left and right
;    children).

(struct leaf (token) #:transparent)
; Leaf is (leaf Token)
;  Represents a node with 0 or 1 children.

(struct parent (token left right) #:transparent)
; Parent is (parent Token (listof Node) (listof Node))
;  Represents a node with two children. The last
;  token in each list is a spine-join.

; Empty HumdrumGraph
(define EMPTY-HGRAPH (hgraph (root empty)))

; HumdrumGraph with one spine, no splits
(define SIMPLE-AB-HGRAPH (hgraph (root (list (list
                                              (leaf (token "**kern" EXCLUSIVE-INTERPRETATION 0))
                                              (leaf (token "4a" SPINE-DATA 1))
                                              (leaf (token "4b" SPINE-DATA 2)))))))

; HumdrumGraph with two spines, no splits
(define HGRAPH-TWO-SPINES (hgraph (root (list (list
                                               (leaf (token "**kern" EXCLUSIVE-INTERPRETATION 0))
                                               (leaf (token "4a" SPINE-DATA 1))
                                               (leaf (token "4b" SPINE-DATA 2)))
                                              (list
                                               (leaf (token "**dynam" EXCLUSIVE-INTERPRETATION 0))
                                               (leaf (token "f" #f 1))
                                               (leaf (token "p" #f 2)))))))

; HumdrumGraph with one spine, splits
(define HGRAPH-ONE-SPLITS (hgraph (root (list (list
                                               (leaf (token "**kern" EXCLUSIVE-INTERPRETATION 0))
                                               (leaf (token "4a" SPINE-DATA 1))
                                               (parent (token "*^" SPINE-SPLIT 2)
                                                       (list (leaf (token "4a" SPINE-DATA 3))
                                                             (leaf (token "4a" SPINE-DATA 4))
                                                             (leaf (token "*v" SPINE-JOIN 5)))
                                                       (list (leaf (token "4aa" SPINE-DATA 3))
                                                             (leaf (token "4aa" SPINE-DATA 4))
                                                             (leaf (token "*v" SPINE-JOIN 5))))
                                               (leaf (token "4a" SPINE-DATA 6))
                                               (leaf (token "4b" SPINE-DATA 7))
                                               (leaf (token "4c" SPINE-DATA 8)))))))
