#lang racket/base

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  hum-parser: data definitions
;;
;;    NB: All example constants must end with -EX.
;;        All type constants are at the top of file.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide (all-defined-out))

(define SEPARATOR "\t")

(define REFERENCE-TAG "!!!")
(define GLOBAL-TAG    "!!")
(define LOCAL-TAG     "!")
(define EXCLUSIVE-TAG "**")
(define TANDEM-TAG    "*")
(define MEASURE-TAG   "=")

(define REFERENCE-RECORD         "ReferenceRecord")
(define GLOBAL-COMMENT           "GlobalComment")
(define LOCAL-COMMENT            "LocalComment")
(define TOKEN                    "Token")


(define EXCLUSIVE-INTERPRETATION "ExclusiveInterpretation")
(define MEASURE                  "Measure")
(define SPINE-DATA               "SpineData")
(define NULL-SPINE-DATA          "NullSpineData")


;;;;;;;;;;;;;;;;;;;;
;;  METADATA
;;    METADATA is anything that is not a Token in between
;;    the start and the termination of a spine and is not
;;    not a Token of the type specified by the spine's
;;    exclusive interpretation.

; Reference is String
; CONSTRAINT: Reference starts with REFERENCE-TAG
;  Represents a metadata tag containing information about
;    the humdrum file

(define REFERENCE-RECORD-EX "!!!COM: Bach, Johann Sebastian")

; GlobalComment is String
; CONSTRAINT: GlobalComment starts with GLOBAL-TAG
;  Represents a comment at global scope

(define GLOBAL-COMMENT-EX "!! This is a global comment")

; LocalComment is String
; CONSTRAINT: LocalComment starts with LOCAL-TAG
;  Represents a comment that is local to a spine

(define LOCAL-COMMENT-EX "!\t! This is a local comment\t!")

; MetadataType is one of:
;  - REFERENCE-RECORD
;  - GLOBAL-COMMENT
;  _ LOCAL-COMMENT
;  Represents the type of a metadatum

;;;;;;;;;;;;;;;;;;;;
;;  TOKEN
;;    TOKEN is a datum between a spine's exclusive
;;    interpretation and terminator, inclusive.
;;    TOKEN is part of one-and-only-one Record,
;;    and one-and-only-one GlobalSpine. TOKEN
;;    is separated from others by SEPARATOR.

(struct token (token type record-number field-index) #:transparent)
; Token is (token String TokenType Natural Natural))
;  Represents a single piece of data from a Spine.
;  CONSTRAINT: record-number >= 0

(define EXCLUSIVE-TOKEN-EX  (token "**kern"  EXCLUSIVE-INTERPRETATION 5 0))
(define TANDEM-TOKEN-EX     (token "*clefG2" CLEF                     6 0))
(define MUSIC-TOKEN-EX      (token "4a"      SPINE-DATA               7 0))

; TokenType is one of:
;  - ExclusiveInterpretation
;  - TandemInterpretation
;  - Measure
;  - SpineData
;  - NullSpineData
;  - LocalComment
;  - #f
;  Represents the type of a Token, or false if unknown

; ExclusiveInterpretation is "ExclusiveInterpretation"
;  Represents a token starting with EXCLUSIVE-TAG

; Measure is "Measure"
;  Represents a token starting with MEASURE-TAG

; SpineData is "SpineData"
;  Represents a token that is not one of above and not "."

; LocalComment (TokenType) is "LocalComment"
;  Represents a token that begins with "!"

;;;;;;;;;;;;;;;;;;;;
;;  RECORDS AND SPINES
;;    RECORD is a collection of METADATA or TOKEN
;;    from a single line in a Humdrum file.
;;    SPINE is a collection of TOKEN from a single
;;    column in a Humdrum file.

