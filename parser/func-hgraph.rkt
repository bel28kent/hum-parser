#lang racket/base

#|
	HumdrumGraph functions.
|#

(require racket/list
         racket/local
         "data-HumdrumGraph.rkt"
         "func-abstract.rkt")

;; Basic operations
;; NB: A HumdrumGraph is immutable, so add, remove, and set are invalid.

(define (adjacent? edges vertex_1 vertex_2)
  (if (member? (hash-ref edges vertex_1) vertex_2)
       #t
       #f))

(define (children edges vertex)
  (hash-ref edges vertex))

(define (get-sibling-hgraph hgraph vertex [right? #f])
  ; HumdrumGraph Vertex Boolean -> HumdrumGraph
  ; returns a HumdrumGraph of spines to the left or the right of the spine containing vertex.
  (local [(define index (token-spine-index vertex))

          (define operator (if right? > <))

          (define (get-first-index lst-or-hsh)
            (cond [(list? lst-or-hsh) (first lst-or-hsh)]
                  [else
                    ; unordered, but we only need a spine index, which
                    ; will be the same for all tokens in list of keys.
                    (first (hash-keys lst-or-hsh))]))

          (define (getter lst)
            ; BinarySearchTree would be faster. If operator is <, will waste time on spines with
            ; index > than; if operator is >, will waste time on spines with index <. Best case
            ; is only one spine, so no lefts or rights.
            (foldl (λ (f result)
                      (if (operator (get-first-index (first lst)) index)
                          (cons f result)
                          result))
                   empty
                   lst))]
    (humdrum-graph (getter (humdrum-graph-vertices hgraph))
                   (getter (humdrum-graph-edges hgraph)))))

(define (siblings hgraph vertex [right? #f])
  ; HumdrumGraph Vertex Boolean -> (listof Vertex)
  ; returns a list of vertices that are siblings to vertex
  (local [(define record_number (token-record-index vertex))

          (define (spine-split vertices)
            (local [(define (split? vertex_2)
                      (if (= (token-record-index vertex_2) record_number)
                          #t
                          #f))

                    (define (spine-split vertices siblings)
                      (cond [(empty? vertices) (reverse siblings)]
                            [else
                              (if (split? (first vertices))
                                  (spine-split (rest vertices) (cons (first vertices) siblings))
                                  (reverse siblings))]))]
              (spine-split vertices empty)))

          (define (first-sibling vertices)
            (cond [(empty? vertices) empty] ; is this case necessary?
                  [(= (token-record-index (first vertices)) record_number) vertices]
                  [else
                    (first-sibling (rest vertices))]))

          (define (abstract-siblings vertices)
            (apply append
                   (map spine-split
                        (map first-sibling vertices))))

          (define (left-siblings left_vertices)
            (abstract-siblings left_vertices))

          (define (right-siblings right_vertices)
            (abstract-siblings right_vertices))]
    (if right?
        (right-siblings (get-sibling-hgraph hgraph vertex #t))
        (append (left-siblings (get-sibling-hgraph hgraph vertex))
                (spine-split (list-ref (humdrum-graph-vertices hgraph) index))
                (right-siblings (get-sibling-hgraph hgraph vertex #t))))))

;; Converters

(define (humdrum-file->humdrum-graph hfile)
  ; TODO: returns a humdrum file converted to a humdrum graph
  (humdrum-graph empty empty))

; global-spine->humdrum-graph

; linked-spine->humdrum-graph

;; Traversal

(define (depth-first-traversal hgraph)
  ; TODO: traverses the graph depth first and does ...
  ;       returns ...
  (...))

(define (breadth-first-traversal hgraph)
  ; TODO: traverses the graph breadth first and does ...
  ;       returns ...
  (...))

; (depth-first-search ...)

; (breadth-first-seach ...)
