#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hum-parser: data structures: AbstractHumdrumGraph
;;    Function templates
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require "../data-definitions/data-definitions.rkt")

;; Melodic or Depth-first traversal
;; (Regular recursion)
;;    This traversal depends on whether the data structure is
;;    a HumdrumTree or HumdrumGraph. See:
;;    ../../humdrum-tree/functions/templates.rkt
;;    OR
;;    ../../humdrum-graph/functions/templates.rkt

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

(define (fn-for-ab-hgraph ab-hgraph)
  (local [(define (fn-for-root root)
                    ; acc. (listof (listof Node)). the rest of each branch.
            (local [(define (iterator branches acc)
                      (cond [(and (empty? branches) (empty? acc)) ...]
                            [(and (empty? branches)
                                  (not (empty? acc))) (iterator
                                                        (reverse acc)
                                                        empty)]
                            [else
                              (local [(define fof (first (first branches)))

                                      (define result
                                              (cond [(leaf? fof)
                                                     (fn-for-leaf fof)]
                                                    [(parent? fof)
                                                     (fn-for-leaf
                                                       (parent-token fof))]))]
                                (... result
                                     (iterator (rest branches)
                                               (if (parent? fof)
                                                   (cons
                                                     (parent-right fof)
                                                       (cons
                                                         (parent-left fof)
                                                           acc))
                                                   (cons
                                                     (rest
                                                       (first branches))
                                                     acc)))))]))]
              (iterator (root-branches root) empty)))

          (define (fn-for-leaf leaf)
            (... (fn-for-token (leaf-token leaf))))

          (define (fn-for-token token)
            (... (token-token token)
                 (token-type token)
                 (token-record-number token)))]
    (... (fn-for-root (abstract-humdrum-graph-root ab-hgraph)))))
