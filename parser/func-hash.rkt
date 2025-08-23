#lang racket/base

#|
	Functions for hash data types.
|#

(require (only-in racket/bool false? symbol=?))

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

(define (exclusive-interpretation? str)
  (hash-member? ExclusiveInterpretation str))

(define (exclusive-interpretation-match? interp str)
  (hash-match? ExclusiveInterpretation interp str))

(define (type-exclusive str)
  (get-type str ExclusiveInterpretation 'Unknown))

(define (tandem-interpretation? str)
  (hash-member? TandemInterpretation str))

(define (tandem-interpretation-match? interp str)
  (hash-match? TandemInterpretation interp str))

(define (type-tandem str)
  (get-type str TandemInterpretation 'Unknown))

(define (humdrum-record-type-match? type str)
  (hash-match? HumdrumRecord type str))

(define (type-humdrum-record str)
  (get-type str HumdrumRecord 'error))

(define (humdrum-token-type-match? type str)
  (hash-match? HumdrumToken type str))

(define (type-humdrum-token str)
  (get-type str HumdrumToken 'error))

(define (is-spine-content-str? str)
  (is-spine-content-type?
    (type-humdrum-record str)))

(define (is-spine-content-type? symbol)
  (false?
    (or (symbol=? 'GlobalComment symbol)
        (symbol=? 'ReferenceRecord symbol))))
