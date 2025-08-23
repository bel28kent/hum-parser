#lang racket/base

#|
	Function to convert a HumdrumFile to a HumdrumGraph.
|#

(require racket/bool
         racket/contract
         racket/local
         racket/list
         "../linked-spine/LinkedSpine.rkt"
         "../linked-spine/gspines-to-linked-spines-fn.rkt"
         "../spine-parsing-fn.rkt"
         "../HumdrumSyntax.rkt"
         "../TandemInterpretation.rkt"
         "HumdrumGraph.rkt")

