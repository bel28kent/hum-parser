#lang racket/base

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hum-parser: data-structures: LinkedSpine
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require "../../../data-definitions/data-definitions.rkt")

(provide (struct-out linked-spine)
         (struct-out node)
         (struct-out node-box)
         (struct-out token-node)
         (struct-out split-node)
         (struct-out terminator-node)
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

(struct linked-spine (first-node) #:transparent)
; LinkedSpine is (linked-spine Node))
; Represents a GlobalSpine as a linked list.
; CONSTRAINTS: first-node's token is EXCLUSIVE-INTERPRETATION
;              first-node at least points to a SPINE-TERMINATOR

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
; TerminatorNode is (terminator-node NodeBox)
; Represents a Token of TokenType SPINE-TERMINATOR.

; BASE CASE
(define EX (token "**kern" EXCLUSIVE-INTERPRETATION 0 0))
(define TERM (token "*-" SPINE-TERMINATOR 1 0))
(define TERM-NODE (terminator-node (node-box (box-immutable TERM))))
(define EX-NODE (token-node EX TERM-NODE))
(define LINKED-SPINE-BASE (linked-spine EX-NODE))

; NO SPLITS
(define 4A (token "4a" SPINE-DATA 1 0))
(define 4B (token "4b" SPINE-DATA 2 0))
(define 4C (token "4c" SPINE-DATA 3 0))
(define TERM-4 (token "*-" SPINE-TERMINATOR 4 0))
(define TERM-4-NODE (terminator-node (node-box (box-immutable TERM-4))))
(define 4C-NODE (token-node 4C (node-box (box-immutable TERM-4))))
(define 4B-NODE (token-node 4B (node-box (box-immutable 4C-NODE))))
(define 4A-NODE (token-node 4A (node-box (box-immutable 4B-NODE))))
(define EX-NODE-SINGLE (token-node EX (node-box (box-immutable 4A-NODE))))
(define LINKED-SPINE-SINGLE (linked-spine EX-NODE-SINGLE))

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
(define TERM-6-NODE (node-box (box-immutable TERM-6)))
(define STAR-v-2-NODE (token-node STAR-v-2 (node-box (box-immutable TERM-6-NODE))))
(define STAR-v-1-NODE (token-node STAR-v-1 (node-box (box-immutable TERM-6-NODE))))
(define 4CC-4-NODE (token-node 4CC-4 (node-box (box-immutable STAR-v-2-NODE))))
(define 4C-4-NODE (token-node 4C-4 (node-box (box-immutable STAR-v-1-NODE))))
(define 4BB-3-NODE (token-node 4BB-3 (node-box (box-immutable 4CC-4-NODE))))
(define 4B-3-NODE (token-node 4B-3 (node-box (box-immutable 4C-4-NODE))))
(define 4AA-2-NODE (token-node 4AA-2 (node-box (box-immutable 4BB-3-NODE))))
(define 4A-2-NODE (token-node 4A-2 (node-box (box-immutable 4B-3-NODE))))
(define STAR-^-NODE (split-node STAR-^
                                (node-box (box-immutable 4A-2-NODE))
                                (node-box (box-immutable 4AA-2-NODE))))
(define EX-NODE-SPLIT (token-node EX (node-box (box-immutable STAR-^-NODE))))
(define LINKED-SPINE-ONE (linked-spine EX-NODE-SPLIT))
