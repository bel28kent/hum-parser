#lang racket/base

#|
	HumdrumGraph functions.

	A child vertex has an edge from its parent vertex. The child is on the next record in the
	HumdrumFile, so:
		(token-record-index parent_vertex) ; if 0
		(token-record-index child_vertex)  ; then 1

	A vertex has no edges to its sibling vertices. Siblings are on the same record in the
	HumdrumFile, so:
		(token-record-index spine_1_b) ; if 0
		(token-record-index spine_1_a) ; then 0 (same spine, left sibling)
		(token-record-index spine_1_c) ; then 0 (same spine, right sibling)
		(token-record-index spine_0)   ; then 0 (left spine sibling)
		(token-record-index spine_2)   ; then 0 (right spine sibling)
|#

(require racket/list
         racket/local
         "data-HumdrumGraph.rkt"
         "func-abstract.rkt")

;; ------------------------------------------------------------------------------------------------
;; Basic operations

(define (adjacent? edges vertex_1 vertex_2)
  ; Hash Vertex Vertex -> Boolean
  ; returns true if vertex_2 has an edge to vertex_1.
  ; NB: if true, vertex_2 is necessarily a child of vertex_1.
  (if (member? (hash-ref edges vertex_1) vertex_2)
       #t
       #f))

(define (children edges vertex)
  ; Hash Vertex -> (listof Vertex)
  ; returns a list of vertices with an edge to vertex.
  (hash-ref edges vertex))

(define (get-sibling-hgraph hgraph vertex [right? #f])
  ; HumdrumGraph Vertex Boolean -> HumdrumGraph
  ; returns a HumdrumGraph of spines to the left or the right of the spine containing vertex.
  ; NB: result will not include siblings in vertex's spine.
  (local [(define index (token-spine-index vertex))

          (define index-comparison (if right?
                                       (λ (v) (> (token-spine-index v) i))
                                       (λ (v) (< (token-spine-index v) i))))

          (define (get-first vertices_or_edges)
            ; (listof Vertex) or Hash -> Vertex
            ; returns the first vertex in a list of vertices, or the first vertex in a list of
            ; keys from a hash of edges.
            (if (list? vertices_or_edges)
                (first vertices_or_edges)
                (first (hash-keys vertices_or_edges))))

          (define (get-siblings lst)
            ; (listof (listof Vertex) or Hash) -> (listof (listof Vertex) or Hash)
            ; returns siblings to the left or the right of index.
            (foldr (λ (f result)
                      (if (index-comparison (get-first f))
                          (cons f result)
                          result))
                   empty
                   lst))]
    (humdrum-graph (get-siblings (humdrum-graph-vertices hgraph))
                   (get-siblings (humdrum-graph-edges hgraph)))))

(define (siblings hgraph vertex [right? #f])
  ; HumdrumGraph Vertex Boolean -> (listof Vertex)
  ; returns a list of vertices that are siblings to vertex:
  ; - sibling vertices in left spines
  ; - sibling vertices to the left, in vertex's spine (spine split case 1)
  ; - sibling vertices to the right, in vertex's spine (spine split case 2)
  ; - sibling vertices in right spines.
  ; NB: result will not contain vertex.
  ; optionally only returns right siblings, useful for breadth-first traversal.
  (local [(define field-index (token-field-index vertex))

          (define spine-index (token-spine-index vertex))

          (define (sibling? vertex_2)
            ; Vertex -> Boolean
            ; returns true if vertex_2 is a sibling to parameter vertex.
            (and (not (eq? vertex vertex_2))
                 (= spine-index (token-spine-index vertex_2))))

          (define (get-spine-siblings vertices)
            ; (listof Vertex) -> (listof Vertex)
            ; returns a given spine's siblings to parameter vertex.
            (filter sibling? vertices))

          (define (other-spines-siblings spines)
            ; (listof (listof Vertex)) -> (listof Vertex)
            ; returns sibling vertices in left spines.
            (append (map get-spine-siblings spines)))]
    (if right?
        (append (filter (λ (vtx) (> (token-field-index vtx) field-index))
                        (get-spine-siblings
                          (list-ref (humdrum-graph-vertices hgraph) spine-index)))
                (other-spines-siblings
                  (humdrum-graph-vertices
                    (get-sibling-hgraph hgraph vertex #t)))
        (append (other-spines-siblings
                  (humdrum-graph-vertices
                    (get-sibling-hgraph hgraph vertex)))
                (get-spine-siblings
                  (list-ref (humdrum-graph-vertices hgraph) spine-index))
                (other-spines-siblings
                  (humdrum-graph-vertices
                    (get-sibling-hgraph hgraph vertex #t)))))))

(define (add hgraph vertex)
  ; HumdrumGraph Vertex -> HumdrumGraph or Exception
  ; returns a new HumdrumGraph with vertex added.
  ; NB: vertex must have a unique position within a spine.
  (local [(define spine-index (token-spine-index vertex))

          (define (try-add vertices)
            ; TODO
            ; (listof Vertex) -> (listof Vertex) or Exception
            ; returns vertices with vertex added, or an exception if no unique position.
            ;
            ; Exception should be handled by add-vertex, otherwise execution will stop
            empty)

          (define (add-vertex vertices)
            ; TODO
            ; (listof (listof Vertex)) -> (listof (listof Vertex))
            ; returns vertices with vertex added.
            (cond [(empty? vertices) empty]
                  [else
                    ;                  could use accumulator for how many spines passed
                    (if (= spine-index (token-spine-index (first (first vertices))))
                        (cons (try-add (first vertices)) (add-vertex (rest vertices)))
                        (cons (first vertices) (add-vertex (rest vertices))))]))

          (define (add-edge edges)
            ; TODO
            ; (listof Hash) -> (listof Hash)
            ; returns edges with edge to  and from vertex added.
            empty)]
    (humdrum-graph (add-vertex (humdrum-graph-vertices hgraph))
                   (add-edge (humdrum-graph-edges hgraph))))

(define (remove hgraph vertex)
  ; HumdrumGraph Vertex -> HumdrumGraph
  ; returns a new HumdrumGraph with vertex removed.
  (local [(define (remove-vertex vertices)
            ; TODO
            ; (listof (listof Vertex)) -> (listof (listof Vertex))
            ; returns vertices with vertex removed.
            empty)

          (define (remove-edge edges)
            ; TODO
            ; (listof Hash) -> (listof Hash)
            ; returns edges with edges to and from vertex removed.
            empty)]
    (humdrum-graph (remove-vertex (humdrum-graph-vertices hgraph))
                   (remove-edge (humdrum-graph-edges hgraph))))

(define (set hgraph vertex_old vertex_new)
  ; HumdrumGraph Vertex -> HumdrumGraph
  ; returns a new HumdrumGraph with vertex_old set to vertex_new.
  (local [(define spine-index (token-spine-index vertex_old))

          (define (setter vertices)
            (cond [(empty? vertices) empty]
                  [(eq? vertex_old (first vertices)) (cons vertex_new (setter (rest vertices)))]
                  [else
                    (cons (first vertices) (setter (rest vertices)))]))

          (define (set-vertex vertices)
            ; TODO
            ; (listof (listof Vertex)) -> (listof (listof Vertex))
            ; returns vertices with vertex_old set to vertex_new.
            (cond [(empty? vertices) empty]
                  [(= spine-index (token-spine-index (first (first vertices))))
                   (cons (setter (first vertices)) (set-vertex (rest vertices)))]
                  [else
                    (cons (first vertices) (set-vertex (rest vertices)))]))

          (define (set-edge edges)
            ; (listof Hash) -> (listof Hash)
            ; returns edges with vertex_old key set to vertex_new,
            ; and vertex_old set to vertex_new in any lists of edges.
            (local [(define ()
                      ())]
              ()))]
    (humdrum-graph (set-vertex (humdrum-graph-vertices hgraph))
                   (set-edge (humdrum-graph-edges hgraph)))))





;; -----------------------------------------------------------------------------------------------
;; Abstract traversal functions

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
