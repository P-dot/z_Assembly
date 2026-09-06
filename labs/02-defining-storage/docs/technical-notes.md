# Technical Notes

## `DC` versus `DS`

`DC` defines storage with an initial value. `DS` describes/reserves storage and can also be used to impose alignment.

This lab uses `DS 0F` specifically for alignment. The zero duplication factor means that no fullword field is defined by that statement, but the `F` type still imposes its fullword boundary requirement on the location counter.

## Signed binary integer types

- `H` — halfword, 16-bit signed binary integer
- `F` — fullword, 32-bit signed binary integer
- `FD` — doubleword, 64-bit signed binary integer

`FD` is deliberately used for the 64-bit **integer** definitions. A bare `D` is a floating-point constant type and is not the integer representation being demonstrated here.

## Alignment observed in LAB001

The listing visibly demonstrates boundary alignment:

- `H1/H2/H3` consume 6 bytes.
- `F1` starts at `000008`; 2 alignment bytes appear after `H3`.
- `D1` starts at `000018`; 4 alignment bytes appear after `F3`.

## EBCDIC observations in LAB002

Relevant byte values visible in the listing include:

- `H` -> `C8`
- `e` -> `85`
- `l` -> `93`
- `o` -> `96`
- blank -> `40`
- `X` -> `E7`
- `Y` -> `E8`
- `*` -> `5C`

The object listing therefore provides direct evidence that character constants are being generated in the z/OS EBCDIC code page used by the assembler job.

## Duplication and explicit length

These two concepts are independent:

```asm
8C'*'
```

repeats a one-byte character constant eight times.

```asm
3CL2'*'
```

defines a two-byte character constant and repeats it three times. Since the nominal value contains one character, each two-byte instance is padded with one EBCDIC blank.

## Identical representation does not mean identical definition

`X1 DC X'A000'` and `H1 DC H'-24576'` both generate `A000`.

However:

- `X1` is a hexadecimal string.
- `H1` is a signed halfword integer.
- `H1` carries a halfword alignment requirement.

The inserted `00` at location `00002B` is evidence of that distinction.

## Why the lab uses `ASMAC`

No machine instructions are executed in this exercise. The target is the assembler-generated storage and listing, so the assemble-only cataloged procedure is sufficient. Link-edit and GO phases would add no value to the exercise.
