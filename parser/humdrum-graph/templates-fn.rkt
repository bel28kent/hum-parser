#lang racket

#|
	Function templates for depth-first and breadth-first HumdrumGraph traversal.
|#

(require "HumdrumGraph.rkt")

;; Melodic or Depth-first traversal
;; (Regular recursion)
;;    This template starts at the root of the graph, and
;;    pursues the leftmost branch as far down as it can
;;    before moving to the adjacent, right-hand branch.
;;    This procedure is repeated through the traversal
;;    of the rightmost branch.
;;
;;    This traversal is akin to a melodic analysis, going
;;    through each part note-by-note, with no awareness of
;;    simultaneous events.

(define (fn-for-hgraph hgraph)
  (local [(define (fn-for-root root)
            (local [(define (iterator branches)
                      (cond [(empty? branches) ...]
                            [else
                              (... (fn-for-lon (first branches))
                                   (iterator (rest branches)))]))]
              (iterator (root-branches root))))

          (define (fn-for-lon branch)
            (cond [(empty? branch) ...]
                  [else
                    ; if (parent? first), left and right sub-branch
                    ; will be combined in fn-for-parent, and then
                    ; combined here with the rest
                    (... (fn-for-node (first branch))
                         (fn-for-lon (rest branch)))]))

          (define (fn-for-node node)
            (cond [(leaf? node) (fn-for-leaf node)]
                  [else
                    (fn-for-parent node)]))

          (define (fn-for-leaf leaf)
            (... (fn-for-token (leaf-token leaf))))

          (define (fn-for-parent parent)
            ; combination of recursive calls on left and right sub-branches
            (... (fn-for-token (parent-token parent))
                 (fn-for-lon (parent-left parent))
                 (fn-for-lon (parent-right parent))))

          (define (fn-for-token token)
            (... (token-token token)
                 (token-type token)
                 (token-record-number token)
                 (token-field-index token)))]
    (... (fn-for-root (humdrum-graph-root hgraph)))))

;; Harmonic or Breadth-first traversal
;; (Recursion with accumulators)
;;    This template starts at the root, pursues the leftmost
;;    branch to start, and then cuts horizontally across.
;;    After cutting, the traversal then takes the next node in the
;;    leftmost branch, and again cuts across to the rightmost branch.
;;    This method requires accumulating (keeping track of) the
;;    remaining nodes in the branches that will not be visited until
;;    the next cut; otherwise they will be lost in the recursion.
;;
;;    This traversal is akin to a harmonic analysis, considering
;;    all notes that are sounding simultaneously. Note, though,
;;    that this template treats each node as it is encountered.
;;    If the user wants to treat all nodes at one level together,
;;    then a second accumulator must be added that accumulates the
;;    first of each branch, and only calls the analysis function
;;    when the (empty? branches) is reached, passing that second
;;    accumulator to the analysis function.

(define (fn-for-hgraph hgraph)
  (local [(define (fn-for-root root)
                    ; acc. (listof (listof Node)). the rest of each branch.
            (local [(define (iterator branches acc)
                      (cond [(and (empty? branches) (empty? acc)) ...]
                            [(and (empty? branches) (not (empty? acc))) (iterator ...
                                                                                  (reverse acc)
                                                                                  empty)]
                            [else
                              (local [(define fof (first (first branches)))

                                      (define result
                                              (cond [(leaf? fof) (fn-for-leaf fof)]
                                                    [(parent? fof)
                                                     (fn-for-token (parent-token fof))]))]
                                (... result
                                     (iterator (rest branches)
                                               (if (parent? fof)
                                                   (cons (parent-right fof)
                                                     (cons (parent-left fof) acc))
                                                   (cons (rest (first branches)) acc)))))]))]
              (iterator (root-branches root) empty)))

          (define (fn-for-leaf leaf)
            (... (fn-for-token (leaf-token leaf))))

          (define (fn-for-token token)
            (... (token-token token)
                 (token-type token)
                 (token-record-number token)
                 (token-field-index token)))]
    (... (fn-for-root (humdrum-graph-root hgraph)))))
