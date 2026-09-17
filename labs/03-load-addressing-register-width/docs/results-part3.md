# Results — Lab 03 Part 3

## Status

**PASS**

## Toolchain

Observed:

```text
Assembler step C  RC=0000
Binder step L     RC=0000
No Statements Flagged in this Assembly
HLASM Return Code 000
Binder Return Code 0
Entry point LAB103
AMODE 31
RMODE ANY
```

Execution ended with the planned S0C1 after the tested instructions.

## Runtime registers

```text
R2 = 4A174876_E8000000
R3 = FFFFFFFF_FFFFFFFF
R4 = FFFFFFFF_FFFF8000
R5 = 4A174876_E8000000
R6 = FFFFFFFF_FFFFFFFF
R7 = FFFFFFFF_FFFF8000
R8 = FFFFFFFF_FFFE0000
R9 = 00000000_00000000
```

Validated relationships:

```text
R2 = R5
R3 = R6
R4 = R7
```

## Program data

The Source/Object listing shows:

```text
DW1 = 4A174876E8000000
F1  = FFFFFFFF
H1  = 8000
```

`LG` and `LGRL` both copied the exact DW1 bit pattern.

`LGF` / `LGFRL` sign-extended `F1=-1`.

`LGH` / `LGHRL` sign-extended `H1=-32768`.

`LGFI` produced the signed 64-bit form of `-131072`.

`LGHI` produced zero.

## Diagnostic termination location

The listing places the controlled `DC H'0'` before the aligned program data.
The dump reports the operation exception after this deliberate invalid
instruction field, confirming that all LOAD operations were reached first.

## Final assessment

LAB103 completes the 64-bit register portion of IBM Exercise 3.

**Lab 03 overall closure: PASS.**
