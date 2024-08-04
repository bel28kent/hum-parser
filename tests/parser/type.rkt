#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  hum-parser: tests for type functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require "../../parser/data-definitions/data-definitions.rkt"
         "../../parser/functions/type.rkt"
         test-engine/racket-tests)

; type-metadata
(check-expect (type-metadata "!!!COM: Scriabin, Alexander")   REFERENCE-RECORD)
(check-expect (type-metadata "!! See pg. 5 of print edition") GLOBAL-COMMENT)
(check-expect (type-metadata "!\t! In some editions A#")      LOCAL-COMMENT)
(check-expect (type-metadata "4a\t4aa")                       #f)

; type-record
(check-expect (type-record "!!!COM: Scriabin, Alexander")   REFERENCE-RECORD)
(check-expect (type-record "!! See pg. 5 of print edition") GLOBAL-COMMENT)
(check-expect (type-record "!\t! In some editions A#")      LOCAL-COMMENT)
(check-expect (type-record "4a\t4aa\tf")                    TOKEN)

; type-token
(check-expect (type-token "**kern")          EXCLUSIVE-INTERPRETATION)
(check-expect (type-token "*^")              SPINE-SPLIT)
(check-expect (type-token "*v")              SPINE-JOIN)
(check-expect (type-token "*-")              SPINE-TERMINATOR)
(check-expect (type-token "*")               NULL-INTERPRETATION)
(check-expect (type-token "*clefG2")         CLEF)
(check-expect (type-token "*M3/4")           TIME-SIG)
(check-expect (type-token "*met(c)")         TIME-SIG)
(check-expect (type-token "*k[]")            KEY-SIG)
(check-expect (type-token "*k[f#]")          KEY-SIG)
(check-expect (type-token "*k[b-]")          KEY-SIG)
(check-expect (type-token "*C:")             KEY-LABEL)
(check-expect (type-token "*X:")             KEY-LABEL)
(check-expect (type-token "*f#:")            KEY-LABEL)
(check-expect (type-token "*d:")             KEY-LABEL)
(check-expect (type-token "*B-:")            KEY-LABEL)
(check-expect (type-token "*staff1")         STAFF-NUMBER)
(check-expect (type-token "*staff1/2")       STAFF-NUMBER)
(check-expect (type-token "*Ipiano")         INSTRUMENT-CLASS)
(check-expect (type-token "*I\"Piano")       INSTRUMENT-CLASS)
(check-expect (type-token "*I'pf")           INSTRUMENT-CLASS)
(check-expect (type-token "*8va")            OTTAVA)
(check-expect (type-token "*X8va")           OTTAVA)
(check-expect (type-token "*grp:A")          GROUP-ATTRIBUTION)
(check-expect (type-token "*grp:B")          GROUP-ATTRIBUTION)
(check-expect (type-token "*part1")          PART-NUMBER)
(check-expect (type-token "*part20")         PART-NUMBER)
(check-expect (type-token "=4||")            MEASURE)
(check-expect (type-token "16.aaLL]")        SPINE-DATA)
(check-expect (type-token "4a 4aaa")         SPINE-DATA)
(check-expect (type-token ".")               NULL-SPINE-DATA)
(check-expect (type-token "!")               LOCAL-COMMENT)
(check-expect (type-token "! Local comment") LOCAL-COMMENT)
(check-expect (type-token "*cue")            #f)
(check-error  (type-token "4aa\t4aaa"))
(check-error  (type-token "!!!COM: Bach, Johann Sebastian"))

(test)
