#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hum-parser: data structures: HumdrumGraph
;;    Function templates
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require "../data-definitions/data-definitions.rkt")

;; Melodic or Depth-first traversal
;; (Regular recursion through graph)
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
                    ; if (parent? first), left and right sub-branch will
                    ; be combined in fn-for-parent, and then combined
                    ; here with the rest
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
                 (token-record-number token)))]
    (... (fn-for-root (hgraph-root hgraph)))))

;; Harmonic or Breadth-first traversal
;; (Recursion with accumulators)
;;    See ../../abstract-humdrum-graph/functions/templates.rkt
