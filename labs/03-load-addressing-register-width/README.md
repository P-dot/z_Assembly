# Lab 03 — LOAD, Addressing and Register Width

> **Status:** Complete  
> **Platform:** IBM z/OS V1R11 ADCD under zPDT  
> **Toolchain:** HLASM -> Binder -> execution -> SDSF  
> **Architecture V2 domain:** Application and Data Engineering  
> **Capability:** z/Architecture register loading and addressability

## Purpose

Lab 03 turns IBM Exercise 3 (Unit 1: LOAD) into a reproducible engineering
study of how z/Architecture loads data into general-purpose registers.

The lab does not stop at valid source code. It connects:

```text
source
  -> instruction format
  -> addressability
  -> object code
  -> Binder attributes
  -> runtime GPR state
  -> diagnostic evidence
```

## Completed structure

```text
Lab 03
|
+-- Phase 0 - execution harness validation                 PASS
|
+-- Part 1 / LAB101 - low-half LOAD families              PASS
|     +-- L / LH / LR
|     +-- LY / LHY
|     +-- LRL / LHRL
|     +-- literal pool / USING Map / object code
|
+-- Part 2 / LAB102 - no-base-register design             PASS
|     +-- L102NEG negative control
|     +-- ASMA307E analysis
|     +-- ASMACLG RC=8 behavior discovery
|     +-- relative addressing
|     +-- immediate operands
|     +-- LFI compatibility failure
|     +-- local IILF adaptation
|
+-- Part 3 / LAB103 - full 64-bit LOAD operations         PASS
      +-- LG / LGF / LGH
      +-- LGRL / LGFRL / LGHRL
      +-- LGFI / LGHI
      +-- sign extension
      +-- full R2-R9 validation
```

## Part 1 — LAB101

Part 1 validated low-half register loading through several address formation
models.

| Family | Instructions | Main concept |
|---|---|---|
| Original | `L`, `LH` | base + 12-bit displacement |
| Register | `LR` | register-to-register |
| Long displacement | `LY`, `LHY` | base + 20-bit signed displacement |
| Relative-long | `LRL`, `LHRL` | instruction-relative addressing |

The execution harness used a controlled S0C1 plus `SYSUDUMP` to expose the GPR
state after the instructions under test.

## Part 2 — LAB102

LAB102 removed the R12/USING base-register dependency.

The negative control demonstrated that `L`, `LH`, `LY`, and `LHY` with
symbolic storage operands cannot be resolved without active addressability,
while `LR` remains valid because it is register-to-register.

Observed:

```text
ASMA307E No active USING ...
HLASM RC = 008
```

The standard local `ASMACLG` procedure continued after RC 8, which was retained
as a platform/toolchain discovery.

The corrected design used relative and immediate forms. A second compatibility
discovery occurred when the modern course mnemonic `LFI` was rejected by the
local HLASM with `ASMA057E`. The lab adapted that operation to `IILF`, then
revalidated the result at runtime.

Final LAB102 result:

```text
HLASM RC = 000
Binder RC = 0
R2 low = 000000AA
R3 low = 00000FFF
R4 low = 00000FFF
R5 low = 000000BB
R6 low = 00000800
```

## Part 3 — LAB103

LAB103 validates instructions that operate on complete 64-bit GPR values.

### Storage-based loads

```asm
         LG    2,DW1
         LGF   3,F1
         LGH   4,H1
```

### Relative-long loads

```asm
         LGRL  5,DW1
         LGFRL 6,F1
         LGHRL 7,H1
```

### Immediate loads

```asm
         LGFI  8,-131072
         LGHI  9,0
```

### Runtime results

| Register | Observed 64-bit value | Validation |
|---|---|---|
| R2 | `4A174876_E8000000` | equals the 8 bytes at `DW1` |
| R3 | `FFFFFFFF_FFFFFFFF` | `F1=-1`, sign-extended 32 -> 64 |
| R4 | `FFFFFFFF_FFFF8000` | `H1=-32768`, sign-extended 16 -> 64 |
| R5 | `4A174876_E8000000` | relative-long load equals R2 |
| R6 | `FFFFFFFF_FFFFFFFF` | relative-long load equals R3 |
| R7 | `FFFFFFFF_FFFF8000` | relative-long load equals R4 |
| R8 | `FFFFFFFF_FFFE0000` | `LGFI -131072` |
| R9 | `00000000_00000000` | `LGHI 0` |

Therefore:

```text
R2 = R5
R3 = R6
R4 = R7
```

The different address-formation methods produced identical loaded contents.

## Important representation note: DW1

The source intentionally follows the IBM exercise:

```asm
DW1      DC    D'100000000000'
```

The HLASM listing shows the generated eight bytes as:

```text
4A174876E8000000
```

and both `LG` and `LGRL` copy exactly those eight bytes into R2 and R5.

This must not be documented as the fixed-binary hexadecimal representation
`000000174876E800`. A `D` constant is an eight-byte long floating-point
constant representation in HLASM. For this exercise, the LOAD instructions are
being validated as 64-bit data movement: they copy the field's bit pattern into
the GPR.

This observation corrects an earlier working hypothesis and is preserved
explicitly so the published evidence matches the actual assembler output.

## Object-code observations

The final listing proves all three instruction families:

```text
LG / LGF / LGH
LGRL / LGFRL / LGHRL
LGFI / LGHI
```

It also shows:

```text
DW1 = 4A174876E8000000
F1  = FFFFFFFF
H1  = 8000
```

HLASM inserted alignment bytes before `DW1` so the 8-byte field begins on the
required boundary.

## Toolchain validation

Final LAB103 execution:

```text
HLASM              RC=0000
Statements flagged none
Binder             RC=0
Entry point        LAB103
AMODE              31
RMODE              ANY
Execution          S0C1 intentional
```

The final S0C1 is the same controlled diagnostic technique used elsewhere in
the lab. The invalid `DC H'0'` is reached only after the tested LOAD
instructions execute successfully.

## Overall result

**PASS — Lab 03 is complete.**

The lab now demonstrates:

- base-register addressability;
- original and long-displacement LOADs;
- relative-long address formation;
- immediate operands;
- literal-pool behavior;
- negative addressability diagnostics;
- HLASM compatibility adaptation;
- low-half GPR operations;
- full 64-bit GPR operations;
- signed 16->64 and 32->64 extension;
- Binder AMODE/RMODE propagation;
- evidence-driven runtime validation.

## Documentation

Part 1:

- `docs/theory-part1.md`
- `docs/experiment-plan-part1.md`
- `docs/instruction-matrix-part1.md`
- `docs/results-part1.md`
- `docs/troubleshooting-part1.md`
- `docs/evidence-index-part1.md`

Part 2:

- `docs/theory-part2.md`
- `docs/experiment-plan-part2.md`
- `docs/results-part2.md`
- `docs/troubleshooting-part2.md`
- `docs/compatibility-lfi-iilf.md`
- `docs/evidence-index-part2.md`

Part 3 / final closure:

- `docs/theory-part3.md`
- `docs/experiment-plan-part3.md`
- `docs/results-part3.md`
- `docs/instruction-matrix-final.md`
- `docs/final-summary.md`
- `docs/evidence-index-part3.md`
- `docs/security-review-part3.md`

## References

- IBM, *z/Architecture Assembler. Part 2: Machine Instructions*,
  Exercise 3 — Unit 1: LOAD (2023).
- IBM High Level Assembler documentation.
- IBM z/Architecture Principles of Operation / instruction documentation.
- IBM z/OS Binder / program management documentation.

IBM training material is referenced as the learning source. Proprietary course
solution files are not reproduced in this repository.
