# Spines
## Definition
A spine is a single column of data in a Humdrum file. A spine does not include
reference records or global comments, but does include token records and local
comments. A spine comprises tokens, or strings of data. These tokens are
separated from each other by tabs, though a token can contain multiple data
that are singly spaced (e.g., the three notes of a triad). Spines are separated
from each other by tabs.

See the [typing doc](https://github.com/bel28kent/hum-parser/blob/main/docs/typing.md)
for spine types.

See the [parsers and converters doc](https://github.com/bel28kent/hum-parser/blob/main/docs/parsers-and-converters.md)
for commentary related to parsing and testing.

## Assumptions
The base case for a spine in `hum-parser` is a collection of two tokens: the
exclusive interpretation that declares a type of the spine, and the spine
terminator `*-`. The exclusive interpretation must be the first element of the
collection; the spine terminator must be the last element of the collection.

Beyond this base case, a spine is arbitrary: it can have any number of tokens. A
spine is also arbitrary in its dimensionality. A spine can be "split" into more
spines, or subspines, which can in turn be "joined" into less spines. Spines can
split and join an arbitrary number of times.

## Limitations on splits and joins
The following limitations on splits and joins are recognized in the [Humdrum
manual, Chapter 5](https://www.humdrum.org/guide/ch05/#spine-paths):

```
(1) when subspines within a single spine join, the "*v" tokens must be adjacent
(2) more than two subspines may be joined on a single record
(3) more than two spines or subspines may be split on a single record
(4) (sub)spines may be split and joined on the same record
```

The following possibilities granted by Humdrum are not currently supported by
`hum-parser`:

```
(1) adding a new spine after the initial exclusive interpretation record
(2) terminating a spine before other spines are terminated
(3) exchanging the position of spines
```

Lastly, the combination of `*^`  and `*v` with any other interpretations (apart
from the null interpretation) is not supported by `hum-parser` (cf. with
examples in Chapter 5).
