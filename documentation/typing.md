# Typing of records, spines, and tokens

## Records
All lines read from a file can be sorted into one of four categories:
```
	- ReferenceRecord
	- GlobalComment
	- LocalComment
	- Token
```
`ReferenceRecord`, `GlobalComment`, and `LocalComment` are each a `MetadataType`;
they contain information about the file or encoding. A Metadata record starts
with one of three tags, each defined as a sequence of bangs:
```racket
	(define REFERENCE-TAG "!!!")
	(define GLOBAL-TAG    "!!")
	(define LOCAL-TAG     "!")
```
Any line that does not start with one of these tags is typed as `Token`.

There are no constraints on the string argument to `type-metadata` and
`type-record`.

## Spines

## Tokens
The string argument to `type-token` must match the regular expression
`^!?[^!\t]+$`, otherwise an argument error is raised. One bang is allowed at the
beginning of the string for local comments, which will have one token for each
global spine. The presence of tabs indicates that the string has multiple fields,
and so must be a record. (The space is not included to allow for typing of stops,
which are interpreted as nested within a single token.) The caller will not
handle the argument error.