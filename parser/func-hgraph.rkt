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

; TODO: optional argument to only return result of right-siblings, useful for bft.
(define (siblings hgraph vertex)
  ; TODO: returns a list of vertices that are siblings to vertex
  ; cf. NB in data-HumdrumGraph.rkt. This will involve asking
  ; if the next element(s) in the list that this vertex came from
  ; are siblings (spine split case) and looking for siblings in
  ; the neighboring spines.
  (local [(define (spine-split ...)
            ; TODO: returns a list of vertices that are siblings
            ; to vertex AND in the same spine as vertex (spine
            ; split case.
            ; returns list of length >=0
            empty)

          (define (left-siblings ...)
            ; TODO: returns a list of vertices that are siblings
            ; to vertex AND in any spines to the left of this
            ; vertex's spine.
            ; returns list of length >=0
            empty)

          (define (right-siblings ...)
            ; TODO: returns a list of vertices that are siblings
            ; to vertex AND in any spines to the right of this
            ; vertex's spine.
            ; returns list of length >=0
            empty)]
    ()))

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
