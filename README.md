# hum-parser
## Racket expressions for parsing humdrum files

hum-parser is a repository of data definitions and functions
for parsing [humdrum](http://www.humdrum.org) files. Data
definitions and functions are written in the [Racket](https://docs.racket-lang.org)
language.

hum-parser is able to parse a humdrum file into records and spines,
allowing the user to write these data into new files for use with
other programs, or for use with other parts of the hum-parser.

The ultimate goal of hum-parser is to map spines on to tree structures. Such
structures would enable the user to write new functions that traverse humdrum
data without having to worry about parsing records or spines.

### Installing and Using Racket

Racket is a LISP-dialect. Read more on the language [here](https://en.wikipedia.org/wiki/Racket_(programming_language)).
Consult the documentation [here](https://docs.racket-lang.org).

To install Racket, follow the [Getting Started](https://docs.racket-lang.org/getting-started/index.html)
page of the documentation.

There are two primary ways of using Racket. One is through DrRacket, the language's
IDE. An executable for the IDE will be installed when following the Getting Started
page above. The second and preferred way for hum-parser is on the command-line
by running the `racket` command. It is recommended that the user add the path to
the bin directory after installing Racket to make it easier to run the command from anywhere.

### Using hum-parser in the REPL

### Future directions

hum-parser may eventually be translated into Racket's sister language Typed Racket
to allow for type-checking of user-defined types such as `HumdrumFile` and `GlobalSpine`.
