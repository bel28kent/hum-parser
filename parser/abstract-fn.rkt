#lang racket/base

#|
	Abstract functions.
|#

(require racket/bool
         racket/contract
         racket/list
         racket/local)

(provide filter-type
         hash-match?
         hash-member?
         get-type)

(define/contract (filter-type type-accessor symbol los)
  (-> struct-accessor-procedure? symbol? (listof struct?) (listof struct?))
  (local [(define (is-type? s)
            (symbol=? (type-accessor s) symbol))]
    (filter is-type? los)))

(define/contract (hash-match? hsh key str)
  (-> hash? symbol? string? boolean?)
  (regexp-match? (pregexp (hash-ref hsh key)) str))

(define/contract (hash-member? hsh str)
  (-> hash? string? boolean?)
  (local [(define (hash-member? keys)
            (cond [(empty? keys) #f]
                  [(hash-match? hsh (first keys) str) #t]
                  [else
                    (hash-member? (rest keys))]))]
    (hash-member? (hash-keys hsh))))

(define/contract (get-type str hsh base)
  (-> string? hash? symbol? symbol?)
  (local [(define (get-type keys)
            (cond [(empty? keys) (if (symbol=? base 'Unknown)
                                     'Unknown
                                     (error "syntax-error: could not match a" str))]
                  [else
                    (if (regexp-match? (pregexp (hash-ref hsh (first keys))) str)
                        (first keys)
                        (get-type (rest keys)))]))]
    (get-type (hash-keys hsh))))
