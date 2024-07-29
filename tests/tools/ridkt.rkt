#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hum-parser: tests for ridkt.rkt
;;    Only tests helper functions.
;;    Will fail as written because
;;    cmdline expects a filename.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require "../../parser/data-definitions/data-definitions.rkt"
         "../../tools/ridkt/ridkt.rkt"
         test-engine/racket-tests)

; TODO: local comments should still be split
(define GLOBAL       (record "!! Global Comment"
                             GLOBAL-COMMENT
                             (list "!! Global Comment")
                             0))
(define GLOBAL-EMPTY (record "!!" GLOBAL-COMMENT (list "!!") 0))
(define LOCAL        (record "!\t! Local Comment"
                             LOCAL-COMMENT
                             (list "!\t! Local Comment")
                             0))
(define LOCAL-EMPTY  (record "!\t!" LOCAL-COMMENT (list "!\t!") 0))
(define EXCLUSIVE    (record "**kern\t**kern"
                             TOKEN
                             (list (token "**kern" EXCLUSIVE-INTERPRETATION 2)
                                   (token "**kern" EXCLUSIVE-INTERPRETATION 2))
                             2))
(define DUP-EXCLUSIVE (record "*\t**kern"
                              TOKEN
                              (list (token "*" NULL-INTERPRETATION 5)
                                    (token "**kern" EXCLUSIVE-INTERPRETATION 5))
                              5))
(define TANDEM        (record "*clefG2\t*clefG2"
                              TOKEN
                              (list (token "*clefG2" CLEF 1)
                                    (token "*clefG2" CLEF 1))
                              1))
(define NULL-INTERP   (record "*\t*"
                              TOKEN
                              (list (token "*" NULL-INTERPRETATION 1)
                                    (token "*" NULL-INTERPRETATION 1))
                              1))
(define SPINE         (record "4a\t4a"
                              TOKEN
                              (list (token "4a" SPINE-DATA 1)
                                    (token "4a" SPINE-DATA 1))
                              1))
(define NULL-SPINE    (record ".\t."
                              TOKEN
                              (list (token "." NULL-SPINE-DATA 1)
                                    (token "." NULL-SPINE-DATA 1))
                              1))
; rid-global-comments
(check-expect (rid-global-comments (list GLOBAL)) empty)
(check-expect (rid-global-comments (list EXCLUSIVE)) (list EXCLUSIVE))
(check-expect (rid-global-comments (list GLOBAL EXCLUSIVE)) (list EXCLUSIVE))
(check-expect (rid-global-comments (list EXCLUSIVE GLOBAL)) (list EXCLUSIVE))

; rid-local-comments
(check-expect (rid-local-comments (list LOCAL)) empty)
(check-expect (rid-local-comments (list EXCLUSIVE)) (list EXCLUSIVE))
(check-expect (rid-local-comments (list LOCAL EXCLUSIVE)) (list EXCLUSIVE))
(check-expect (rid-local-comments (list EXCLUSIVE LOCAL)) (list EXCLUSIVE))

; rid-empty-global-comments
(check-expect (rid-empty-global-comments (list GLOBAL-EMPTY)) empty)
(check-expect (rid-empty-global-comments (list EXCLUSIVE)) (list EXCLUSIVE))
(check-expect (rid-empty-global-comments (list GLOBAL-EMPTY EXCLUSIVE))
              (list EXCLUSIVE))
(check-expect (rid-empty-global-comments (list EXCLUSIVE GLOBAL-EMPTY))
              (list EXCLUSIVE))

; rid-empty-local-comments
(check-expect (rid-empty-local-comments (list LOCAL-EMPTY)) empty)
(check-expect (rid-empty-local-comments (list EXCLUSIVE)) (list EXCLUSIVE))
(check-expect (rid-empty-local-comments (list LOCAL-EMPTY EXCLUSIVE))
              (list EXCLUSIVE))
(check-expect (rid-empty-local-comments (list EXCLUSIVE LOCAL-EMPTY))
              (list EXCLUSIVE))

