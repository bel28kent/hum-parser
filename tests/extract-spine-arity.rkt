#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  hum-parser: tests for extract-spine-arity
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require "../data-definitions/data-definitions.rkt"
         "../functions/extract-spine-arity.rkt"
         test-engine/racket-tests)

; TODO
;  More robust tests would use real examples that contain each tag.
;  Could use constants.

(define TEST-TOKEN-1 (make-token "**kern" EXCLUSIVE-INTERPRETATION 3))
(define TEST-TOKEN-2 (make-token "*^"     SPINE-SPLIT 3))
(define TEST-TOKEN-3 (make-token "*v"     SPINE-JOIN 3))
(define TEST-TOKEN-4 (make-token "4a"     SPINE-DATA 3))

(define TEST-RECORD-1 (make-record "**kern" TOKEN (list TEST-TOKEN-1) 3))
(define TEST-RECORD-2 (make-record "*^"     TOKEN (list TEST-TOKEN-2) 3))
(define TEST-RECORD-3 (make-record "*v"     TOKEN (list TEST-TOKEN-3) 3))
(define TEST-RECORD-4 (make-record "4a"     TOKEN (list TEST-TOKEN-4) 3))

(define SPLIT (make-record "*\t*^\t*" TOKEN (list (make-token "*" NULL-INTERPRETATION 3)
                                                  (make-token "*^" SPINE-SPLIT 3)
                                                  (make-token "*" NULL-INTERPRETATION 3))
                                            3))
(define AFTER-SPLIT (make-record "4A\t4a\t4aa\t4aaa" TOKEN (list (make-token "4A" SPINE-DATA 4)
                                                                 (make-token "4a" SPINE-DATA 4)
                                                                 (make-token "4aa" SPINE-DATA 4)
                                                                 (make-token "4aaa" SPINE-DATA 4))
                                                            4))
(define JOIN (make-record "*\t*v\t*v\t*" TOKEN (list (make-token "*" NULL-INTERPRETATION 3)
                                                     (make-token "*v" SPINE-JOIN 3)
                                                     (make-token "*v" SPINE-JOIN 3)
                                                     (make-token "*" NULL-INTERPRETATION 3))
                                               3))
(define AFTER-JOIN (make-record "4A\t4a\t4aaa" TOKEN (list (make-token "4A" SPINE-DATA 4)
                                                                 (make-token "4a" SPINE-DATA 4)
                                                                 (make-token "4aaa" SPINE-DATA 4))
                                                            4))

; extract-spine-arity

; lolon
(check-expect (lolon (list TEST-RECORD-1)) (list (list 1)))

; lon-caller

; previous-spine-struct?
(check-expect (previous-spine-struct? TEST-RECORD-1) #f)
(check-expect (previous-spine-struct? TEST-RECORD-2) #t)
(check-expect (previous-spine-struct? TEST-RECORD-3) #t)
(check-expect (previous-spine-struct? TEST-RECORD-4) #f)

; split-or-join-token
(check-expect (split-or-join-token TEST-TOKEN-1) #f)
(check-expect (split-or-join-token TEST-TOKEN-2) SPINE-SPLIT)
(check-expect (split-or-join-token TEST-TOKEN-3) SPINE-JOIN)
(check-expect (split-or-join-token TEST-TOKEN-4) #f)

; split-or-join-record
(check-expect (split-or-join-record TEST-RECORD-1) #f)
(check-expect (split-or-join-record TEST-RECORD-2) SPINE-SPLIT)
(check-expect (split-or-join-record TEST-RECORD-3) SPINE-JOIN)
(check-expect (split-or-join-record TEST-RECORD-4) #f)

; struct-lon
(check-expect (struct-lon SPLIT AFTER-SPLIT (list 1 1 1)) (list 1 2 1)) ; split case
(check-expect (struct-lon JOIN AFTER-JOIN (list 1 2 1)) (list 1 1 1)) ; join case

; one-per-spine
(check-expect (one-per-spine 5) (list 1 1 1 1 1))

; copy-previous
(check-expect (copy-previous 1 (list (list 1)))
              (list 1))
(check-expect (copy-previous 1 (list (list 1 1 1)
                                     (list 1 2 1)))
              (list 1 2 1))

(test)
