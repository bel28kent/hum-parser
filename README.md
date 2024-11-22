# hum-parser
## Racket expressions for parsing humdrum files

`hum-parser` is a repository of data definitions, data structures, and functions
for parsing [Humdrum](http://www.humdrum.org) files. `hum-parser` is written in
the [Racket](https://docs.racket-lang.org) language.

`hum-parser` is able to parse a Humdrum file into records and spines, allowing
the user to write these data into new files for use with other programs, or for
use directly (i.e. without writing) with other parts of the `hum-parser`.

The ultimate goal of `hum-parser` is to map spines on to
[graph](https://en.wikipedia.org/wiki/Graph_(abstract_data_type) data
structures. Such structures enable the user to write new functions that traverse
Humdrum data without having to worry about parsing records or spines.

`hum-parser` also provides command-line tools.

### Installing and Using Racket

Racket is a LISP-dialect. It is multi-paradigm, but `hum-parser` is chiefly
functional.
Read more on the language [here](https://en.wikipedia.org/wiki/Racket_(programming_language)).
Consult the documentation [here](https://docs.racket-lang.org).

To install Racket, follow the [Getting Started](https://docs.racket-lang.org/getting-started/index.html)
page of the documentation.

After installing Racket, it is recommended that the user add the path to the bin
directory to their shell's environment file (where `X\.XX` is the version number):

```sh
export PATH=/Applications/Racket\ vX\.XX/bin:$PATH
```

### Installing `hum-parser`
After installing Racket, the `hum-parser` repository should be cloned in the 
collects directory:

```sh
cd /Applications/Racket vX.XX/collects
git clone https://github.com/bel28kent/hum-parser
```

Racket automatically searches the `collects` directory when a module is imported.
This simplifies paths:

```racket
(require hum-parser)
```

If one clones `hum-parser` somewhere else, then the path to the parser will need
to be specified relative to the REPL or importing file:

```racket
(require "../PATH/hum-parser/main.rkt")

```

To install the binaries for the command-line tools:

```sh
cd /Applications/Racket vX.XX/collects/hum-parser
make all
```

### Note on limitations of `hum-parser`

### Future directions

hum-parser may eventually be translated into Racket's sister language Typed
Racket to allow for type-checking of user-defined types such as `HumdrumFile`
and `GlobalSpine`.