; rid-interpretations
(check-expect (rid-interpretations (list EXCLUSIVE)) empty)
(check-expect (rid-interpretations (list TANDEM)) empty)
(check-expect (rid-interpretations (list NULL-INTERP)) empty)
(check-expect (rid-interpretations (list SPINE)) (list SPINE))
(check-expect (rid-interpretations (list GLOBAL EXCLUSIVE SPINE))
              (list GLOBAL SPINE))
(check-expect (rid-interpretations (list GLOBAL
                                         EXCLUSIVE
                                         TANDEM
                                         NULL-INTERP
                                         SPINE))
              (list GLOBAL SPINE))

; rid-tandem-interpretations
(check-expect (rid-tandem-interpretations (list EXCLUSIVE)) (list EXCLUSIVE))
(check-expect (rid-tandem-interpretations (list TANDEM)) empty)
(check-expect (rid-tandem-interpretations (list NULL-INTERP))
              (list NULL-INTERP))
(check-expect (rid-tandem-interpretations (list SPINE)) (list SPINE))
(check-expect (rid-tandem-interpretations (list GLOBAL EXCLUSIVE SPINE))
              (list GLOBAL EXCLUSIVE SPINE))
(check-expect (rid-tandem-interpretations (list GLOBAL
                                                EXCLUSIVE
                                                TANDEM
                                                NULL-INTERP
                                                SPINE))
              (list GLOBAL EXCLUSIVE NULL-INTERP SPINE))

; rid-empty-interpretations
(check-expect (rid-empty-interpretations (list EXCLUSIVE)) (list EXCLUSIVE))
(check-expect (rid-empty-interpretations (list TANDEM)) (list TANDEM))
(check-expect (rid-empty-interpretations (list NULL-INTERP)) empty)
(check-expect (rid-empty-interpretations (list SPINE)) (list SPINE))
(check-expect (rid-empty-interpretations (list GLOBAL EXCLUSIVE SPINE))
              (list GLOBAL EXCLUSIVE SPINE))
(check-expect (rid-empty-interpretations (list GLOBAL
                                               EXCLUSIVE
                                               TANDEM
                                               NULL-INTERP
                                               SPINE))
              (list GLOBAL EXCLUSIVE TANDEM SPINE))

; rid-data-records
(check-expect (rid-data-records (list EXCLUSIVE)) (list EXCLUSIVE))
(check-expect (rid-data-records (list TANDEM)) (list TANDEM))
(check-expect (rid-data-records (list NULL-INTERP)) (list NULL-INTERP))
(check-expect (rid-data-records (list SPINE)) empty)
(check-expect (rid-data-records (list GLOBAL EXCLUSIVE SPINE))
              (list GLOBAL EXCLUSIVE))
(check-expect (rid-data-records (list GLOBAL
                                      EXCLUSIVE
                                      TANDEM
                                      NULL-INTERP
                                      SPINE))
              (list GLOBAL EXCLUSIVE TANDEM NULL-INTERP))

; rid-null-data-records
(check-expect (rid-null-data-records (list EXCLUSIVE)) (list EXCLUSIVE))
(check-expect (rid-null-data-records (list TANDEM)) (list TANDEM))
(check-expect (rid-null-data-records (list NULL-INTERP)) (list NULL-INTERP))
(check-expect (rid-null-data-records (list SPINE)) (list SPINE))
(check-expect (rid-null-data-records (list NULL-SPINE)) empty)
(check-expect (rid-null-data-records (list GLOBAL EXCLUSIVE SPINE NULL-SPINE))
              (list GLOBAL EXCLUSIVE SPINE))
(check-expect (rid-null-data-records (list GLOBAL
                                           EXCLUSIVE
                                           TANDEM
                                           NULL-INTERP
                                           SPINE
                                           NULL-SPINE))
              (list GLOBAL EXCLUSIVE TANDEM NULL-INTERP SPINE))

; rid-duplicate-exclusive-interpretations
(check-expect (rid-duplicate-exclusive-interpretations (list GLOBAL
                                                             EXCLUSIVE
                                                             SPINE
                                                             NULL-SPINE
                                                             DUP-EXCLUSIVE))
              (list GLOBAL EXCLUSIVE SPINE NULL-SPINE))

(test)
