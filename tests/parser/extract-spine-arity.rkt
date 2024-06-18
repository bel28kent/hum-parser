#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  hum-parser: tests for extract-spine-arity
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require "../data-definitions/data-definitions.rkt"
         "../functions/abstract.rkt"
         "../functions/extract-spine-arity.rkt"
         "../functions/file.rkt"
         test-engine/racket-tests)

(provide BERG)
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

(define SPLIT (make-record "*\t*^\t*"
                           TOKEN
                           (list (make-token "*" NULL-INTERPRETATION 3)
                                 (make-token "*^" SPINE-SPLIT 3)
                                 (make-token "*" NULL-INTERPRETATION 3))
                           3))
(define SPLIT-LEFT (make-record "*^\t*\t*"
                                TOKEN
                                (list (make-token "*^" SPINE-SPLIT 3)
                                      (make-token "*" NULL-INTERPRETATION 3)
                                      (make-token "*" NULL-INTERPRETATION 3))
                                3))
(define SPLIT-RIGHT (make-record "*\t*\t*^"
                                 TOKEN
                                 (list (make-token "*" NULL-INTERPRETATION 3)
                                       (make-token "*" NULL-INTERPRETATION 3)
                                       (make-token "*^" SPINE-SPLIT 3))
                                 3))
(define AFTER-SPLIT (make-record "4A\t4a\t4aa\t4aaa"
                                 TOKEN
                                 (list (make-token "4A" SPINE-DATA 4)
                                       (make-token "4a" SPINE-DATA 4)
                                       (make-token "4aa" SPINE-DATA 4)
                                       (make-token "4aaa" SPINE-DATA 4))
                                 4))
(define JOIN (make-record "*\t*v\t*v\t*"
                          TOKEN
                          (list (make-token "*" NULL-INTERPRETATION 3)
                                (make-token "*v" SPINE-JOIN 3)
                                (make-token "*v" SPINE-JOIN 3)
                                (make-token "*" NULL-INTERPRETATION 3))
                          3))
(define JOIN-LEFT (make-record "*v\t*v\t*\t*"
                               TOKEN
                               (list (make-token "*v" SPINE-JOIN 3)
                                     (make-token "*v" SPINE-JOIN 3)
                                     (make-token "*" NULL-INTERPRETATION 3)
                                     (make-token "*" NULL-INTERPRETATION 3))
                               3))
(define JOIN-RIGHT (make-record "*\t*\t*v\t*v"
                                TOKEN
                                (list (make-token "*" NULL-INTERPRETATION 3)
                                      (make-token "*" NULL-INTERPRETATION 3)
                                      (make-token "*v" SPINE-JOIN 3)
                                      (make-token "*v" SPINE-JOIN 3))
                                3))
(define AFTER-JOIN (make-record "4A\t4a\t4aaa"
                                TOKEN
                                (list (make-token "4A" SPINE-DATA 4)
                                      (make-token "4a" SPINE-DATA 4)
                                      (make-token "4aaa" SPINE-DATA 4))
                                4))
(define BERG (filter-type record-type TOKEN (hfile-records (los->hfile (read-file "data/berg01.pc")))))

; extract-spine-arity
(check-expect (extract-spine-arity BERG) (make-spine-arity 2 (list (list 1 1)
                                                                   (list 1 1)
                                                                   (list 1 1)
                                                                   (list 1 1)
                                                                   (list 1 1)
                                                                   (list 1 1)
                                                                   (list 1 1)
                                                                   (list 1 1)
                                                                   (list 1 1)
                                                                   (list 1 1)
                                                                   (list 1 1)
                                                                   (list 1 1)
                                                                   (list 1 1)
                                                                   (list 1 1)
                                                                   (list 1 1))))
; lolon
(check-expect (lolon (list TEST-RECORD-1)) (list (list 1)))
(check-expect (lolon BERG) (list (list 1 1)
                                 (list 1 1)
                                 (list 1 1)
                                 (list 1 1)
                                 (list 1 1)
                                 (list 1 1)
                                 (list 1 1)
                                 (list 1 1)
                                 (list 1 1)
                                 (list 1 1)
                                 (list 1 1)
                                 (list 1 1)
                                 (list 1 1)
                                 (list 1 1)
                                 (list 1 1)))

; lon-caller
(check-expect (lon-caller SPLIT (list 1 1 1)) (list 1 2 1)) ; next record is AFTER-SPLIT
(check-expect (lon-caller JOIN (list 1 2 1)) (list 1 1 1)) ; next record is AFTER-JOIN
(check-expect (lon-caller (make-record "4a" TOKEN (list (make-token "4a" SPINE-DATA 9)) 9)
                          (list 1))
              (list 1))

; previous-spine-struct?
(check-expect (previous-spine-struct? TEST-RECORD-1) #f)
(check-expect (previous-spine-struct? TEST-RECORD-2) #t)
(check-expect (previous-spine-struct? TEST-RECORD-3) #t)
(check-expect (previous-spine-struct? TEST-RECORD-4) #f)
(check-expect (previous-spine-struct? (make-record "*\t*^\t*\t*"
                                                   TOKEN
                                                   (list (make-token "*" NULL-INTERPRETATION 20)
                                                         (make-token "*^" SPINE-SPLIT 20)
                                                         (make-token "*" NULL-INTERPRETATION 20)
                                                         (make-token "*" NULL-INTERPRETATION 20))
                                                   20))
              #t)

; split-or-join-token?
(check-expect (split-or-join-token? TEST-TOKEN-1) #f)
(check-expect (split-or-join-token? TEST-TOKEN-2) #t)
(check-expect (split-or-join-token? TEST-TOKEN-3) #t)
(check-expect (split-or-join-token? TEST-TOKEN-4) #f)

; split-or-join-record
(check-expect (split-or-join-record TEST-RECORD-1) #f)
(check-expect (split-or-join-record TEST-RECORD-2) SPINE-SPLIT)
(check-expect (split-or-join-record TEST-RECORD-3) SPINE-JOIN)
(check-expect (split-or-join-record TEST-RECORD-4) #f)
(check-expect (split-or-join-record (make-record "*\t*^\t*\t*"
                                                   TOKEN
                                                   (list (make-token "*" NULL-INTERPRETATION 20)
                                                         (make-token "*^" SPINE-SPLIT 20)
                                                         (make-token "*" NULL-INTERPRETATION 20)
                                                         (make-token "*" NULL-INTERPRETATION 20))
                                                   20))
              SPINE-SPLIT)

; struct-lon
(check-expect (struct-lon SPLIT (list 1 1 1)) (list 1 2 1)) ; next record is AFTER-SPLIT
(check-expect (struct-lon SPLIT-LEFT (list 1 1 1)) (list 2 1 1))
(check-expect (struct-lon SPLIT-RIGHT (list 1 1 1)) (list 1 1 2))
(check-expect (struct-lon JOIN (list 1 2 1)) (list 1 1 1)) ; next record is AFTER-JOIN
(check-expect (struct-lon JOIN-LEFT (list 2 1 1)) (list 1 1 1))
(check-expect (struct-lon JOIN-RIGHT (list 1 1 2)) (list 1 1 1))

; one-per-spine
(check-expect (one-per-spine 5) (list 1 1 1 1 1))

(test)
