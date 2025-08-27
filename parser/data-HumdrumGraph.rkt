#lang racket/base

#|
	A HumdrumGraph is a directed graph. It is two-dimensional,
	and affords vertical (depth-first) and horizontal
	(breadth-first) traversal. In a musical context, these
	are akin to melodic and harmonic analysis.

	The humdrum-graph struct has two fields:
		- humdrum-graph-vertices:
			A list of lists of Humdrum tokens.
		- humdrum-graph-edges:
			A list of hashes. Each key is a token.
			Each value is a list of tokens with an
			edge to the key.

	The HumdrumGraph is ordered:
		- The first list of vertices is the leftmost spine
		  in the Humdrum file. The last list of vertices
		  is the rightmost spine in the Humdrum file.
		- The first vertex in each list is an exclusive
		  interpretation, the first token in any spine.
		  The last vertex in each list is a spine
		  terminator, the last token in any spine. See
		  Humdrum Guide, Chapter 5, "The Humdrum Syntax: A
		  Formal Definition."
		- All intervening data is in the order read from
		  the Humdrum file.

	NB: Each list in humdrum-graph-vertices is a flat list.
	    If spine splits have occured, sibling tokens follow
	    each other in the list:
		4a
		*^
		4a	4cc
		->
		(list 4a *^ 4a 4cc)
	    Thus, when traversing a HumdrumGraph, each token must
	    ask if the next token in the list is a sibling or a
	    child token.
|#

(provide (struct-out humdrum-graph))

(struct humdrum-graph (vertices edges)
        #:guard (λ (vertices edges name)
                   (unless (= (length vertices) (length edges))
                           (error name
                                  "Number of vertices and edges do not match"
                                  vertices edges)))
        #:transparent)
; (humdrum-graph (listof (listof Vertex)) (listof Hash))
;
; Vertex is a Token.
; (listof Vertex) is a Spine.
;
; Hash is a table of key (Token) - value (listof Token) pairs.
;
; Vertex is a node in the graph. Its associated (listof Token) in
; the Hash contains its Edges.
