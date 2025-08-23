#lang racket/base

#|
	Function to convert a list of GlobalSpine to a list of LinkedSpine.
|#

(require racket/bool
         racket/contract
         racket/list
         racket/local
         "../HumdrumSyntax.rkt"
         "LinkedSpine.rkt")

(provide gspines->linked-spines)

