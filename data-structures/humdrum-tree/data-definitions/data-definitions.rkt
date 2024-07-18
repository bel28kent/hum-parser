#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hum-parser: data structures: HumdrumTree
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require "../../../parser/data-definitions/data-definitions.rkt")

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

; Empty humdrum tree
(define EMPTY-HTREE (htree (root empty)))

; Humdrum tree with one spine, no splits
(define SIMPLE-HTREE (htree
                       (root
                         (list
                           (list
                             (leaf (token "**kern" EXCLUSIVE-INTERPRETATION 0))
                             (leaf (token "4a" SPINE-DATA 1))
                             (leaf (token "4b" SPINE-DATA 2)))))))

; Humdrum tree with two spines, no splits
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

; Humdrum tree with one spine, splits
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
