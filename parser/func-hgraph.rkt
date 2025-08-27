#lang racket/base

#|
	HumdrumGraph Functions.
|#

(require racket/list)

;; Basic operations
;; NB: A HumdrumGraph is immutable, so add, remove, and set are invalid.

(define (adjacent? graph vertex_1 vertex_2)
  ; TODO: returns true if there is an edge from vertex_1 to vertex_2
  #f)

(define (children graph vertex)
  ; TODO: returns a list of vertices with an edge to vertex
  empty)

(define (siblings graph vertex)
  ; TODO: returns a list of vertices that are siblings to vertex
  ; cf. NB in data-HumdrumGraph.rkt. This will involve asking
  ; if the next element(s) in the list that this vertex came from
  ; are siblings (spine split case) and looking for siblings in
  ; the neighboring spines.
  empty)

;; Converters

(define (humdrum-file->humdrum-graph hfile)
  ; TODO: returns a humdrum file converted to a humdrum graph
  (humdrum-graph empty empty))

; global-spine->humdrum-graph

; linked-spine->humdrum-graph

;; Traversal

(define (depth-first-traversal graph)
  ; TODO: traverses the graph depth first and does ...
  ;       returns ...
  (...))

(define (breadth-first-traversal graph)
  ; TODO: traverses the graph breadth first and does ...
  ;       returns ...
  (...))
