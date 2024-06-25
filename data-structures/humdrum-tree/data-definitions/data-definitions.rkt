#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hum-parser: data structures: HumdrumTree
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require "../../../parser/data-definitions/data-definitions.rkt")

(struct htree (root) #:transparent)
; HumdrumTree is a tree of arbitrary arity. Its Root
;  can have any number of branches; this corresponds
;  to a Humdrum file having any number of spines.
;
;  The branches are composites of three Nodes:
;    false  - representing the end of the branch;
;    Leaf   - representing a node that points to its next;
;    Parent - representing a node that points to a left and right next.
;  A false node corresponds to a spine terminator.
;  A Leaf node corresponds to a token in a Humdrum file, which is always
;    followed by one token.
;  A Parent node corresponds to a spine split in a Humdrum file, which is
;    always followed by a lefthand token and a righthand token.
;

(struct root (branches) #:transparent)
; Root is (root (listof Node))
;  Represents the top of the tree.

; Node is one of:
;  - Parent
;  - Leaf
;  - false
;    Represents a node of the tree, either a parent
;    with two children or a leaf with 0 or 1 next nodes.
;    0 next nodes is represented by false.

(struct parent (token left right) #:transparent)
; Parent is (parent Token Node Node)
;  Represents a node with two children.

(struct leaf (token next) #:transparent)
; Leaf is (leaf Token Node)
;  Represents a node with no children.

;; Examples

; Empty humdrum tree
(define EMPTY-HTREE (htree (root empty))

; Humdrum tree with one spine, no splits
; NB: Spine terminator is substituted with false
(define SIMPLE-HTREE (htree (root (list (leaf (token "**kern" EXCLUSIVE-INTERPRETATION 0)
                                              (leaf (token "4a" SPINE-DATA 1)
                                                    (leaf (token "4b" SPINE-DATA 2)
                                                          false)))))))

; Humdrum tree with two spines, no splits
(define HTREE-TWO-SPINES (htree (root (list (leaf (token "**kern" EXCLUSIVE-INTERPRETATION 0)
                                                  (leaf (token "4a" SPINE-DATA 1)
                                                        (leaf (token "4b" SPINE-DATA 2)
                                                              false)))
                                            (leaf (token "**dynam" EXCLUSIVE-INTEPRETATION 0)
                                                  (leaf (token "f" #f 1)
                                                        (leaf (token "p" #f 2)
                                                              false)))))))
; Humdrum tree with one spine, splits