(struct record (record type split record-number) #:transparent)
; Record is one of:
;  - (record String REFERENCE-RECORD (listof Reference)     Natural)
;  - (record String GLOBAL-COMMENT   (listof GlobalComment) Natural)
;  - (record String LOCAL-COMMENT    (listof Token)         Natural)
;  - (record String TOKEN            (listof Token)         Natural)
;  Represents a single line of a Humdrum file.
;  CONSTRAINT: record-number >= 0

(define RECORD-REF-EX (record "!!!AGN: Etude" REFERENCE-RECORD (list "!!!AGN: Etude") 8))
(define RECORD-GC-EX (record "!! First ending" GLOBAL-COMMENT (list "!! First ending") 295))
(define RECORD-LC-EX (record "! Adagio\t!\t! Adagio\t!\t! Adagio\t!\t! Adagio\t!"
                             LOCAL-COMMENT
                             (list (token "! Adagio" LOCAL-COMMENT 21 0)
                                   (token "!" LOCAL-COMMENT 21 1)
                                   (token "! Adagio" LOCAL-COMMENT 21 2)
                                   (token "!" LOCAL-COMMENT 21 3)
                                   (token "! Adagio" LOCAL-COMMENT 21 4)
                                   (token "!" LOCAL-COMMENT 21 5)
                                   (token "! Adagio" LOCAL-COMMENT 21 6)
                                   (token "!" LOCAL-COMMENT 21 7))
                             21))

; SpineType is one of:
;  - Kern
;  - Dynam
;  - #f
;  Represents the representation scheme of the spine, or false if unknown

(struct global-spine (type tokens spine-number) #:transparent)
; GlobalSpine is (global-spine SpineType (listof (listof Token)) Natural)
;  Represents a singe global column of a Humdrum file.
;  CONSTRAINTS:  (1) spine-number >= 0
;                (2) length tokens >= 2
;                (3) tokens contains at least an exlusive interpretation at index 0 and
;                    a spine terminator at index length - 1.

(define GLOBAL-SPINE-EX
        (global-spine KERN
                      (list (list (token "**kern"  EXCLUSIVE-INTERPRETATION 0 0))
                            (list (token "*clefG2" CLEF                     1 0))
                            (list (token "4a"      SPINE-DATA               2 0)))
                      0))

;;;;;;;;;;;;;;;;;;;;
;;  FILE
;;    FILE is a collection of records.

(struct hfile (records) #:transparent)
;  HumdrumFile is (hfile (listof Records))
;    Represents a humdrum file.
(define GERSH-01-FILE-EX
        (hfile
          (list (record "!! George Gershwin: (I've Got) Beginner's Luck"
                        GLOBAL-COMMENT
                        (list "!! George Gershwin: (I've Got) Beginner's Luck")
                        0)
                (record "!! Bumper Book of George Gershwin"
                        GLOBAL-COMMENT
                        (list "!! Bumper Book of George Gershwin")
                        1)
                (record "!! London: Chappell Music Ltd., 1987; pp.30-33"
                        GLOBAL-COMMENT
                        (list "!! London: Chappell Music Ltd., 1987; pp.30-33")
                        2)
                (record "**kern"
                        TOKEN
                        (list (token "**kern" EXCLUSIVE-INTERPRETATION 3 0))
                        3)
                (record "*M4/4"
                        TOKEN
                        (list (token "*M4/4" TIME-SIG 4 0))
                        4)
                (record "*MM[Moderato]"
                        TOKEN
                        (list (token "*MM[Moderato]" #f 5 0))
                        5)
                (record "4f#"
                        TOKEN
                        (list (token "4f#" SPINE-DATA 6 0))
                        6)
                (record "=1"
                        TOKEN
                        (list (token "=1" MEASURE 7 0))
                        7)
                (record "4a"
                        TOKEN
                        (list (token "4a" SPINE-DATA 8 0))
                        8)
                (record "8a"
                        TOKEN
                        (list (token "8a" SPINE-DATA 9 0))
                        9)
                (record "[8a"
                        TOKEN
                        (list (token "[8a" SPINE-DATA 10 0))
                        10)
                (record "8a]"
                        TOKEN
                        (list (token "8a]" SPINE-DATA 11 0))
                        11)
                (record "8a"
                        TOKEN
                        (list (token "8a" SPINE-DATA 12 0))
                        12)
                (record "4a"
                        TOKEN
                        (list (token "4a" SPINE-DATA 13 0))
                        13)
                (record "===="
                        TOKEN
                        (list (token "====" MEASURE 14 0))
                        14)
                (record "*-"
                        TOKEN
                        (list (token "*-" SPINE-TERMINATOR 15 0))
                        15))))

(struct spine-arity (global lolon) #:transparent)
; SpineArity is (spine-arity Natural (listof (listof Natural)))
;  Represents the structure of a file's spines, with the number of
;    global spines and a list of number of subspines for each global
;    spine on each record.
;  CONSTRAINT: Each lon in lolon has length equal to global

; **kern
; *k[]
; 4a
; =1
; *^
; 4a	4aa
; 4b	4bb
; =2	=2
; 4cc	4ccc
; *v	*v
; 4a
; =
; *-

(define SPINE-ARITY-EX (spine-arity 1 (list (list 1)
                                            (list 1)
                                            (list 1)
                                            (list 1)
                                            (list 1)
                                            (list 2)
                                            (list 2)
                                            (list 2)
                                            (list 2)
                                            (list 2)
                                            (list 1)
                                            (list 1)
                                            (list 1))))
