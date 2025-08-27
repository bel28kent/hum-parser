#lang racket/base

#|
	Abstract functions.
|#

(require racket/bool
         racket/contract
         racket/list
         racket/local)

(provide filter-type
         member?)

(define/contract (filter-type type-accessor symbol los)
  (-> struct-accessor-procedure? symbol? (listof struct?) (listof struct?))
  (local [(define (is-type? s)
            (symbol=? (type-accessor s) symbol))]
    (filter is-type? los)))

(define (member? l e)
  ; TODO: returns #t if element e is a member of list l, else #f
  #f)
