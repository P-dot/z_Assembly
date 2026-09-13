# Lab 03 — LOAD, Addressing and Register Width

> **Published milestone:** Part 1 complete  
> **Overall Lab 03 status:** In progress  
> **Completed scope:** Phase 0 (`HARN03`) + `LAB101`  
> **Remaining scope:** `LAB102` + `LAB103`

## Purpose

This laboratory turns the IBM z/Architecture LOAD exercise into a reproducible
engineering experiment on a local z/OS V1R11 ADCD system running under zPDT.

Part 1 establishes two foundations:

1. a controlled execution/diagnostic harness that can expose GPR state after an
   intentional S0C1; and
2. validated execution of original, long-displacement and relative-addressing
   LOAD instruction families that operate on the low 32 bits of general-purpose
   registers.

The goal is not only to assemble valid instructions. The lab connects:

```text
source
  -> HLASM object code
  -> addressability model
  -> Binder attributes
  -> runtime GPR contents
  -> diagnostic evidence
```

## Architecture V2 classification

| Attribute | Value |
|---|---|
| Primary domain | Application and Data Engineering |
| Capability | z/Architecture register loading and addressability |
| Lifecycle | Baseline -> Operate -> Observe |
| Part 1 maturity | M2 Operational |
| Platform | z/OS V1R11 / ADCD / zPDT |
| Toolchain | ASMACLG -> HLASM -> Binder -> execution -> SDSF |
| Runtime diagnostic | Controlled S0C1 with `SYSUDUMP` |
| Overall Lab 03 | In progress |

## Part 1 scope

```text
Lab 03
|
+-- Phase 0 - HARN03
|     |
|     +-- validate ASMACLG
|     +-- validate controlled S0C1
|     +-- validate SYSUDUMP/GPR evidence
|     +-- establish Binder baseline
|
+-- LAB101
      |
      +-- L / LH / LR
      +-- LY / LHY
      +-- LRL / LHRL
      +-- literal pool inspection
      +-- USING Map
      +-- GPR verification
      +-- explicit AMODE 31 / RMODE ANY
```

`LAB102` and `LAB103` are intentionally not claimed as complete in this
milestone.

---

## Phase 0 — Execution Harness Validation

Source: [`jcl/HARN03.jcl`](jcl/HARN03.jcl)

The harness was created before reproducing `LAB101` in order to validate the
local ADCD execution path rather than assuming that IBM's hosted training
infrastructure and procedures behave identically to this system.

The job uses the standard `ASMACLG` procedure:

```text
C -> assemble
L -> bind
G -> execute
```

The program loads known values into R2, R3 and R4, then intentionally reaches:

```asm
         DC    H'0'
```

`X'0000'` is data, not a valid executable opcode. Reaching it produces the
expected operation exception / S0C1. `SYSUDUMP` is attached to the `G` step so
the runtime register state is observable.

### Harness result

| Check | Expected | Observed |
|---|---|---|
| HLASM | RC 0000 | RC 0000 |
| Binder | RC 0000 | RC 0000 |
| Execution | S0C1 | S0C1 |
| R2 low | `000000AA` | `000000AA` |
| R3 low | `00000FFF` | `00000FFF` |
| R4 low | `00000FFF` | `00000FFF` |

The initial Binder baseline also exposed a useful environmental default:
without explicit source attributes, the module was built with legacy
24-bit residency/addressing attributes. That observation drove the explicit
`AMODE 31` / `RMODE ANY` declarations in `LAB101`.

---

## LAB101 — Low-half LOAD instruction families

Source: [`jcl/LAB101.jcl`](jcl/LAB101.jcl)

### Addressability prolog

```asm
LAB101   CSECT
LAB101   AMODE 31
LAB101   RMODE ANY

         LARL  12,LAB101
         USING LAB101,12
```

`LARL` executes at runtime and loads the CSECT address into R12.

`USING` is an assembler instruction. It does not modify R12; it tells HLASM
that R12 is available as an addressability base for the declared range.

The runtime dump confirmed that R12 contained the same address reported for
the active load module.

### Instruction families

| Family | Instructions | Addressing model | Result width |
|---|---|---|---|
| Original | `L`, `LH` | base + 12-bit unsigned displacement | low 32 bits |
| Register | `LR` | register to register | low 32 bits |
| Long displacement | `LY`, `LHY` | base + 20-bit signed displacement | low 32 bits |
| Relative-long | `LRL`, `LHRL` | instruction-relative | low 32 bits |

