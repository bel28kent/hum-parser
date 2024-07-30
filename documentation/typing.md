# Typing of records, spines, and tokens

## Records
All lines read from a file can be sorted into one of four categories:
```
	- `ReferenceRecord`
	- `GlobalComment`
	- `LocalComment`
	- `Token`
```
`ReferenceRecord`, `GlobalComment`, and `LocalComment` are Metadata; they contain
information about the file or encoding. A Metadata record starts with one of
three tags, each defined as a sequence of bangs:
```racket
	(define REFERENCE-TAG "!!!")
	(define GLOBAL-TAG    "!!")
	(define LOCAL-TAG     "!")
```
Any line that does not start with one of these tags is typed as `Token`.
