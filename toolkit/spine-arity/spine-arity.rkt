#lang racket/base

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hum-parser: tools: spine-arity
;;    Prints a 2D array of numbers, each representing
;;    how many tokens in a record belong to a spine
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require racket/cmdline
         "../../parser/data-definitions/data-definitions.rkt"
         (only-in "../../parser/functions/file.rkt"
                  path->hfile)
         (only-in "../../parser/functions/extract-spine-arity.rkt"
                  extract-spine-arity))

(define spine-arity
  (command-line
    #:args (filename)
    (foldr
      (λ (f rnr) (displayln f))
      (void)
      (spine-arity-lolon (extract-spine-arity (path->hfile filename))))))
