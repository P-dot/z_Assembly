# Lab 03 — LOAD, Addressing and Register Width

> **Published milestone:** Part 2 complete  
> **Overall Lab 03 status:** In progress  
> **Completed scope:** Phase 0 + LAB101 + LAB102 negative/control/corrected  
> **Remaining scope:** LAB103 — 64-bit LOAD variants and sign extension

## Purpose

This lab studies LOAD not merely as data movement, but as an addressability and
register-width problem on a real z/OS V1R11 ADCD system.

The engineering flow is:

```text
theory
  -> hypothesis
  -> implementation
  -> negative control
  -> HLASM/Binder/runtime observation
  -> evidence
  -> diagnosis
  -> corrected implementation
```

## Architecture V2 classification

| Attribute | Value |
|---|---|
| Primary domain | Application and Data Engineering |
| Capability | z/Architecture register loading and addressability |
| Lifecycle | Baseline -> Operate -> Observe -> Diagnose |
| Current maturity | M2 Operational |
| Platform | z/OS V1R11 / ADCD / zPDT |
| Toolchain | ASMACLG -> HLASM -> Binder -> execution -> SDSF |
| Overall Lab 03 | In progress |

## Milestones

```text
Lab 03
|
+-- Phase 0 - execution harness validation             COMPLETE
|
+-- LAB101 - original / long / relative LOAD          COMPLETE
|
+-- LAB102 - no-base-register design                  COMPLETE
|     |
|     +-- negative addressability control
|     +-- ASMA307E diagnostics
|     +-- standard ASMACLG RC=8 behavior discovery
|     +-- relative-addressing correction
|     +-- immediate-operand correction
|     +-- LFI compatibility discovery
|     +-- IILF adaptation for local HLASM
|
+-- LAB103 - 64-bit LOAD and sign extension            PENDING
```

## Part 1

Part 1 remains documented through:

- `docs/theory-part1.md`
- `docs/experiment-plan-part1.md`
- `docs/instruction-matrix-part1.md`
- `docs/results-part1.md`
- `docs/troubleshooting-part1.md`
- `docs/evidence-index-part1.md`

It validated:

- the local ASMACLG/SYSUDUMP harness;
- `L`, `LH`, `LR`;
- `LY`, `LHY`;
- `LRL`, `LHRL`;
- literal pools;
- USING Map and GPR cross-reference;
- explicit `AMODE 31` / `RMODE ANY`;
- controlled S0C1 diagnostics.

## Part 2 — LAB102

### Objective

LAB102 removes base-register addressability and proves which instruction forms
can still be assembled and executed.

The central transformation is:

```text
base-dependent storage reference      no-base equivalent
--------------------------------      ------------------
L   2,=F'170'                         LRL  2,=F'170'
LH  3,=H'4095'                        LHRL 3,=H'4095'
LR  4,3                               LR   4,3
LY  5,=F'187'                         IILF 5,187
LHY 6,=H'2048'                        LHI  6,2048
```

`IILF` is used in the local environment because the course mnemonic `LFI`
was not recognized by this HLASM level.

---

## Negative control — L102NEG

The experiment deliberately removes:

```asm
         LARL  12,LAB102N
         USING LAB102N,12
```

while retaining storage-referencing instructions that require addressability.

HLASM produced four expected addressability errors:

```text
ASMA307E No active USING for operand =F'170'
ASMA307E No active USING for operand =H'4095'
ASMA307E No active USING for operand =F'187'
ASMA307E No active USING for operand =H'2048'
```

`LR 4,3` still generated object code because it is register-to-register and
does not need a storage effective address.

HLASM completed with:

```text
Return Code 008
```

### Unexpected but important local behavior

The original hypothesis expected the Binder and GO phases not to run after
assembly RC 8.

On this system, the standard `ASMACLG` procedure continued through Binder and
execution. The incomplete object contained zero-filled instruction fields for
the statements HLASM could not resolve, and execution then reached invalid
operation bytes and produced S0C1.

This is recorded as a platform/toolchain discovery, not hidden as noise.

---

## Compatibility discovery — LFI

The first corrected LAB102 attempt followed the newer course mnemonic:

```asm
         LFI   5,187
```

The local HLASM returned:

```text
ASMA057E Undefined operation code - LFI
```

This established a real compatibility difference between the modern training
material and the older ADCD/HLASM environment.

For this lab the compatible low-fullword immediate operation is written as:

```asm
         IILF  5,187
```

The corrected run assembled cleanly and produced the required low-order
fullword value in R5.

---

## Final corrected LAB102

Final source:

```asm
LAB102   CSECT
LAB102   AMODE 31
LAB102   RMODE ANY

         LRL   2,=F'170'
         LHRL  3,=H'4095'
         LR    4,3
         IILF  5,187
         LHI   6,2048

         DC    H'0'
         END   LAB102
```

There is intentionally no `LARL`/`USING` base-register setup.

### Final result

| Check | Expected | Observed |
|---|---|---|
| HLASM | RC 0000 | RC 0000 |
| Binder | RC 0000 | RC 0000 |
| Entry point | LAB102 | LAB102 |
| AMODE | 31 | 31 |
| R2 low | `000000AA` | `000000AA` |
| R3 low | `00000FFF` | `00000FFF` |
| R4 low | `00000FFF` | `00000FFF` |
| R5 low | `000000BB` | `000000BB` |
| R6 low | `00000800` | `00000800` |
| Execution | controlled S0C1 | controlled S0C1 |

The final HLASM summary reports:

```text
No Statements Flagged in this Assembly
Return Code 000
```

The Binder summary reports return code 0 and entry point `LAB102`.

The S0C1 in the final run is again deliberate: execution has successfully
completed the instructions under test and then falls through into `DC H'0'`.

## Evidence discipline

The final evidence proves functional correctness and toolchain success.

The final rerun did not capture a fresh Source/Object screen containing the
`IILF` bytes, so this milestone deliberately does **not** claim a byte-for-byte
object-code proof for `IILF`. Its behavior is instead validated by:

- clean HLASM RC 000;
- R5 low-order value `000000BB`;
- successful Binder RC 0;
- controlled termination after the tested instructions.

That distinction is intentional and keeps evidence claims auditable.

## Part 2 result

**PASS — LAB102 is complete and publishable.**

Lab 03 itself remains open until LAB103 validates full 64-bit LOAD variants and
sign extension.

## Part 2 documentation

- `docs/theory-part2.md`
- `docs/experiment-plan-part2.md`
- `docs/results-part2.md`
- `docs/troubleshooting-part2.md`
- `docs/compatibility-lfi-iilf.md`
- `docs/evidence-index-part2.md`
- `docs/security-review-part2.md`

## References

- IBM, *z/Architecture Assembler. Part 2: Machine Instructions*, Exercise 3.
- IBM High Level Assembler documentation.
- IBM z/OS Binder / program management documentation.

The IBM course is used as a technical learning source. Course solution files
and proprietary training assets are not reproduced.
