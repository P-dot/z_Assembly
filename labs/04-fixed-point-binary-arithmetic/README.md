# Lab 04 — Fixed-Point Binary Arithmetic

> **Status:** In progress — Part 1 / LAB201 complete  
> **Platform:** IBM z/OS V1R11 ADCD under zPDT  
> **Toolchain:** HLASM -> Binder -> execution -> SDSF  
> **Architecture V2 domain:** Application and Data Engineering  
> **Capability:** z/Architecture fixed-point binary arithmetic

## Architecture metadata

```yaml
architecture:
  domain: "Application and Data Engineering"
  capability: "z/Architecture fixed-point binary arithmetic"
  lifecycle:
    - Baseline
    - Operate
    - Observe
    - Diagnose
    - Improve
  current_maturity: "M2 — Operational"
  target_maturity: "M3 — Resilient"
  integration_level: "I0 — Standalone"
validation_status: "PARTIALLY VALIDATED"
```

## Objective

Lab 04 studies fixed-point binary arithmetic at machine-instruction level and
connects source statements to object bytes, storage operands, immediate
operands, GPR contents, condition behavior and controlled diagnostic evidence.

The first published milestone is LAB201: 32-bit ADD and SUBTRACT using both
storage and immediate operands.

## Current structure

```text
Lab 04
|
+-- Part 1 / LAB201 — ADD and SUBTRACT                    PASS
|     +-- storage operands                                PASS
|     +-- immediate operands                              PASS
|     +-- local HLASM compatibility adaptation            PASS
|     +-- Source/Object and runtime GPR validation         PASS
|
+-- Part 2 / LAB202 — fixed-point overflow                PENDING
|
+-- Part 3 / LAB203 — MULTIPLY and DIVIDE                 PENDING
```

## LAB201 Part 1 — storage operands

```asm
         L     2,=F'40960'
         A     2,=F'2730'
         LR    3,2
         SH    3,=H'8738'
```

The arithmetic path is:

```text
40960 = X'0000A000'
2730  = X'00000AAA'

0000A000
+00000AAA
---------
0000AAAA
```

R2 is copied to R3 and the signed halfword `8738 = X'2222'` is subtracted:

```text
0000AAAA
-00002222
---------
00008888
```

Final observed low words:

```text
R2 = 0000AAAA
R3 = 00008888
```

## LAB201 Part 2 — immediate operands

The same calculation was repeated using immediate forms:

```asm
         IILF  4,40960
         AFI   4,2730
         LR    5,4
         AHI   5,-8738
```

The local HLASM does not recognize the newer course mnemonic `LFI`, already
discovered during Lab 03. `IILF` is therefore reused as the validated local
adaptation for inserting the low fullword.

Final observed low words:

```text
R4 = 0000AAAA
R5 = 00008888
```

Therefore:

```text
R2 low = R4 low
R3 low = R5 low
```

The storage and immediate paths produced the same arithmetic results.

## Object-code evidence

Final HLASM output:

```text
Loc     Object code         Statement

000006  5820 C028           L     2,=F'40960'
00000A  5A20 C02C           A     2,=F'2730'
00000E  1832                LR    3,2
000010  4B30 C030           SH    3,=H'8738'

000014  C049 0000 A000      IILF  4,40960
00001A  C249 0000 0AAA      AFI   4,2730
000020  1854                LR    5,4
000022  A75A DDDE           AHI   5,-8738

000026  0000                controlled diagnostic termination

000028  0000A000            =F'40960'
00002C  00000AAA            =F'2730'
000030  2222                =H'8738'
```

This is the key engineering comparison:

```text
storage form
instruction -> base/displacement -> memory bytes -> ALU

immediate form
instruction contains operand bits -> ALU
```

## Two's-complement validation

The immediate subtraction is implemented as addition of `-8738`.

```text
+8738 = X'2222'

invert:
X'DDDD'

+1:
X'DDDE'

-8738 as signed 16-bit = X'DDDE'
```

HLASM encoded that exact value in:

```text
A75A DDDE
```

`AHI` sign-extends the signed 16-bit immediate for the 32-bit arithmetic
operation, producing the same low-word result as `SH`.

## Runtime validation

Observed:

```text
R2 = 00000000_0000AAAA
R3 = 00000000_00008888
R4 = 00000000_0000AAAA
R5 = 00000000_00008888
```

The program then deliberately reaches `DC H'0'`, producing S0C1 after the
instructions under test have completed.

## Toolchain result

```text
HLASM             RC=000
Statements flagged: none
Binder            RC=0
Entry point       LAB201
AMODE             31
RMODE             ANY
Execution         S0C1 intentional
CSECT length      X'32' (50 bytes)
```

## Milestone result

**PASS — Lab 04 Part 1 / LAB201 is complete.**

This milestone validates:

- 32-bit storage-based ADD/SUBTRACT;
- fullword and halfword storage operand widths;
- register-to-register copy;
- immediate arithmetic;
- signed immediate two's-complement encoding;
- storage versus immediate operand flow;
- HLASM object-code interpretation;
- literal-pool movement after code growth;
- controlled runtime register validation.

## Remaining Lab 04 scope

- LAB202 — fixed-point overflow, condition code and controlled S0C8;
- LAB202 correction using 64-bit arithmetic;
- LAB203 — multiply/divide register-pair behavior;
- LAB203 64-bit multiply/divide.

## Next capability

**LAB202 — fixed-point overflow diagnosis and 64-bit correction.**

## References

- IBM Training, *z/Architecture Assembler. Part 2: Machine Instructions*,
  Exercise 4 — Binary arithmetic.
- IBM High Level Assembler documentation.
- IBM z/Architecture Principles of Operation.

IBM training material is used as the learning source. Proprietary solution
libraries are not reproduced.
