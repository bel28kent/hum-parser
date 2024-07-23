#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hum-parser: data structures: HumdrumTree
;;    Function templates
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
                              (... (fn-for-lon (first branches))
                                   (iterator (rest branches)))]))]
              (iterator (root-branches root))))

          (define (fn-for-lon branch)
            (cond [(empty? branch) ...]
                  [(leaf? (first branch)) (... (fn-for-leaf (first branch))
                                               (fn-for-lon (rest branch)))]
                  [else ; parent case
                    (... (fn-for-token (parent-token (first branch)))
                         ; combination of parent left with data after parent
                         (... (fn-for-lon (parent-left (first branch)))
                              (fn-for-lon (rest branch)))
                         (fn-for-lon (parent-right (first branch))))]))

          (define (fn-for-leaf leaf)
            (... (fn-for-token (leaf-token leaf))))

          (define (fn-for-token token)
            (... (token-token token)
                 (token-type token)
                 (token-record-number token)))]
    (... (fn-for-root (htree-root htree)))))

;; Harmonic or Breadth-first traversal
;; (Recursion with accumulators)
;;    See ../../abstract-humdrum-graph/functions/templates.rkt
