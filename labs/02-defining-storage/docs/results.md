# Lab 02 — Validation Results

## LAB001

Validated from SDSF and the HLASM Source/Object listing:

- cataloged procedure `ASMAC` expanded from the system HLASM procedure library
- assembly step condition code `0000`
- no statements flagged
- HLASM return code `000`
- halfword, fullword, and doubleword object values match the requested decimal values
- negative integer constants are represented in two's complement
- automatic fullword and doubleword alignment is visible in the location/object listing
- CSECT length: `X'30'`

## LAB002

Validated from SDSF and the HLASM Source/Object listing:

- assembly step condition code `0000`
- no statements flagged
- HLASM return code `000`
- `C'Hello'` encoded as EBCDIC `C885939396`
- `CL10'Hello'` padded with five EBCDIC blanks (`40`)
- `CL4'XXXYYYZZZ'` truncated to EBCDIC `XXXY` (`E7E7E7E8`)
- `8C'*'` and `C'********'` both generate eight `X'5C'` bytes
- `3CL2'*'` generates `5C405C405C40`
- `X'A000'` and `H'-24576'` have the same bytes but different alignment semantics
- HLASM inserts one alignment byte at `00002B` before the signed halfword
- hexadecimal `1A2B` and the equivalent binary bit string generate identical bytes
- `DS 0F` advances the location counter to fullword boundary `000034`
- `B'11110000'` generates `F0`
- CSECT length: `X'35'`

## Final status

**PASS — both members assembled successfully with RC 0000.**
