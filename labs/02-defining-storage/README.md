# Lab 02 — Defining Storage

**Status:** Complete  
**Platform:** IBM z/OS V1R11 (ADCD) under zPDT  
**Tools:** TSO/ISPF, SDSF, IBM High Level Assembler  
**Cataloged procedure:** `ASMAC`

## Objective

Reproduce and validate the storage-definition concepts from the IBM z/Architecture Assembler training exercise in a local z/OS environment.

The lab demonstrates:

- signed binary integer constants in halfword, fullword, and doubleword formats
- two's-complement representation of negative integers
- automatic alignment of binary integer constants
- EBCDIC character constants and explicit lengths
- truncation and padding behavior
- duplication factors
- hexadecimal and bit-string definitions
- representation equivalence between differently typed constants
- explicit fullword-boundary alignment with `DS 0F`
- interpretation of the HLASM Source/Object listing

The IBM-hosted training data sets and solution libraries are not required. The exercise was adapted to `IBMUSER.ASM.JCL` and executed with the standard `ASMAC` procedure available on the local system.

## Why `ASMAC` is used

This lab studies what the assembler generates for storage definitions. There is no executable program to link or run, so only the assembly phase is required.

```text
Assembler source
      |
      v
    HLASM
      |
      +--> object representation
      +--> locations / alignment
      +--> source-object listing
      +--> assembler diagnostics
```

Unlike Lab 01, there is no Binder or GO step.

---

## Part 1 — Signed binary integers (`LAB001`)

Source: [`jcl/LAB001.jcl`](jcl/LAB001.jcl)

### Definitions

```asm
H1       DC    H'100'
H2       DC    H'-1'
H3       DC    H'32767'

F1       DC    F'100'
F2       DC    F'-1'
F3       DC    F'32768'

D1       DC    FD'100'
D2       DC    FD'0'
D3       DC    FD'-4095'
```

### Observed HLASM output

| Location | Definition | Object representation |
|---:|---|---|
| `000000` | `H1 DC H'100'` | `0064` |
| `000002` | `H2 DC H'-1'` | `FFFF` |
| `000004` | `H3 DC H'32767'` | `7FFF` |
| `000006` | alignment | `0000` |
| `000008` | `F1 DC F'100'` | `00000064` |
| `00000C` | `F2 DC F'-1'` | `FFFFFFFF` |
| `000010` | `F3 DC F'32768'` | `00008000` |
| `000014` | alignment | `00000000` |
| `000018` | `D1 DC FD'100'` | `0000000000000064` |
| `000020` | `D2 DC FD'0'` | `0000000000000000` |
| `000028` | `D3 DC FD'-4095'` | `FFFFFFFFFFFFF001` |

### What this proves

`H`, `F`, and `FD` define signed binary integers of 16, 32, and 64 bits respectively.

The negative values are stored using two's complement:

```text
H'-1'       -> FFFF
F'-1'       -> FFFFFFFF
FD'-4095'   -> FFFFFFFFFFFFF001
```

The listing also makes automatic alignment visible. After the three halfwords, the location counter is at `X'000006'`; HLASM aligns the following fullword to `X'000008'`. After the three fullwords, it aligns the first doubleword from `X'000014'` to `X'000018'`.

The final CSECT length is `X'30'` (48 bytes):

```text
halfwords             6 bytes
alignment             2 bytes
fullwords            12 bytes
alignment             4 bytes
doublewords          24 bytes
                     --------
total                48 bytes
```

### Result

- `ASMAC` expanded successfully.
- Assembly step condition code: `0000`.
- HLASM: **No statements flagged in this assembly**.
- HLASM return code: `000`.

---

## Part 2 — Characters, hexadecimal, and bit strings (`LAB002`)

Source: [`jcl/LAB002.jcl`](jcl/LAB002.jcl)

### Character constants

```asm
HI       DC    C'Hello'
HI2      DC    CL10'Hello'
```

The Source/Object listing shows:

```text
000000 C885939396
000005 C8859393964040404040
```

`HI` occupies five bytes. `HI2` has an explicit length of ten bytes, so HLASM pads the remaining five bytes with EBCDIC blanks (`X'40'`).

### Explicit length and truncation

```asm
         DC    CL4'XXXYYYZZZ'
```

Observed object code:

```text
00000F E7E7E7E8
```

This is EBCDIC `XXXY`. The nominal character string is longer than the requested length, so the value is truncated on the right to four bytes.

### Duplication factor versus string length

```asm
C1       DC    8C'*'
C2       DC    C'********'
         DC    3CL2'*'
```

Observed:

```text
000013 5C5C5C5C5C5C5C5C
00001B 5C5C5C5C5C5C5C5C
000023 5C405C405C40
```

`C1` and `C2` both occupy eight bytes containing eight EBCDIC asterisks (`X'5C'`), but they express the storage differently:

- `8C'*'` repeats a one-byte constant eight times.
- `C'********'` defines one eight-byte character constant.

`3CL2'*'` repeats a **two-byte** character constant three times. Each `CL2'*'` contains an asterisk plus one EBCDIC blank, so the result is:

```text
5C40 5C40 5C40
```

for six bytes total.

### Same bits, different type and alignment

```asm
X1       DC    X'A000'
H1       DC    H'-24576'
```

Observed:

```text
000029 A000       X1
00002B 00         alignment byte
00002C A000       H1
```

The two constants have the same two-byte contents (`X'A000'`) but different semantics.

`X1` is a hexadecimal string. `H1` is a signed halfword integer and therefore must begin on a halfword boundary. HLASM inserts one alignment byte before `H1`.

This is an important distinction:

> Equal bit patterns do not imply equal type or equal alignment requirements.

### Hexadecimal and bit-string equivalence

```asm
X2       DC    X'1A2B'
B2       DC    B'0001101000101011'
```

Observed:

```text
00002E 1A2B
000030 1A2B
```

The bit string:

```text
0001 1010 0010 1011
```

is exactly hexadecimal:

```text
1    A    2    B
```

so both fields contain the same object bytes.

### Explicit fullword alignment

```asm
         DS    0F
B3       DC    B'11110000'
```

Before the alignment request, the location counter is `X'32'`. `DS 0F` has a zero duplication factor, so it does not define a fullword field; instead, its fullword alignment requirement advances the location counter to the next four-byte boundary:

```text
X'32' -> X'34'
```

The listing then places `B3` at:

```text
000034 F0
```

because:

```text
B'11110000' = X'F0'
```

The final `LAB002` CSECT length is `X'35'`.

### Result

- `ASMAC` expanded successfully.
- Assembly step condition code: `0000`.
- HLASM: **No statements flagged in this assembly**.
- HLASM return code: `000`.

---

## Lab result

Both parts completed successfully.

| Part | Member | Purpose | Result |
|---|---|---|---|
| 1 | `LAB001` | Signed binary integer storage and automatic alignment | `RC=0000` |
| 2 | `LAB002` | Character, hexadecimal, bit strings, lengths, duplication, explicit alignment | `RC=0000` |

The lab demonstrates not only how to write `DC`/`DS` definitions, but how to verify exactly what HLASM generated by reading the Source/Object listing.

## Evidence

See [`docs/evidence-index.md`](docs/evidence-index.md).

## References

- IBM, *z/Architecture Assembler — Part 2: Machine Instructions*, Exercise 2: **Defining storage**, 2023.
- IBM High Level Assembler documentation — assembler listings, source/object output, alignment, and data-definition concepts.

No IBM solution data set or IBM course infrastructure is included in this repository.
