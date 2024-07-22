#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hum-parser: data structures: HumdrumTree
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require "../../../parser/data-definitions/data-definitions.rkt")

#|
    A HumdrumTree is a tree with an arbitrary number of branches.
    Each branch in the tree represents one global spine in a
    Humdrum file. Branches are ordered; the leftmost branch of the
    tree is the leftmost spine of the Humdrum file.

    A branch is a list of nodes. This list is also ordered, with the
    first node of each branch being the exclusive interpretation
    of the corresponding spine, and the remaining tokens following
    in the order that they would be read in a file.

    A node is either a leaf or a parent. A leaf represents a single
    token. A parent represents a spine split that creates a left and
    right sub-branch.

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

(provide (all-defined-out))

(struct htree (root) #:transparent)

(struct root (branches) #:transparent)
; Root is (root (listof (listof Node)))
;  Represents the top of the tree.
;  Each (listof Node) is an ordered list,
;    such that the next element in the list
;    is the next token in the spine as read
;    from file.

; Node is one of:
;  - Leaf
;  - Parent
;  Represents a node of the tree, either
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
;;  tests/data-structures/humdrum-tree/hfile-to-htree.rkt

; Empty HumdrumTree
(define EMPTY-HTREE (htree (root empty)))

; HumdrumTree with one spine, no splits
(define SIMPLE-HTREE (htree
                       (root
                         (list
                           (list
                             (leaf (token "**kern" EXCLUSIVE-INTERPRETATION 0))
                             (leaf (token "4a" SPINE-DATA 1))
                             (leaf (token "4b" SPINE-DATA 2)))))))

; HumdrumTree with two spines, no splits
(define HTREE-TWO-SPINES
        (htree
          (root
            (list
              (list (leaf (token "**kern" EXCLUSIVE-INTERPRETATION 0))
                    (leaf (token "4a" SPINE-DATA 1))
                    (leaf (token "4b" SPINE-DATA 2)))
              (list (leaf (token "**dynam" EXCLUSIVE-INTERPRETATION 0))
                    (leaf (token "f" #f 1))
                    (leaf (token "p" #f 2)))))))

; HumdrumTree with one spine, splits
(define HTREE-ONE-SPLITS
        (htree
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
