#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hum-parser: trees: data definitions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require "../parser/data-definitions/data-definitions.rkt")

(provide (all-defined-out))

; Leaf is one of:
;  - false
;  - Token
;  - Split
;  - Top
;  Represents a leaf of the tree. False indicates that this
;    is the last leaf in a branch.

(define-struct token (token type record-number split) #:transparent)
; Token is (make-token String TokenType Natural Split)
; Represents a leaf that contains a piece of spine data. If that piece
;  is a spine split, then this token also contains all left- and right-
;  hand tokens of the split until the spine join happens.

(define-struct split (left right) #:transparent)
; Split is one of:
;  - false
;  - (make-split (listof Token) (listof Token))
; Represents either the absence of a spine split (false), or the presence
;  of one, in which case is two lists of the left and right branch.
; CONSTRAINT: left and right end with a spine join token

(define-struct top (branches) #:transparent)
; Top is (make-top (listof (listof Leaf)))
; Represents the top leaf of the tree.
; CONSTRAINT: branches cannot contain a Top leaf in any list (only one top of tree)
; CONSTRAINT: each branch must end with a false leaf
; CONSTRAINT: a false leaf can only occur once in a branch
