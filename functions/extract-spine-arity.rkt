; List of token records and empty list
; If token record is not spine structure, just add a copy of the previous list of numbers to the empty list
; If token record is spine structure
;    If spine structure is spine split, find which spines split and increment their numbers
;    If spine structure is spine join, find which spine joins and decrement its number.
;    Add to the empty list

; TODO: test
; extract-spine-arity
; (listof Record) -> SpineArity
; produces the spine arity from a list of token records

(define (extract-spine-arity records)
  (local [; first record must be exclusive interpretation, otherwise is humdrum syntax error
          (define number-global-spines (length (first records)))

          ; (listof Record) -> (listof (listof Natural))
          (define (lolon tokens)
            (local [(define (??? records lolon)
                      (cond [(empty? records) lolon]
                            [else
                               (??? (rest records) (cons (!!! (first records)) lolon))]))]
              (??? tokens empty)))

          ; Record -> (listof Natural)
          (define (!!! record)
            (cond [(spine-struct? record) ___]
                  [else
                     ___]))

          ; Record -> Boolean
          (define (spine-struct? record)
            (local [(define tokens (record-split record))

                    (define (spine-struct? lot)
                      (cond [(empty? lot) #f]
                            [(spine-structure? (first lot)) #t]
                            [else
                               (spine-struct? (rest lot))]))]
              (spine-struct? tokens)))]
    (make-spine-arity number-global-spines ???)))
