#lang racket/base

#|
	Types related to Humdrum syntax.

	Reference: Humdrum Guide, Chapter 5.
|#

(provide HumdrumRecordType
         HumdrumTokenType
         StopSeparator
         TokenSeparator
         global-spine
         humdrum-file
         record
         spine-arity
         token)

(define HumdrumRecordType (hash 'ExclusiveInterpretation "^\\*{2}"
                                'GlobalComment           "^!{2}"
                                'LocalComment            "^!{1}"
                                'Measure                 "^="
                                'Reference               "^!{3}"
                                'TandemInterpretation    "^\\*{1}"
                                'Token                   "^[^\\*!=]"
))

(define HumdrumTokenType (hash 'ExclusiveInterpretation "^\\*{2}\\w+$"
                               'LocalComment            "^!{1}.*$"
                               'Measure                 "^=[^\\s]*$"
                               'NullSpineData           "^\\.$"
                               'SpineData               "^[^\\*!=\\.].+$"
                               'TandemInterpretation    "^\\*{1}[\\w\\d:>\\[\\]]+$"
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

(struct spine-arity (global lolon)
        #:transparent
        #:guard (λ (global lolon type-name)
                   (cond [(and (int&>=? global 1)
                               (andmap (λ (lon)
                                          (andmap (λ (n) (int&>=? n 1)) lon))
                                       lolon))
                          (values global lolon)]
                         [else
                           (error type-name
                                  "Natural ListOfListOfNatural; Given: ~a ~a"
                                  global lolon)])))

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

(define (int&>=? i lower)
  (and (integer? i) (>= i lower)))
