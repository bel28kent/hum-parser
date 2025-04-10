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

(define/contract (filter-type proc symbol lox)
  (-> procedure? symbol? (listof any) (listof any))
  (local [(define (is-type x)
            (symbol=? (proc x) symbol))]
    (filter is-type lox)))

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
  (local [(define (type f r)
            (if (regexp-match? (pregexp (hash-ref hsh f)) str)
                f
                r))

          (define base (if (symbol=? base 'Unknown)
                           'Unknown
                           type-error))

          (define keys (hash-keys hsh))

          (define type-error (λ () (error
                                     (string-append "syntax-error: could not match a "
                                                    (symbol->string 'hsh))
                                     str)))]
    (foldl type base keys)))

(define/contract (shift lox)
  (-> list? list?)
  (cond [(empty? lox) empty]
        [else
          (rest lox)]))

(define/contract (true? b)
  (-> boolean? boolean?)
  (boolean=? #t b))

(define/contract (valmap val lop)
  (-> any (listof procedure?) list?)
  (local [(define (valmap lop)
            (cond [(empty? lop) empty]
                  [else
                    (cons ((first lop) val) (valmap (rest lop)))]))]
    (valmap lop)))
