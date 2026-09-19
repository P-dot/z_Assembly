## Objective

Publish Lab 04 Part 1 / LAB201: fixed-point 32-bit ADD and SUBTRACT using both
storage and immediate operands on the local z/OS V1R11 ADCD/zPDT environment.

## Architecture V2

```text
Domain: Application and Data Engineering
Capability: z/Architecture fixed-point binary arithmetic
Lifecycle: Baseline / Operate / Observe / Diagnose / Improve
Current maturity: M2 — Operational
Target maturity: M3 — Resilient
Integration level: I0 — Standalone
Validation status: PARTIALLY VALIDATED
```

## Scope

- `L`, `A`, `LR`, `SH`
- `IILF`, `AFI`, `AHI`
- storage vs immediate operand flow
- 16-bit signed halfword use in 32-bit arithmetic
- two's-complement immediate encoding
- Source/Object inspection
- literal-pool placement and changed displacements
- runtime R2-R5 validation
- AMODE 31 / RMODE ANY
- controlled S0C1 diagnostic termination

LAB202 and LAB203 remain out of scope for this milestone.

## Local compatibility adaptation

The training material uses `LFI` for the low-fullword immediate load.

The local HLASM level previously rejected `LFI`; the repository therefore uses
the already validated local adaptation:

```asm
IILF 4,40960
```

## Validation

```text
HLASM RC = 000
No Statements Flagged
Binder RC = 0
Entry point = LAB201
AMODE = 31
RMODE = ANY
CSECT length = X'32'
Execution = controlled S0C1
```

Observed registers:

```text
R2 = 00000000_0000AAAA
R3 = 00000000_00008888
R4 = 00000000_0000AAAA
R5 = 00000000_00008888
```

Therefore:

```text
R2 low = R4 low
R3 low = R5 low
```

## Object-code evidence

```text
5820 C028          L     2,=F'40960'
5A20 C02C          A     2,=F'2730'
1832               LR    3,2
4B30 C030          SH    3,=H'8738'

C049 0000 A000     IILF  4,40960
C249 0000 0AAA     AFI   4,2730
1854               LR    5,4
A75A DDDE          AHI   5,-8738
```

The `DDDE` field directly validates the signed 16-bit two's-complement encoding
of `-8738`.

## Evidence

The milestone includes:

- reproducible final JCL/source;
- curated ISPF/SDSF evidence;
- HLASM Source/Object output;
- runtime GPR evidence;
- Binder attributes;
- theory and experiment plan;
- instruction matrix;
- troubleshooting notes;
- evidence index;
- SHA-256 integrity manifest;
- publication security review.

## Result

**Lab 04 Part 1 / LAB201: PASS**

Lab 04 remains **IN PROGRESS**.

## Next capability

LAB202 — fixed-point overflow, condition-code/exception diagnosis and 64-bit
correction.

## Rollback

Revert this PR. Repository publication makes no z/OS system configuration
change.
