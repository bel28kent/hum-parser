#lang racket/base

#|
	Spine parsing functions.
|#

(require racket/bool
         racket/contract
         racket/list
         racket/local
         "ExclusiveInterpretation.rkt"
         "HumdrumSyntax.rkt"
         "string-fn.rkt")

(provide spine-parser
         unwrap
         byrecord->byspine
         tokens-by-spine
         gspine-wrapper
         gspines->strings
         extract-spine-arity
         get-byrecord
         maybe-spine-structure
         was-spine-struct?
         split-or-join-token?
         after-struct
         one-per-spine)

(define/contract (spine-parser hfile)
  (-> humdrum-file? (listof global-spine?))
  (gspine-wrapper
    (tokens-by-spine
      (unwrap hfile)
      (byrecord->byspine
        (extract-spine-arity hfile)))))

(define/contract (unwrap hfile)
  (-> humdrum-file? (listof (listof token?)))
  (foldr (λ (f r) (cons (record-split f) r))
         empty
         (filter (λ (r) (is-spine-content-type? (record-type r)))
           (humdrum-file-records hfile))))

(define/contract (byrecord->byspine spine-arity)
  (-> spine-arity? (listof (listof natural-number/c)))
  (local [(define num-spines (spine-arity-file spine-arity))

          (struct result (spine-list remaining))

          (define (for-spines byrecord)
            (local [(define (iterator num-spine spine-lists result)
                      (cond [(= num-spine num-spines)
                             (reverse
                               (cons (result-spine-list result) spine-lists))]
                            [else
                              (iterator (add1 num-spine)
                                        (cons (result-spine-list result) spine-lists)
                                        (byspine (result-remaining result)))]))]
              (local [(define first-spine (byspine byrecord))]
                (iterator 1 empty (result (result-spine-list first-spine)
                                          (result-remaining first-spine))))))

          (define (byspine byrecord)
            (local [(define (iterator arity spine-list remaining)
                      (cond [(empty? arity) (result (reverse spine-list)
                                                    (reverse remaining))]
                            [else
                              (iterator (rest arity)
                                        (cons (first (first arity))
                                              spine-list)
                                        (cons (rest (first arity))
                                              remaining))]))]
              (iterator byrecord empty empty)))]
    (for-spines (spine-arity-byrecord spine-arity))))

(define/contract (tokens-by-spine unwrapped byspine)
  (-> (listof (listof token?)) (listof (listof natural-number/c))
      (listof (listof (listof token?))))
  (local [(struct result (spine-list remaining))

          (define (for-spines tokens arities)
            (local [(define (iterator tokens arities spine-list)
                      (cond [(andmap empty? tokens) (reverse spine-list)]
                            [else
                              (local [(define output (for-tokens tokens (first arities)))]
                                (iterator (result-remaining output)
                                          (rest arities)
                                          (cons (result-spine-list output) spine-list)))]))]
              (iterator tokens arities empty)))

          (define (for-tokens tokens arity)
            (local [(define (iterator tokens arity spine-list remaining)
                      (cond [(empty? tokens) (result (reverse spine-list)
                                                     (reverse remaining))]
                            [else
                              (local [(define output
                                              (tokens-iterator (first tokens) (first arity)))]
                                (iterator (rest tokens)
                                          (rest arity)
                                          (cons (result-spine-list output) spine-list)
                                          (cons (result-remaining output) remaining)))]))]
              (iterator tokens arity empty empty)))

          (define (tokens-iterator tokens arity)
            (local [(define (iterator tokens counter spine-list)
                      (cond [(= counter arity) (result (reverse spine-list) tokens)]
                            [else
                              (iterator (rest tokens)
                                        (add1 counter)
                                        (cons (first tokens) spine-list))]))]
              (iterator (rest tokens) 1 (list (first tokens)))))]
    (for-spines unwrapped byspine)))

(define/contract (gspine-wrapper spines)
  (-> (listof (listof (listof token?))) (listof global-spine?))
  (local [(define (gspine-wrapper spines gspines spine-index)
            (cond [(empty? spines) (reverse gspines)]
                  [else
                    (gspine-wrapper
                      (rest spines)
                      (cons (wrapper (first (first (first spines)))
                                     (first spines)
                                     spine-index)
                            gspines)
                      (add1 spine-index))]))

          (define (wrapper interp spine spine-index)
            (global-spine (type-exclusive (token-token interp))
                          spine
                          spine-index))]
    (gspine-wrapper spines empty 0)))

