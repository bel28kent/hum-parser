#lang racket/base

#|
	Types related to Humdrum syntax.

	Reference: Humdrum Guide, Chapter 5.
|#

(require (only-in "abstract-fn.rkt" get-type hash-match? hash-member?))

(provide HumdrumRecordType
         HumdrumTokenType
         StopSeparator
         TokenSeparator
         (struct-out global-spine)
         (struct-out humdrum-file)
         (struct-out record)
         (struct-out spine-arity)
         (struct-out token)
         humdrum-record-type-match?
         type-humdrum-record
         humdrum-token-type-match?
         type-humdrum-token)

(define HumdrumRecordType (hash 'ExclusiveInterpretation "^\\*\\*.*$"
                                'GlobalComment           "^!![^!].*$"
                                'LocalComment            "^![^!].*$"
                                'Measure                 "^="
                                'Reference               "^!!!.*$"
                                'TandemInterpretation    "^\\*[^\\*].*$"
                                'Token                   "^[^\\*!=].*"
))

(define HumdrumTokenType (hash 'ExclusiveInterpretation "^\\*\\*\\w+$"
                               'LocalComment            "^!{1}.*$"
                               'Measure                 "^=[^\\s]*$"
                               'NullSpineData           "^\\.$"
                               'SpineData               "^[^\\*!=\\.].*$"
                               'TandemInterpretation    "^\\*[\\w\\^:>\\-\\[\\]]*$"
))

(define StopSeparator " ")

(define TokenSeparator "\t")

(struct global-spine (interp tokens spine-index)
        #:transparent
        #:guard (λ (interp tokens spine-index type-name)
                   (cond [(and (symbol? interp)
                               (andmap (λ (lot) (andmap token? lot)) tokens)
                               (int&>=? spine-index 0))
                          (values interp tokens spine-index)]
                         [else
                           (error type-name
                                  "Symbol ListOfTokens Natural; Given: ~a ~a ~a"
                                  interp tokens spine-index)])))

(struct humdrum-file (records)
        #:transparent
        #:guard (λ (records type-name)
                   (cond [(andmap record? records)
                          (values records)]
                         [else
                           (error type-name
                                  "ListOfRecords; Given: ~a"
                                  records)]))
        #:constructor-name hfile)

(struct record (record type split record-index)
        #:transparent
        #:guard (λ (record type split record-index type-name)
                   (cond [(and (string? record)
                               (symbol? type)
                               (or (and (= (length split) 1) (andmap string? split))
                                   (andmap token? split))
                               (int&>=? record-index 0))
                          (values record type split record-index)]
                         [else
                           (error type-name
                                  "String Symbol ListOfString OR ListofToken Natural; Given: ~a ~a ~a ~a"
                                  record type split record-index)])))

(struct spine-arity (file byrecord)
        #:transparent
        #:guard (λ (file byrecord type-name)
                   (cond [(and (int&>=? file 1)
                               (andmap (λ (lon)
                                          (andmap (λ (n) (int&>=? n 1)) lon))
                                       byrecord))
                          (values file byrecord)]
                         [else
                           (error type-name
                                  "Natural ListOfListOfNatural; Given: ~a ~a"
                                  file byrecord)])))

(struct token (token type record-index field-index)
        #:transparent
        #:guard (λ (token type record-index field-index type-name)
                   (cond [(and (string? token)
                               (symbol? type)
                               (int&>=? record-index 0)
                               (int&>=? field-index 0))
                          (values token type record-index field-index)]
                         [else
                           (error type-name
                                  "String Symbol Natural Natural; Given: ~a ~a ~a ~a"
                                  token type record-index field-index)])))

(define (humdrum-record-type-match? type str)
  (hash-match? HumdrumRecordType type str))

(define (type-humdrum-record str)
  (get-type str HumdrumRecordType 'error))

(define (humdrum-token-type-match? type str)
  (hash-match? HumdrumTokenType type str))

(define (type-humdrum-token str)
  (get-type str HumdrumTokenType 'error))

(define (int&>=? i lower)
  (and (integer? i) (>= i lower)))
