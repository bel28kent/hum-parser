#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  hum-parser: tests for type functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require "../../parser/data-definitions/data-definitions.rkt"
         "../../parser/functions/type.rkt"
         test-engine/racket-tests
         (only-in rackunit
                  check-exn))

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
(check-expect (type-token "*MM60")           METRONOME-MARKING)
(check-expect (type-token "=4||")            MEASURE)
(check-expect (type-token "=75:|!|:")        MEASURE)
(check-expect (type-token "16.aaLL]")        SPINE-DATA)
(check-expect (type-token "4a 4aaa")         SPINE-DATA)
(check-expect (type-token ".")               NULL-SPINE-DATA)
(check-expect (type-token "!")               LOCAL-COMMENT)
(check-expect (type-token "! Local comment") LOCAL-COMMENT)
(check-expect (type-token "*cue")            #f)
(check-exn    #rx"str with no tabs and 0 or 1 bang"
              (λ ()
                 (type-token "4aa\t4aaa")))
(check-exn    #rx"str with no tabs and 0 or 1 bang"
              (λ ()
                 (type-token "!!!COM: Bach, Johann Sebastian")))

; type-token-as-str
(check-expect (type-token-as-str "**kern")          EXCLUSIVE-INTERPRETATION)
(check-expect (type-token-as-str "*^")              SPINE-SPLIT)
(check-expect (type-token-as-str "*v")              SPINE-JOIN)
(check-expect (type-token-as-str "*-")              SPINE-TERMINATOR)
(check-expect (type-token-as-str "*")               NULL-INTERPRETATION)
(check-expect (type-token-as-str "*clefG2")         CLEF)
(check-expect (type-token-as-str "*M3/4")           TIME-SIG)
(check-expect (type-token-as-str "*met(c)")         TIME-SIG)
(check-expect (type-token-as-str "*k[]")            KEY-SIG)
(check-expect (type-token-as-str "*k[f#]")          KEY-SIG)
(check-expect (type-token-as-str "*k[b-]")          KEY-SIG)
(check-expect (type-token-as-str "*C:")             KEY-LABEL)
(check-expect (type-token-as-str "*X:")             KEY-LABEL)
(check-expect (type-token-as-str "*f#:")            KEY-LABEL)
(check-expect (type-token-as-str "*d:")             KEY-LABEL)
(check-expect (type-token-as-str "*B-:")            KEY-LABEL)
(check-expect (type-token-as-str "*staff1")         STAFF-NUMBER)
(check-expect (type-token-as-str "*staff1/2")       STAFF-NUMBER)
(check-expect (type-token-as-str "*Ipiano")         INSTRUMENT-CLASS)
(check-expect (type-token-as-str "*I\"Piano")       INSTRUMENT-CLASS)
(check-expect (type-token-as-str "*I'pf")           INSTRUMENT-CLASS)
(check-expect (type-token-as-str "*8va")            OTTAVA)
(check-expect (type-token-as-str "*X8va")           OTTAVA)
(check-expect (type-token-as-str "*grp:A")          GROUP-ATTRIBUTION)
(check-expect (type-token-as-str "*grp:B")          GROUP-ATTRIBUTION)
(check-expect (type-token-as-str "*part1")          PART-NUMBER)
(check-expect (type-token-as-str "*part20")         PART-NUMBER)
(check-expect (type-token-as-str "*MM60")           METRONOME-MARKING)
(check-expect (type-token-as-str "=4||")            MEASURE)
(check-expect (type-token-as-str "=75:|!|:")        MEASURE)
(check-expect (type-token-as-str "16.aaLL]")        SPINE-DATA)
(check-expect (type-token-as-str "4a 4aaa")         SPINE-DATA)
(check-expect (type-token-as-str ".")               NULL-SPINE-DATA)
(check-expect (type-token-as-str "!")               LOCAL-COMMENT)
(check-expect (type-token-as-str "! Local comment") LOCAL-COMMENT)
(check-expect (type-token-as-str "*cue")            "#false")
(check-exn    #rx"str with no tabs and 0 or 1 bang"
              (λ ()
                 (type-token-as-str "4aa\t4aaa")))
(check-exn    #rx"str with no tabs and 0 or 1 bang"
              (λ ()
                 (type-token-as-str "!!!COM: Bach, Johann Sebastian")))

(test)
