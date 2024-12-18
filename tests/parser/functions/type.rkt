#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  hum-parser: tests for type functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require "../../../parser/data-definitions/data-definitions.rkt"
         "../../../parser/functions/type.rkt"
         test-engine/racket-tests
         (only-in rackunit check-exn))

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

; type-spine
(check-expect (type-spine (list (list (token "**kern" EXCLUSIVE-INTERPRETATION 0 0))
                                (list (token "4a" SPINE-DATA 1 0))
                                (list (token "==" MEASURE 2 0))
                                (list (token "*-" SPINE-TERMINATOR 3 0))))
              KERN)
(check-expect (type-spine (list (list (token "**dynam" EXCLUSIVE-INTERPRETATION 0 0))
                                (list (token "f" SPINE-DATA 1 0))
                                (list (token "==" MEASURE 2 0))
                                (list (token "*-" SPINE-TERMINATOR 3 0))))
              DYNAM)
(check-expect (type-spine (list (list (token "**test" EXCLUSIVE-INTERPRETATION 0 0))
                                (list (token "test" SPINE-DATA 1 0))
                                (list (token "==" MEASURE 2 0))
                                (list (token "*-" SPINE-TERMINATOR 3 0))))
              #f)
(check-exn #rx"only 1 exclusive interpretation"
           (λ ()
              (type-spine (list (list (token "**kern" EXCLUSIVE-INTERPRETATION 0 0)
                                      (token "*" NULL-INTERPRETATION 0 1))))))
(check-exn #rx"first token must start with \\*\\*"
           (λ ()
              (type-spine (list (list (token "*" NULL-INTERPRETATION 0 0))))))

; type-token
(check-expect (type-token "**kern")          EXCLUSIVE-INTERPRETATION)
(check-expect (type-token "*^")              SPINE-SPLIT)
(check-expect (type-token "*v")              SPINE-JOIN)
(check-expect (type-token "*-")              SPINE-TERMINATOR)
(check-expect (type-token "*")               NULL-INTERPRETATION)
(check-expect (type-token "*clefG2")         CLEF)
(check-expect (type-token "*mclefG2")        CLEF)
(check-expect (type-token "*M3/4")           TIME-SIG)
(check-expect (type-token "*met(c)")         TIME-SIG)
(check-expect (type-token "*mmet(c)")        TIME-SIG)
(check-expect (type-token "*k[]")            KEY-SIG)
(check-expect (type-token "*k[f#]")          KEY-SIG)
(check-expect (type-token "*k[b-]")          KEY-SIG)
(check-expect (type-token "*C:")             KEY-LABEL)
(check-expect (type-token "*X:")             KEY-LABEL)
(check-expect (type-token "*f#:")            KEY-LABEL)
(check-expect (type-token "*d:")             KEY-LABEL)
(check-expect (type-token "*B-:")            KEY-LABEL)
(check-expect (type-token "*kcancel")        KEY-CANCEL)
(check-expect (type-token "*staff1")         STAFF-NUMBER)
(check-expect (type-token "*staff1/2")       STAFF-NUMBER)
(check-expect (type-token "*I")              INSTRUMENT-CLASS)
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
(check-expect (type-token "*MM66.4")         METRONOME-MARKING)
(check-expect (type-token "*cue")            CUE-SIZED-NOTES)
(check-expect (type-token "*Xcue")           CUE-SIZED-NOTES)
(check-expect (type-token "*tuplet")         TUPLET)
(check-expect (type-token "*Xtuplet")        TUPLET)
(check-expect (type-token "*tremolo")        TREMOLO)
(check-expect (type-token "*Xtremolo")       TREMOLO)
(check-expect (type-token "*ped")            PEDAL-MARKING)
(check-expect (type-token "*Xped")           PEDAL-MARKING)
(check-expect (type-token "*ped*")           PEDAL-MARKING)
(check-expect (type-token "*>")              FORM-MARKER)
(check-expect (type-token "*>1A")            FORM-MARKER)
(check-expect (type-token "*>A1")            FORM-MARKER)
(check-expect (type-token "*>[A,A,B]")       FORM-MARKER)
(check-expect (type-token "*>norep[A,A2,B]") FORM-MARKER)
(check-expect (type-token "*brackettup")     BRACKET-TUPLET)
(check-expect (type-token "*Xbrackettup")    BRACKET-TUPLET)
(check-expect (type-token "*flip")           FLIP-SUBSPINES)
(check-expect (type-token "*Xflip")          FLIP-SUBSPINES)
(check-expect (type-token "*above")          ABOVE-STAFF)
(check-expect (type-token "*below")          BELOW-STAFF)
(check-expect (type-token "*below:2")        BELOW-STAFF)
(check-expect (type-token "*center")         CENTER-STAFF)
(check-expect (type-token "*centered")       CENTER-STAFF)
(check-expect (type-token "*lig")            LIGATURE-BRACKET)
(check-expect (type-token "*rscale:1")       RHYTHMIC-SCALING-FACTOR)
(check-expect (type-token "*rscale:1/2")     RHYTHMIC-SCALING-FACTOR)
(check-expect (type-token "*rscale:2")       RHYTHMIC-SCALING-FACTOR)
(check-expect (type-token "*solo")           TASTO-SOLO)
(check-expect (type-token "*accomp")         END-TASTO-SOLO)
(check-expect (type-token "=4||")            MEASURE)
(check-expect (type-token "=75:|!|:")        MEASURE)
(check-expect (type-token "16.aaLL]")        SPINE-DATA)
(check-expect (type-token "4a 4aaa")         SPINE-DATA)
(check-expect (type-token ".")               NULL-SPINE-DATA)
(check-expect (type-token "!")               LOCAL-COMMENT)
(check-expect (type-token "! Local comment") LOCAL-COMMENT)
(check-exn    #rx"str with no tabs and optional bang to start"
              (λ ()
                 (type-token "4aa\t4aaa")))
(check-exn    #rx"str with no tabs and optional bang to start"
              (λ ()
                 (type-token "!!!COM: Bach, Johann Sebastian")))

; type-token-as-str
(check-expect (type-token-as-str "**kern")          EXCLUSIVE-INTERPRETATION)
(check-expect (type-token-as-str "*^")              SPINE-SPLIT)
(check-expect (type-token-as-str "*v")              SPINE-JOIN)
(check-expect (type-token-as-str "*-")              SPINE-TERMINATOR)
(check-expect (type-token-as-str "*")               NULL-INTERPRETATION)
(check-expect (type-token-as-str "*clefG2")         CLEF)
(check-expect (type-token-as-str "*mclefG2")        CLEF)
(check-expect (type-token-as-str "*M3/4")           TIME-SIG)
(check-expect (type-token-as-str "*met(c)")         TIME-SIG)
(check-expect (type-token-as-str "*mmet(c)")        TIME-SIG)
(check-expect (type-token-as-str "*k[]")            KEY-SIG)
(check-expect (type-token-as-str "*k[f#]")          KEY-SIG)
(check-expect (type-token-as-str "*k[b-]")          KEY-SIG)
(check-expect (type-token-as-str "*C:")             KEY-LABEL)
(check-expect (type-token-as-str "*X:")             KEY-LABEL)
(check-expect (type-token-as-str "*f#:")            KEY-LABEL)
(check-expect (type-token-as-str "*d:")             KEY-LABEL)
(check-expect (type-token-as-str "*B-:")            KEY-LABEL)
(check-expect (type-token-as-str "*kcancel")        KEY-CANCEL)
(check-expect (type-token-as-str "*staff1")         STAFF-NUMBER)
(check-expect (type-token-as-str "*staff1/2")       STAFF-NUMBER)
(check-expect (type-token-as-str "*I")              INSTRUMENT-CLASS)
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
(check-expect (type-token-as-str "*MM66.4")         METRONOME-MARKING)
(check-expect (type-token-as-str "*cue")            CUE-SIZED-NOTES)
(check-expect (type-token-as-str "*Xcue")           CUE-SIZED-NOTES)
(check-expect (type-token-as-str "*tuplet")         TUPLET)
(check-expect (type-token-as-str "*Xtuplet")        TUPLET)
(check-expect (type-token-as-str "*tremolo")        TREMOLO)
(check-expect (type-token-as-str "*Xtremolo")       TREMOLO)
(check-expect (type-token-as-str "*ped")            PEDAL-MARKING)
(check-expect (type-token-as-str "*Xped")           PEDAL-MARKING)
(check-expect (type-token-as-str "*ped*")           PEDAL-MARKING)
(check-expect (type-token-as-str "*>")              FORM-MARKER)
(check-expect (type-token-as-str "*>1A")            FORM-MARKER)
(check-expect (type-token-as-str "*>A1")            FORM-MARKER)
(check-expect (type-token-as-str "*>[A,A,B]")       FORM-MARKER)
(check-expect (type-token-as-str "*>norep[A,A2,B]") FORM-MARKER)
(check-expect (type-token-as-str "*brackettup")     BRACKET-TUPLET)
(check-expect (type-token-as-str "*Xbrackettup")    BRACKET-TUPLET)
(check-expect (type-token-as-str "*flip")           FLIP-SUBSPINES)
(check-expect (type-token-as-str "*Xflip")          FLIP-SUBSPINES)
(check-expect (type-token-as-str "*above")          ABOVE-STAFF)
(check-expect (type-token-as-str "*below")          BELOW-STAFF)
(check-expect (type-token-as-str "*below:2")        BELOW-STAFF)
(check-expect (type-token-as-str "*center")         CENTER-STAFF)
(check-expect (type-token-as-str "*centered")       CENTER-STAFF)
(check-expect (type-token-as-str "*lig")            LIGATURE-BRACKET)
(check-expect (type-token-as-str "*rscale:1")       RHYTHMIC-SCALING-FACTOR)
(check-expect (type-token-as-str "*rscale:1/2")     RHYTHMIC-SCALING-FACTOR)
(check-expect (type-token-as-str "*rscale:2")       RHYTHMIC-SCALING-FACTOR)
(check-expect (type-token-as-str "*solo")           TASTO-SOLO)
(check-expect (type-token-as-str "*accomp")         END-TASTO-SOLO)
(check-expect (type-token-as-str "=4||")            MEASURE)
(check-expect (type-token-as-str "=75:|!|:")        MEASURE)
(check-expect (type-token-as-str "16.aaLL]")        SPINE-DATA)
(check-expect (type-token-as-str "4a 4aaa")         SPINE-DATA)
(check-expect (type-token-as-str ".")               NULL-SPINE-DATA)
(check-expect (type-token-as-str "!")               LOCAL-COMMENT)
(check-expect (type-token-as-str "! Local comment") LOCAL-COMMENT)
(check-exn    #rx"str with no tabs and optional bang to start"
              (λ ()
                 (type-token-as-str "4aa\t4aaa")))
(check-exn    #rx"str with no tabs and optional bang to start"
              (λ ()
                 (type-token-as-str "!!!COM: Bach, Johann Sebastian")))

(test)
