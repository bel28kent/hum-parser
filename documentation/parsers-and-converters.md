# Parsers and Converters
The primary contribution of `hum-parser` is to offer built-in resources for
parsing Humdrum files into data structures for which new programs can be
written as expressively and efficiently as possible. These data structures,
namely trees and graphs, accommodate the arbitrary size of Humdrum files
(especially spines) in a recursive manner. This in turn allows for function
templates to be derived which largely automate traversal of the structures.
The programmer can then focus on the purpose of the function at each point
in the structure, without having to code additional logic for traversal.
Because trees and graphs handle arbitrary data by design, these structures
work for all Humdrum files, from the most simple to the most complex; the
programmer does not need to create new data types for each Humdrum file.
While trees and graphs are quite abstract, their 2D nature bypasses the
struggles of cramming Humdrum data into 1D lists and hashes.

## Parsers
Parsing resources are contained in the `parser` subdirectory. The following
files comprise functions related to parsing:
```
	- file.rkt
	- spine-parser.rkt
```
These functions are parsers:
```
	- path->hfile (String -> HumdrumFile)
	- spine-parser (HumdrumFile -> (listof GlobalSpine))
```
Parsers provide basic facilities for getting Humdrum data into `hum-parser`.

`path->hfile` will wrap each line of a Humdrum file in a Record type and produce
the list of Records.

`spine-parser` separates spines in a HumdrumFile and returns them as a list.
Note that a GlobalSpine only contains data from Records typed as TOKEN, so a
GlobalSpine will be smaller than a HumdrumFile if the latter contains references
or comments.

## Converters
Converters serve two purposes: (1) to map parsed Humdrum data onto a tree or
graph and (2) to allow for unwrapping and re-wrapping data in different types
when necessary.

## Testing
