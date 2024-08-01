#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  hum-parser: tests for extract-spine-arity
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require "../../parser/data-definitions/data-definitions.rkt"
         "../../parser/functions/abstract.rkt"
         "../../parser/functions/extract-spine-arity.rkt"
         "../../parser/functions/file.rkt"
         test-engine/racket-tests)

(define TEST-TOKEN-1 (token "**kern" EXCLUSIVE-INTERPRETATION 3))
(define TEST-TOKEN-2 (token "*^"     SPINE-SPLIT 3))
(define TEST-TOKEN-3 (token "*v"     SPINE-JOIN 3))
(define TEST-TOKEN-4 (token "4a"     SPINE-DATA 3))

(define TEST-RECORD-1 (record "**kern" TOKEN (list TEST-TOKEN-1) 3))
(define TEST-RECORD-2 (record "*^"     TOKEN (list TEST-TOKEN-2) 3))
(define TEST-RECORD-3 (record "*v"     TOKEN (list TEST-TOKEN-3) 3))
(define TEST-RECORD-4 (record "4a"     TOKEN (list TEST-TOKEN-4) 3))

(define SPLIT (record "*\t*^\t*"
                      TOKEN
                      (list (token "*" NULL-INTERPRETATION 3)
                            (token "*^" SPINE-SPLIT 3)
                            (token "*" NULL-INTERPRETATION 3))
                      3))
(define SECOND-SPLIT (record "*\t*^\t*\t*"
                             TOKEN
                             (list (token "*" NULL-INTERPRETATION 4)
                                   (token "*^" SPINE-SPLIT 4)
                                   (token "*" NULL-INTERPRETATION 4)
                                   (token "*" NULL-INTERPRETATION 4))
                             4))
(define THIRD-SPLIT (record "*\t*\t*^\t*\t*"
                            TOKEN
                            (list (token "*" NULL-INTERPRETATION 5)
                                  (token "*" NULL-INTERPRETATION 5)
                                  (token "*^" SPINE-SPLIT 5)
                                  (token "*" NULL-INTERPRETATION 5)
                                  (token "*" NULL-INTERPRETATION 5))
                            5))
(define SPLIT-LEFT (record "*^\t*\t*"
                           TOKEN
                           (list (token "*^" SPINE-SPLIT 3)
                                 (token "*" NULL-INTERPRETATION 3)
                                 (token "*" NULL-INTERPRETATION 3))
                           3))
(define SPLIT-RIGHT (record "*\t*\t*^"
                            TOKEN
                            (list (token "*" NULL-INTERPRETATION 3)
                                  (token "*" NULL-INTERPRETATION 3)
                                  (token "*^" SPINE-SPLIT 3))
                            3))
(define AFTER-SPLIT (record "4A\t4a\t4aa\t4aaa"
                            TOKEN
                            (list (token "4A" SPINE-DATA 4)
                                  (token "4a" SPINE-DATA 4)
                                  (token "4aa" SPINE-DATA 4)
                                  (token "4aaa" SPINE-DATA 4))
                            4))
(define THIRD-JOIN-A (record "*\t*v\t*v\t*\t*\t*"
                           TOKEN
                           (list (token "*" NULL-INTERPRETATION 1)
                                 (token "*v" SPINE-JOIN 1)
                                 (token "*v" SPINE-JOIN 1)
                                 (token "*" NULL-INTERPRETATION 1)
                                 (token "*" NULL-INTERPRETATION 1)
                                 (token "*" NULL-INTERPRETATION 1))
                           1))
(define THIRD-JOIN-B (record "*\t*\t*v\t*v\t*\t*"
                           TOKEN
                           (list (token "*" NULL-INTERPRETATION 1)
                                 (token "*" NULL-INTERPRETATION 1)
                                 (token "*v" SPINE-JOIN 1)
                                 (token "*v" SPINE-JOIN 1)
                                 (token "*" NULL-INTERPRETATION 1)
                                 (token "*" NULL-INTERPRETATION 1))
                           1))
(define THIRD-JOIN-C (record "*\t*\t*\t*v\t*v\t*"
                           TOKEN
                           (list (token "*" NULL-INTERPRETATION 1)
                                 (token "*" NULL-INTERPRETATION 1)
                                 (token "*" NULL-INTERPRETATION 1)
                                 (token "*v" SPINE-JOIN 1)
                                 (token "*v" SPINE-JOIN 1)
                                 (token "*" NULL-INTERPRETATION 1))
                           1))
(define SECOND-JOIN (record "*\t*\t*v\t*v\t*"
                            TOKEN
                            (list (token "*" NULL-INTERPRETATION 2)
                                  (token "*" NULL-INTERPRETATION 2)
                                  (token "*v" SPINE-JOIN 2)
                                  (token "*v" SPINE-JOIN 2)
                                  (token "*" NULL-INTERPRETATION 2))
                            2))
