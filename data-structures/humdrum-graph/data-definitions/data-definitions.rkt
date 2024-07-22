#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hum-parser: data structures: HumdrumGraph
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require "../../../parser/data-definitions/data-definitions.rkt")

(provide (all-defined-out))

#|
    A HumdrumGraph is identical to a HumdrumTree, with this difference.
    The HumdrumGraph allows for the spine join that ends a parent to
    be interpreted as a join in a graph, i.e. traversing the parent's
    left sub-branch and right sub-branch will both lead to the node that
    follows the spine join. (The HumdrumTree only allows for the left
    sub-branch to continue to the next node.)
|#

(struct hgraph (root) #:transparent)

(struct root (branches) #:transparent)
; Root is (root (listof (listof Node)))
;  Represents the top of the graph.
;  Each (listof Node) is an ordered list,
;    such that the next element in the list
;    is the next token in the spine as read
;    from file.

; Node is one of:
;  - Leaf
;  - Parent
;  Represents a node of the graph, either
;    a leaf (single token), a parent
;    (spine split token with left and right
;    children).

(struct leaf (token) #:transparent)
; Leaf is (leaf Token)
;  Represents a node with 0 or 1 children.

(struct parent (token left right) #:transparent)
; Parent is (parent Token (listof Node) (listof Node))
;  Represents a node with two children. The last
;  token in each list is a spine-join.

;; Examples
;;  For examples of more complicated data, see
;;  tests/data-structures/humdrum-graph/hfile-to-hgraph.rkt

; Empty humdrum graph
(define EMPTY-HGRAPH (hgraph (root empty)))

; HumdrumGraph with one spine, no splits
(define SIMPLE-HGRAPH (hgraph
                       (root
                         (list
                           (list
                             (leaf (token "**kern" EXCLUSIVE-INTERPRETATION 0))
                             (leaf (token "4a" SPINE-DATA 1))
                             (leaf (token "4b" SPINE-DATA 2)))))))

; HumdrumGraph with two spines, no splits
(define HGRAPH-TWO-SPINES
        (hgraph
          (root
            (list
              (list (leaf (token "**kern" EXCLUSIVE-INTERPRETATION 0))
                    (leaf (token "4a" SPINE-DATA 1))
                    (leaf (token "4b" SPINE-DATA 2)))
              (list (leaf (token "**dynam" EXCLUSIVE-INTERPRETATION 0))
                    (leaf (token "f" #f 1))
                    (leaf (token "p" #f 2)))))))

; HumdrumGraph with one spine, splits
(define HGRAPH-ONE-SPLITS
        (hgraph
          (root
            (list
              (list (leaf (token "**kern" EXCLUSIVE-INTERPRETATION 0))
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
