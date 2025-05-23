#lang racket/base

#|
	String functions.
|#

(require racket/contract
         racket/list
         racket/local
         "ExclusiveInterpretation.rkt"
         "HumdrumSyntax.rkt"
         "TandemInterpretation.rkt")

(provide split
         gather)

(define/contract (split str separator)
  (-> string? string? (listof string?))
  (local [(define (splitter str strings)
            (cond [(string=? str "") strings]
                  [else
                    (splitter
                      (substring str (pos-after-separator str))
                      (append strings (list (next-field str))))]))

          (define (pos-after-separator str)
            (local [(define (pos str position)
                      (cond [(string=? str "") position]
                            [(string=? (substring str 0 1) separator) (+ 1 position)]
                            [else
                             (pos (substring str 1) (+ 1 position))]))]
              (pos str 0)))

          (define (next-field str)
            (cond [(string=? str "") str]
                  [(string=? (substring str 0 1) separator) ""]
                  [else
                    (string-append (substring str 0 1)
                                   (next-field (substring str 1)))]))]
    (splitter str empty)))

(define/contract (gather strings separator)
  (-> (listof string?) string? string?)
  (local [(define (gatherer strings)
            (cond [(empty? strings) ""]
                  [(empty? (rest strings)) (first strings)]
                  [else
                    (string-append (first strings) separator (gatherer (rest strings)))]))]
    (gatherer strings)))