(define JOIN (record "*\t*v\t*v\t*"
                     TOKEN
                     (list (token "*" NULL-INTERPRETATION 3)
                           (token "*v" SPINE-JOIN 3)
                           (token "*v" SPINE-JOIN 3)
                           (token "*" NULL-INTERPRETATION 3))
                     3))
(define JOIN-LEFT (record "*v\t*v\t*\t*"
                          TOKEN
                          (list (token "*v" SPINE-JOIN 3)
                                (token "*v" SPINE-JOIN 3)
                                (token "*" NULL-INTERPRETATION 3)
                                (token "*" NULL-INTERPRETATION 3))
                          3))
(define JOIN-RIGHT (record "*\t*\t*v\t*v"
                           TOKEN
                           (list (token "*" NULL-INTERPRETATION 3)
                                 (token "*" NULL-INTERPRETATION 3)
                                 (token "*v" SPINE-JOIN 3)
                                 (token "*v" SPINE-JOIN 3))
                           3))
(define AFTER-JOIN (record "4A\t4a\t4aaa"
                           TOKEN
                           (list (token "4A" SPINE-DATA 4)
                                 (token "4a" SPINE-DATA 4)
                                 (token "4aaa" SPINE-DATA 4))
                           4))
(define BERG (path->hfile "data/berg01.pc"))

; extract-spine-arity
(check-expect (extract-spine-arity BERG) (spine-arity 2 (list (list 1 1)
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
(check-expect (lolon (filter-type record-type
                                  TOKEN
                                  (hfile-records BERG)))
              (list (list 1 1)
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
(check-expect (lon-caller SPLIT (list 1 1 1)) (list 1 2 1))
(check-expect (lon-caller JOIN (list 1 2 1)) (list 1 1 1))
(check-expect (lon-caller (record "4a" TOKEN (list (token "4a" SPINE-DATA 9)) 9)
                          (list 1))
              (list 1))

; previous-spine-struct?
(check-expect (previous-spine-struct? TEST-RECORD-1) #f)
(check-expect (previous-spine-struct? TEST-RECORD-2) #t)
(check-expect (previous-spine-struct? TEST-RECORD-3) #t)
(check-expect (previous-spine-struct? TEST-RECORD-4) #f)
(check-expect (previous-spine-struct?
                (record "*\t*^\t*\t*"
                        TOKEN
                        (list (token "*" NULL-INTERPRETATION 20)
                              (token "*^" SPINE-SPLIT 20)
                              (token "*" NULL-INTERPRETATION 20)
                              (token "*" NULL-INTERPRETATION 20))
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
(check-expect (split-or-join-record (record
                                      "*\t*^\t*\t*"
                                      TOKEN
                                      (list (token "*" NULL-INTERPRETATION 20)
                                            (token "*^" SPINE-SPLIT 20)
                                            (token "*" NULL-INTERPRETATION 20)
                                            (token "*" NULL-INTERPRETATION 20))
                                      20))
              SPINE-SPLIT)
(check-expect (split-or-join-record (record
                                      "*\t*v\t*v\t*"
                                      TOKEN
                                      (list (token "*"  NULL-INTERPRETATION 20)
                                            (token "*v" SPINE-JOIN 20)
                                            (token "*v" SPINE-JOIN 20)
                                            (token "*"  NULL-INTERPRETATION 20))
                                      20))
              SPINE-JOIN)

; struct-lon
(check-expect (struct-lon SPLIT (list 1 1 1)) (list 1 2 1))
(check-expect (struct-lon SPLIT-LEFT (list 1 1 1)) (list 2 1 1))
(check-expect (struct-lon SPLIT-RIGHT (list 1 1 1)) (list 1 1 2))
(check-expect (struct-lon SECOND-SPLIT (list 1 2 1)) (list 1 3 1))
(check-expect (struct-lon THIRD-SPLIT (list 1 3 1)) (list 1 4 1))
(check-expect (struct-lon THIRD-JOIN-A (list 1 4 1)) (list 1 3 1))
(check-expect (struct-lon THIRD-JOIN-B (list 1 4 1)) (list 1 3 1))
(check-expect (struct-lon THIRD-JOIN-C (list 1 4 1)) (list 1 3 1))
(check-expect (struct-lon SECOND-JOIN (list 1 3 1)) (list 1 2 1))
(check-expect (struct-lon JOIN (list 1 2 1)) (list 1 1 1))
(check-expect (struct-lon JOIN-LEFT (list 2 1 1)) (list 1 1 1))
(check-expect (struct-lon JOIN-RIGHT (list 1 1 2)) (list 1 1 1))

; one-per-spine
(check-expect (one-per-spine 5) (list 1 1 1 1 1))

(test)
