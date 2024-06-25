#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hum-parser: data structures: HumdrumTree
;;    Templates
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require "../data-definitions/data-definitions.rkt")

;; Melodic or Depth-first traversal
;; (Regular recursion through tree)
;;    This template starts at the root of the tree, and
;;    pursues the leftmost branch as far down as it can
;;    before moving to the adjacent, right-hand branch.
;;    This procedure is repeated through the traversal
;;    of the rightmost branch.
;;
;;    This traversal is akin to a melodic analysis, going
;;    through each part note-by-note, with no awareness of
;;    simultaneous events.

(define (fn-for-htree htree)
  (local [(define (fn-for-root root)
            (local [(define (iterator branches)
                      (cond [(empty? branches) ...]
                            [else
                              (... (fn-for-node (first branches))
                                   (iterator (rest branches)))]))]
              (iterator (root-branches root))))

          (define (fn-for-node node)
            (cond [(false? node) ...]
                  [(leaf? node) (fn-for-leaf node)]
                  [else
                    (fn-for-parent node)]))

          (define (fn-for-leaf leaf)
            (... (fn-for-token (leaf-token leaf))
                 (fn-for-node (leaf-next leaf))))

          (define (fn-for-parent parent)
            (... (fn-for-token (parent-token parent))
                 (fn-for-node (parent-left parent))
                 (fn-for-node (parent-right parent))))

          (define (fn-for-token token)
            (... (token-token token)
                 (token-type token)
                 (token-record-number token)))]
    (fn-for-root (htree-root htree))))

;; Harmonic or Breadth-first traversal
;; (Recursion with accumulators)
;;    This template starts at the root of the tree, pursues
;;    the leftmost branch to start, and then cuts horizontally
;;    across the tree. After cutting across, the traversal then
;;    takes the next node in the leftmost branch, and again
;;    cuts across to the rightmost branch. This method requires
;;    accumulating (keeping track of) the remaining nodes in the
;;    branches that will not be visited until the next cut;
;;    otherwise they will be lost in the recursion.
;;
;;    This traversal is akin to a harmonic analysis, considering
;;    all notes that are sounding simultaenously.
