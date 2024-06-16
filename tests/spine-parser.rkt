#lang racket

(require "../data-definitions/data-definitions.rkt"
         "../functions/spine-parser.rkt"
         test-engine/racket-tests)

(define KERN-TOKEN (make-token "**kern" "ExclusiveInterpretation" 0))

; tokens-by-spine
(check-expect (tokens-by-spine (list (list KERN-TOKEN))
                               (list (list 1)))
              (list (list (list KERN-TOKEN))))
(check-expect (tokens-by-spine (list (list KERN-TOKEN KERN-TOKEN))
                               (list (list 1) (list 1)))
              (list (list (list KERN-TOKEN))
                    (list (list KERN-TOKEN))))

(test)