(define/contract (gspines->strings gspines)
  (-> (listof global-spine?) (listof (listof string?)))
  (local [(define (gspines->strings gspines)
            (local [(define (gspines->strings gspines lolos)
                      (cond [(empty? gspines) (reverse lolos)]
                            [else
                             (gspines->strings (rest gspines)
                                               (cons (gspine->strings (first gspines))
                                                     lolos))]))]
              (gspines->strings gspines empty)))

          (define (gspine->strings gspine)
            (local [(define tokens (global-spine-tokens gspine))

                    (define (tokens->strings tokens)
                      (local [(define (tokens->strings tokens strings)
                                (cond [(empty? tokens) (reverse strings)]
                                      [else
                                        (tokens->strings (rest tokens)
                                                         (cons
                                                           (gather
                                                             (map token-token (first tokens))
                                                             TokenSeparator)
                                                           strings))]))]
                        (tokens->strings tokens empty)))]
              (tokens->strings tokens)))]
    (gspines->strings gspines)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hum-parser: functions: extract-spine-arity
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; BASE CASE:  a list of only one record, the exclusive interpretation record
; ASSUMPTION: the first record must be the exclusive interpretation record,
;             otherwise is humdrum syntax error
; TODO move helpers to local scope

(define/contract (extract-spine-arity hfile)
  (-> humdrum-file? spine-arity?)
  (local [(define token-records (filter (λ (r) (is-spine-content-type? (record-type r)))
                                        (humdrum-file-records hfile)))]
    (spine-arity (length (record-split (first token-records)))
                 (get-byrecord token-records))))

(define/contract (get-byrecord records)
  (-> (listof record?) (listof (listof natural-number/c)))
  (local [(define (iterator records byrecords previous)
            (cond [(empty? records) (reverse byrecords)]
                  [else
                    (iterator (rest records)
                              (cons (maybe-spine-structure previous (first byrecords)) byrecords)
                              (first records))]))]
    (if (= (length records) 1)
        (list (one-per-spine (length (record-split (first records)))))
        (iterator (rest records)
                  (list (one-per-spine (length (record-split (first records)))))
                  (first records)))))

(define/contract (maybe-spine-structure previous-record previous-byrecord)
  (-> record? (listof natural-number/c) (listof natural-number/c))
  (cond [(was-spine-struct? previous-record) (after-struct previous-record previous-byrecord)]
        [else
         previous-byrecord]))

(define/contract (was-spine-struct? previous)
  (-> record? boolean?)
  (local [(define tokens (record-split previous))

          (define (spine-struct? lot)
            (cond [(empty? lot) #f]
                  [(boolean=? #t (split-or-join-token? (first lot))) #t]
                  [else
                   (spine-struct? (rest lot))]))]
    (spine-struct? tokens)))

(define/contract (split-or-join-token? token)
  (-> token? boolean?)
  (local [(define type (token-type token))]
    (or (symbol=? type 'SpineSplit)
        (symbol=? type 'SpineJoin))))

(define/contract (after-struct previous-record previous-byrecord)
  (-> record? (listof natural-number/c) (listof natural-number/c))
  (local [(define previous-tokens (record-split previous-record))

          (define (get-num-joins tokens)
            (cond [(empty? tokens) 0]
                  [(not (symbol=? (token-type (first tokens)) 'SpineJoin)) 0]
                  [else
                   (add1 (get-num-joins (rest tokens)))]))

          (define (remove-joins tokens num-joins)
            (local [(define (remove-joins lot counter)
                      (cond [(= counter num-joins) lot]
                            [else
                              (remove-joins (rest lot) (add1 counter))]))]
              (remove-joins tokens 0)))

          (define (after-struct previous-tokens)
            (local [(define (after-struct tokens tokens-processed tokens-in-spine previous current)
                      (cond [(empty? tokens) (reverse current)]
                            [(symbol=? (token-type (first tokens)) 'SpineSplit)
                             (if (= (add1 tokens-processed) (first previous))
                                 (after-struct (rest tokens)
                                               0 0
                                               (rest previous)
                                               (cons (+ 2 tokens-in-spine) current))
                                 (after-struct (rest tokens)
                                               (add1 tokens-processed)
                                               (+ 2 tokens-in-spine)
                                               previous
                                               current))]
                            [(symbol=? (token-type (first tokens)) 'SpineJoin)
                             (local [(define num-joins (get-num-joins tokens))
                                     (define joins-removed (remove-joins tokens num-joins))]
                               (if (= (+ num-joins tokens-processed) (first previous))
                                   (after-struct joins-removed
                                                 0 0
                                                 (rest previous)
                                                 (cons (add1 tokens-in-spine) current))
                                   (after-struct joins-removed
                                                 (+ num-joins tokens-processed)
                                                 (add1 tokens-in-spine)
                                                 previous
                                                 current)))]
                            [(= (add1 tokens-processed) (first previous))
                             (after-struct (rest tokens)
                                           0 0
                                           (rest previous)
                                           (cons (add1 tokens-in-spine) current))]
                            [else
                             (after-struct (rest tokens)
                                           (add1 tokens-processed)
                                           (add1 tokens-in-spine)
                                           previous
                                           current)]))]
              (after-struct previous-tokens 0 0 previous-byrecord empty)))]
    (after-struct previous-tokens)))

(define (one-per-spine number-global-spines)
  (-> natural-number/c (listof natural-number/c))
  (local [(define (one-per-spine counter)
            (cond [(= counter number-global-spines) empty]
                  [else
                   (cons 1 (one-per-spine (add1 counter)))]))]
    (one-per-spine 0)))
