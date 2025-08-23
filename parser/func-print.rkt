#lang racket/base

#|
	Printing functions.
|#

(define/contract (display-hgraph hgraph)
  (-> humdrum-graph? void?)
  (local [(define (fn-for-root root)
            (local [(define (iterator branches factor)
                      (cond [(empty? branches) (void)]
                            [else
                              (begin (fn-for-lon (first branches) factor #f #f)
                                     (iterator (rest branches) factor))]))]
              (iterator (root-branches root) 0)))

          (define (fn-for-lon branch factor left? right?)
            (cond [(empty? branch) (void)]
                  [(leaf? (first branch)) (begin (fn-for-leaf (first branch)
                                                              factor
                                                              left?
                                                              right?)
                                                 (fn-for-lon (rest branch)
                                                             factor
                                                             left?
                                                             right?))]
                  [else
                    (begin (displayln (string-append (indentation factor)
                                                     (if left?
                                                         "left: "
                                                         "")
                                                     (if right?
                                                         "right: "
                                                         "")
                                                     "(parent "
                                                     (fn-for-token
                                                       (parent-token
                                                         (first branch)))
                                                     ")"))
                           (fn-for-lon (parent-left (first branch))
                                       (add1 factor)
                                       #t
                                       #f)
                           (fn-for-lon (parent-right (first branch))
                                       (add1 factor)
                                       #f
                                       #t)
                           (fn-for-lon (rest branch)
                                       factor
                                       left?
                                       right?))]))

          (define (fn-for-leaf leaf factor left? right?)
            (displayln (string-append (indentation factor)
                                      (if left?
                                          "left: "
                                          "")
                                      (if right?
                                          "right: "
                                          "")
                                      "(leaf "
                                      (fn-for-token (leaf-token leaf))
                                      ")")))

          (define (fn-for-token token)
            (string-append "(token "
                           (string-append "\"" (token-token token) "\"")
                           " "
                           (if (false? (token-type token))
                               "#f"
                               (token-type token))
                           " "
                           (number->string (token-record-index token))
                           ")"))

          (define (indentation factor)
            (make-string factor #\tab))]
    (fn-for-root (humdrum-graph-root hgraph))))
