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
         get-type
         shift
         true?
         valmap)

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

(define/contract (shift lox)
  (-> list? list?)
  (cond [(empty? lox) empty]
        [else
          (rest lox)]))

(define/contract (true? b)
  (-> boolean? boolean?)
  (boolean=? #t b))

(define/contract (valmap val lop)
  (-> any/c (listof procedure?) list?)
  (local [(define (valmap lop)
            (cond [(empty? lop) empty]
                  [else
                    (cons ((first lop) val) (valmap (rest lop)))]))]
    (valmap lop)))
