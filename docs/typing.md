# Typing of records, spines, and tokens
Types are understood as enumerations, and implemented as hashes with key-value
pairs of type Symbol -> RegularExpression. These enumerations include:
`HumdrumRecordType`, `HumdrumTokenType`, `ExclusiveInterpretation`, and
`TandemInterpretation`.

`HumdrumRecordType` and `HumdrumTokenType` represent the general types of the
formal Humdrum syntax; See Humdrum Guide, Chapter 5. Any valid record can be
typed as one-and-only-one subclass of `HumdrumRecordType`, and any valid token
can be typed as one-and-only-one subclass of `HumdrumTokenType`.

Tokens may be specified as one of the known `ExclusiveInterpretation` or
`TandemInterpretation` types. Because users may define their own data
representations in the Humdrum syntax, `hum-parser` must allow for tokens that
do not have a known type. (Here, "known" means known to `hum-parser`.) When
trying to type a token as a sublcass of `ExclusiveInterpretation` or
`TandemInterpretation`, it will be typed as `'Unknown` if its string cannot
match one of the regular expressions in those hashes.

An `'Unknown` type can be reported as an
[issue on the GitHub repo](https://github.com/bel28kent/hum-parser/issues).
