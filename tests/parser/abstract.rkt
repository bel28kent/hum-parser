#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  hum-parser: tests for abstract functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require "../data-definitions/data-definitions.rkt"
         "../functions/abstract.rkt"
         "../functions/file.rkt"
         test-engine/racket-tests)

(provide BERG-PATH)

(define BERG-PATH "data/berg01.pc")

; TODO
;  More robust tests would use real examples that contain each tag.
;  Could use constants.

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
(check-expect (map (λ (r) (record-type r)) (filter-type record-type
                                                        TOKEN
                                                        (hfile-records (los->hfile (read-file BERG-PATH)))))
              (list TOKEN TOKEN TOKEN TOKEN TOKEN
                    TOKEN TOKEN TOKEN TOKEN TOKEN
                    TOKEN TOKEN TOKEN TOKEN TOKEN))
(test)