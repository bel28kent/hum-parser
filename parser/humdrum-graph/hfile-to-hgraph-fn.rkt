#lang racket/base

#|
	Function to convert a HumdrumFile to a HumdrumGraph.
|#

(require racket/contract
         racket/list
         racket/local
         "../ExclusiveInterpretation.rkt"
         "../HumdrumSyntax.rkt"
         "../TandemInterpretation.rkt"
         "../linked-spine/LinkedSpine.rkt"
         "../linked-spine/gspines-to-linked-spines-fn.rkt"
         "../spine-parsing-fn.rkt"
         "HumdrumGraph.rkt")

#|
(provide hfile->hgraph)

; hfile->hgraph
; HumdrumFile -> HumdrumGraph
; converts the HumdrumFile to a HumdrumGraph
(define/contract (hfile->hgraph hfile)
  (-> humdrum-file? humdrum-graph?)
  (local [(define linked-spines (gspines->linked-spines (spine-parser hfile) hfile))

          ; LinkedSpine -> (listof Node)
          (define (linked-spine->branch l-spine)
            ())]
    (hgraph (root (map linked-spine->branch linked-spines)))))
|#
