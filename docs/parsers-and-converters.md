# Parsers and Converters
The primary contribution of `hum-parser` is to offer built-in resources for
parsing Humdrum files into data structures for which new programs can be
written as expressively and efficiently as possible. These data structures,
namely graphs, accommodate the arbitrary size of Humdrum files (especially
spines) in a recursive manner. This in turn allows for function
templates to be derived which largely automate traversal of the structures.
The programmer can then focus on the purpose of the function at each point
in the structure, without having to code additional logic for traversal.
Because graphs handle arbitrary data by design, these structures
work for all Humdrum files, from the most simple to the most complex.

## Parsers
Parsing resources are contained in the `parser` subdirectory. The following
files comprise functions related to parsing:
```
	- file.rkt
	- spine-parser.rkt
```
These functions are parsers:
```
	- path->hfile  (String -> HumdrumFile)
	- spine-parser (HumdrumFile -> (listof GlobalSpine))
```
Parsers provide basic facilities for getting Humdrum data into `hum-parser`.

`path->hfile` will wrap each line of a Humdrum file in a Record type and produce
the list of Records.

`spine-parser` separates spines in a HumdrumFile and returns them as a list.
Note that a GlobalSpine only contains data from Records typed as TOKEN or
LOCAL-COMMENT, so a GlobalSpine will be smaller than a HumdrumFile if the latter
contains references or global comments.

## Converters
Converters serve two purposes: (1) to map parsed Humdrum data onto a graph and
(2) to allow for the unwrapping and re-wrapping of data in different types
when necessary.

These files comprise converters (all in the `parser` directory):
```
	- data-structures/humdrum-graph/functions/hgraph-to-hfile.rkt
	- data-structures/humdrum-graph/functions/hfile-to-hgraph.rkt
        - data-structures/linked-spine/functions/gspines-to-linked-spines.rkt
	- functions/file.rkt
	- functions/spine-parser.rkt
```
These functions are converters:
```
	- hgraph->hfile (HumdrumGraph -> HumdrumFile)
	- lolot->lor    ((listof (listof Token)) -> (listof Record))
	- hgraph->lolot (HumdrumGraph -> (listof (listof Token)))
	- hfile->hgraph (HumdrumFile -> HumdrumGraph)
        - gspines->linked-spines ((listof GlobalSpine) -> (listof LinkedSpine))
	- branch->lot   ((listof Node) -> (listof Token))
```

## Testing
Tests for parsers and converters must cover enough cases to ensure that any
syntactically valid Humdrum data can be parsed correctly. Spines are the main
challenge, as they create the arbitrary size of Humdrum data.

All parsers and converters must pass two types of tests: count tests and order
tests. Count tests ensure that the parser or converter works regardless of the
number of spines and regardless of the number of spine splits and joins. Order
tests ensure that the parser or converter works regardless of the order of spine
splits or spine joins.

Count tests should cover all cases from empty to 3 spines. For each spine, count
tests should further cover all cases from no spine splits to 3 spine splits in
all spines.

Order tests should cover all cases of spine splits and spine joins. These
include:
```
	- spine splits immediately following exclusive interpretation
	- spine joins immediately before "*-"
	- spine splits successively
	- spine joins successively
	- spine splits are separated
	- spine joins are separated
	- spine splits are unordered and can be simultaneous, i.e. the following
          are all valid. The spine splits to and joins to the right case is
          identical to the spine joins successively case, so the same file is
          used for both tests.
		*^
		*	*^

		AND

		*^
		*^	*
		
		AND
		
		*^
		*^	*^
		
		AND
		
		**kern	**kern
		*^	*^
	- spine joins are unordered
		*	*v	*v
		*v	*v

		AND

		*v	*v	*
		*v	*v
	- more than two spine joins
		*v	*v	*v
	- spine splits and joins
		*^	*v	*v
		*v	*v	*^

		**kern	**kern
		*^	*^
		*	*^	*	*
		*v	*v	*v	*	*^

		**kern	**kern
		*^	*^
		*	*	*^	*
		*^	*	*v	*v	*v
```
