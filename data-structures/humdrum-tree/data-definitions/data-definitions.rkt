#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hum-parser: data structures: HumdrumTree
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide (all-defined-out))

(define-struct htree (top) #:transparent)
; HumdrumTree is a tree of arbitrary arity. It is a composite of Leaf
;  subclasses as given below. Every HumdrumTree has at least a Top leaf.
;  The branches of the top leaf correspond to spines in a Humdrum file.
;  The first token leaf in each branch should thus be an exclusive
;  interpretation. Each branch ends with a false leaf; this allows spine
;  terminators to be treated simply as tokens. The last leaf in each
;  branch should thus be false, and the last token in each branch should
;  be a spine terminator.
;    Spine splits, represented by the TreeSplit type, are contained within
;    the TreeToken that corresponds to the split token. Every TreeToken
;    has the option to contain a split. If the TreeToken is not a split token,
;    then the split field should be false. The split field should always be false,
;    unless the token field is the string "*^". A TreeSplit then contains within it
;    two lists of TreeTokens, one for the lefthand side of the split, and one for
;    the right hand side of the split. Note that for multiple splits, this means
;    the righthand data of some splits will be duplicated as the lefthand data of
;    others. To handle this, each TreeSplit also contains a boolean field called
;    has-left. If has-left is true, there is at least one subspine to the left of
;    this pair of subspines; consequently, the lefthand of this subspine is also
;    contained in the righthand of the previous TreeSplit. It is up to the user
;    whether they want to traverse the duplicate data. For harmonic analysis, the
;    user will probably want to traverse the duplicate data to make pairwise
;    comparisons between notes. For melodic analysis, the user will probably not
;    want to travese the duplicate data because they will have traversed it in
;    the previous TreeSplit; in this case, skip the left field and take the right
;    field.

; Leaf is one of:
;  - false
;  - Top
;  - TreeToken
;  Represents a leaf of the tree. False indicates that this
;    is the last leaf in a branch.

(define-struct top (branches) #:transparent)
; Top is (make-top (listof (listof Leaf)))
; Represents the top leaf of the tree.
; CONSTRAINT: branches cannot contain Top leaf (only one top of tree)
; CONSTRAINT: each branch must end with a false leaf
; CONSTRAINT: a false leaf can only occur once in a branch

(define-struct tree-token (token type record-number split) #:transparent)
; TreeToken is (make-tree-token String TokenType Natural TreeSplit)
; Represents a leaf that contains a piece of spine data. If that piece
;  is a spine split, then this token also contains all left- and right-
;  hand tokens of the split until the spine join happens.

(define-struct tree-split (left right has-left) #:transparent)
; TreeSplit is one of:
;  - false
;  - (make-split (listof TreeToken) (listof TreeToken) Boolean)
; Represents either the absence of a spine split (false), or the presence
;  of one, in which case is two lists of the left and right branch.
; CONSTRAINT: left and right end with a spine join token
