#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hum-parser: tests for spine-parser
;;    also tested in spine-parser-scriabin-test
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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

; lololot->logs
(check-expect (lololot->logs (tokens-by-spine (list (list KERN-TOKEN))
                                              (list (list 1))))
              (list (make-global-spine (list (list KERN-TOKEN)) 0)))
(check-expect (lololot->logs (tokens-by-spine (list (list KERN-TOKEN KERN-TOKEN))
                                              (list (list 1) (list 1))))
              (list (make-global-spine (list (list KERN-TOKEN)) 0)
                    (make-global-spine (list (list KERN-TOKEN)) 1)))

; logs->lolos
(check-expect (logs->lolos (list (make-global-spine (list (list KERN-TOKEN)) 0)))
              (list (list "**kern")))
(check-expect (logs->lolos (list (make-global-spine (list (list KERN-TOKEN)) 0)
                                 (make-global-spine (list (list KERN-TOKEN)) 1)))
              (list (list "**kern") (list "**kern")))

(test)