### Expected versus observed registers

| GPR | Instruction | Expected low 32 bits | Observed |
|---|---|---:|---:|
| R2 | `L 2,=F'170'` | `000000AA` | `000000AA` |
| R3 | `LH 3,=H'4095'` | `00000FFF` | `00000FFF` |
| R4 | `LR 4,3` | `00000FFF` | `00000FFF` |
| R5 | `LY 5,=F'187'` | `000000BB` | `000000BB` |
| R6 | `LHY 6,=H'2048'` | `00000800` | `00000800` |
| R7 | `LRL 7,=F'1024000'` | `000FA000` | `000FA000` |
| R8 | `LHRL 8,=H'255'` | `000000FF` | `000000FF` |

All expected values were observed.

---

## Object-code validation

The HLASM Source/Object listing shows the relationship between source,
instruction format and literal placement.

Examples from the validated run include:

```text
000006  5820 C030      L    2,=F'170'
00000A  4830 C03C      LH   3,=H'4095'
00000E  1843           LR   4,3
```

For `L`:

```text
58   = opcode
2    = destination register R2
C    = base register R12
030  = displacement X'030'
```

The literal pool contains:

```text
000030  000000AA       =F'170'
```

so the effective address is resolved through:

```text
R12 + X'030' -> =F'170'
```

The listing also shows that `LY` and `LHY` are six-byte instructions using the
long-displacement formats.

### Relative-long verification

The relative instructions provide a particularly strong validation because the
encoded relative displacement can be reconciled with the listing locations.

For `LRL`:

```text
instruction location = X'1C'
literal location     = X'38'
byte distance        = X'1C' = 28 decimal
halfword distance    = 14 = X'0000000E'
```

The listing encodes the relative field as `0000000E`.

For `LHRL`:

```text
instruction location = X'22'
literal location     = X'40'
byte distance        = X'1E' = 30 decimal
halfword distance    = 15 = X'0000000F'
```

The listing encodes `0000000F`.

This demonstrates instruction-relative address formation rather than simply
stating that the instructions are relative.

---

## Literal pool

The validated listing contains:

```text
000030  000000AA   =F'170'
000034  000000BB   =F'187'
000038  000FA000   =F'1024000'
00003C  0FFF       =H'4095'
00003E  0800       =H'2048'
000040  00FF       =H'255'
```

This also connects Lab 03 with the alignment and representation concepts
validated previously in Lab 02.

---

## Binder validation

Unlike the Phase 0 harness baseline, `LAB101` explicitly declares:

```asm
LAB101   AMODE 31
LAB101   RMODE ANY
```

The Binder evidence confirms:

```text
AMODE = 31
RMODE = ANY
ENTRY = LAB101
Binder RC = 0
```

This removes an unnecessary dependency on legacy defaults.

---

## Controlled S0C1

The S0C1 remains a deliberate diagnostic mechanism, not an unexpected failure.

Part 1 is successful only when all of the following are true:

```text
HLASM RC 0000
Binder RC 0000
expected GPR values observed
intentional S0C1 observed
diagnostic evidence captured
```

All criteria were met.

---

## Part 1 result

**PASS — Part 1 is complete and publishable.**

The complete Lab 03 is not yet closed. The next milestone will extend the same
lab with:

```text
LAB102 -> no base register / relative + immediate LOAD
LAB103 -> full 64-bit LOAD variants and sign extension
```

## Documentation

- [`docs/theory-part1.md`](docs/theory-part1.md)
- [`docs/experiment-plan-part1.md`](docs/experiment-plan-part1.md)
- [`docs/instruction-matrix-part1.md`](docs/instruction-matrix-part1.md)
- [`docs/results-part1.md`](docs/results-part1.md)
- [`docs/troubleshooting-part1.md`](docs/troubleshooting-part1.md)
- [`docs/evidence-index-part1.md`](docs/evidence-index-part1.md)
- [`docs/security-review.md`](docs/security-review.md)

## References

- IBM, *z/Architecture Assembler. Part 2: Machine Instructions*,
  Exercise 3 — Unit 1: LOAD (2023).
- IBM High Level Assembler documentation.
- IBM z/OS program management / Binder documentation.

The IBM course material is referenced as the learning source. IBM course pages,
solutions and proprietary training files are not reproduced in this repository.
