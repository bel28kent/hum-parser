#lang racket/base

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hum-parser: data-structures: LinkedSpine
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require "../../../data-definitions/data-definitions.rkt")

(provide linked-spine
         node
         node-box
         token-node
         split-node
         terminator-node
         LINKED-SPINE-BASE
         LINKED-SPINE-SINGLE
         LINKED-SPINE-ONE)

#|
    A LinkedSpine represents a GlobalSpine as a linked list.
    That is, each token is associated with at least one
    address to the next token(s).

    All tokens that are not "*^" or "*-", are paired with a
    single next token.

    A "*^" is associated with two next tokens.

    The "*-" terminates the LinkedSpine (cf. docs/spines.md).
|#

(struct linked-spine (nodes) #:transparent)
; LinkedSpine is (linked-spine (listof Node))
; Represents a GlobalSpine as a linked list.
; CONSTRAINTS: length (nodes) >= 2
;              nodes[0] is EXCLUSIVE-INTERPRETATION
;              nodes[length-1] is SPINE-TERMINATOR

(struct node (node) #:transparent)
; Node is one of:
;    - TokenNode
;    - SplitNode
;    - TerminatorNode
; Represents an element of a LinkedSpine

(struct node-box (box) #:transparent)
; NodeBox is (node-box (box-immutable Node))
; Represents an address to a Node.

(struct token-node (token next) #:transparent)
; TokenNode is (token-node Token NodeBox)
; Represents a Token with a single next.

(struct split-node (token left-next right-next) #:transparent)
; SplitNode is (split-node Token NodeBox NodeBox)
; Represents a Token of TokenType SPINE-SPLIT with a left-hand
;    next and a right-hand next.

(struct terminator-node (token) #:transparent)
; TerminatorNode is (terminator-node Token)
; Represents a Token of TokenType SPINE-TERMINATOR.

; BASE CASE
(define EX (token "**kern" EXCLUSIVE-INTERPRETATION 0 0))
(define TERM (token "*-" SPINE-TERMINATOR 1 0))
(define LINKED-SPINE-BASE (linked-spine (list (node (token-node EX
                                                                (node-box (box-immutable TERM))))
                                              (node (terminator-node TERM)))))

; NO SPLITS
(define 4A (token "4a" SPINE-DATA 1 0))
(define 4B (token "4b" SPINE-DATA 2 0))
(define 4C (token "4c" SPINE-DATA 3 0))
(define TERM-4 (token "*-" SPINE-TERMINATOR 4 0))
(define LINKED-SPINE-SINGLE (linked-spine (list (node (token-node EX
                                                                  (node-box (box-immutable 4A))))
                                                (node (token-node 4A
                                                                  (node-box (box-immutable 4B))))
                                                (node (token-node 4B
                                                                  (node-box (box-immutable 4C))))
                                                (node (token-node 4C
                                                                  (node-box TERM-4)))
                                                (node (terminator-node TERM-4)))))

; ONE SPLIT
(define STAR-^ (token "*^" SPINE-SPLIT 1 0))
(define 4A-2 (token "4a" SPINE-DATA 2 0))
(define 4AA-2 (token "4aa" SPINE-DATA 2 1))
(define 4B-3 (token "4b" SPINE-DATA 3 0))
(define 4BB-3 (token "4bb" SPINE-DATA 3 1))
(define 4C-4 (token "4c" SPINE-DATA 4 0))
(define 4CC-4 (token "4cc" SPINE-DATA 4 1))
(define STAR-v-1 (token "*v" SPINE-JOIN 5 0))
(define STAR-v-2 (token "*v" SPINE-JOIN 5 1))
(define TERM-6 (token "*-" SPINE-TERMINATOR 6 0))
(define LINKED-SPINE-ONE (linked-spine (list (node (token-node EX
                                                               (node-box (box-immutable STAR-^))))
                                             (node (split-node STAR-^
                                                               (node-box (box-immutable 4A-2))
                                                               (node-box (box-immutable 4AA-2))))
                                             (node (token-node 4A-2
                                                               (node-box (box-immutable 4B-3))))
                                             (node (token-node 4AA-2
                                                               (node-box (box-immutable 4BB-3))))
                                             (node (token-node 4B-3
                                                               (node-box (box-immutable 4C-4))))
                                             (node (token-node 4BB-3
                                                               (node-box (box-immutable 4CC-4))))
                                             (node (token-node 4C-4
                                                               (node-box (box-immutable STAR-v-1))))
                                             (node (token-node 4CC-4
                                                               (node-box (box-immutable STAR-v-2))))
                                             (node (token-node STAR-v-1
                                                               (node-box (box-immutable TERM-6))))
                                             (node (token-node STAR-v-2
                                                               (node-box (box-immutable TERM-6))))
                                             (node (terminator-node TERM-6)))))
