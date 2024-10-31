#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  hum-parser: tests for abstract functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require "../../parser/data-definitions/data-definitions.rkt"
         "../../parser/functions/abstract.rkt"
         "../../parser/functions/file.rkt"
         test-engine/racket-tests)

(define BERG-PATH "data/berg01.pc")

; tag=?
(check-expect (tag=? "!!!COM: Scriabin, Alexander" 3 REFERENCE-TAG) #t)
(check-expect (tag=? "*\t*8va\t*" 3 REFERENCE-TAG)                  #f)
(check-expect (tag=? "!! This is a global comment" 2 GLOBAL-TAG)    #t)
(check-expect (tag=? "!\t! Possibly Bn" 1 LOCAL-TAG)                #t)
(check-expect (tag=? "**kern\t**kern" 2 EXCLUSIVE-TAG)              #t)
(check-expect (tag=? "!! Global comment" 2 EXCLUSIVE-TAG)           #f)
(check-expect (tag=? "*\t*8va\t*" 1 TANDEM-TAG)                     #t)
(check-expect (tag=? "=1\t=1" 1 MEASURE-TAG)                        #t)
(check-expect (tag=? "*\t*8va\t*" 1 MEASURE-TAG)                    #f)

; filter-type
(check-expect (filter-type record-type TOKEN empty) empty)
(check-expect (map (λ (r) (record-type r))
                   (filter-type record-type
                                TOKEN
                                (hfile-records (path->hfile BERG-PATH))))
              (list TOKEN TOKEN TOKEN TOKEN TOKEN
                    TOKEN TOKEN TOKEN TOKEN TOKEN
                    TOKEN TOKEN TOKEN TOKEN TOKEN))

; shift
(check-expect (shift empty) empty)
(check-expect (shift (list 1)) empty)
(check-expect (shift (list 1 2 3)) (list 2 3))

; valmap
(check-expect (valmap 1 empty) empty)
(check-expect (valmap 1 (list zero?)) (list #f))
(check-expect (valmap 1 (list zero? positive? add1))
              (list #f #t 2))

; true?
(check-expect (true? #t) #t)
(check-expect (true? #f) #f)

(test)
