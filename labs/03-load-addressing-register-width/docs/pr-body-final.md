## Objective

Complete Lab 03 by publishing LAB103: full 64-bit LOAD, relative addressing,
immediate operands and sign-extension validation.

## Scope

- LG / LGF / LGH
- LGRL / LGFRL / LGHRL
- LGFI / LGHI
- complete 64-bit R2-R9 validation
- 16->64 and 32->64 sign extension
- HLASM Source/Object analysis
- program-data representation
- USING Map and GPR cross-reference
- Binder AMODE 31 / RMODE ANY
- controlled S0C1 diagnostic termination
- final Lab 03 documentation and status

## Validation

- HLASM RC 000
- no statements flagged
- Binder RC 0
- entry point LAB103
- AMODE 31
- RMODE ANY
- R2 = R5
- R3 = R6
- R4 = R7
- R8 = FFFFFFFFFFFE0000
- R9 = 0000000000000000
- expected controlled S0C1 observed

## Representation correction

The source uses:

```asm
DW1 DC D'100000000000'
```

The assembler listing generates `4A174876E8000000`, and R2/R5 contain the
same bit pattern.

The final documentation explicitly records that D-type representation rather
than incorrectly describing the field as the fixed-binary pattern
`000000174876E800`.

## Result

This PR completes all Lab 03 milestones:

- Phase 0 — PASS
- LAB101 — PASS
- LAB102 — PASS
- LAB103 — PASS

**Lab 03 status: COMPLETE**

## Publication security

Curated screenshots were visually reviewed and repository text is scanned
before commit.

## Rollback

Revert this PR. The publication does not modify z/OS system configuration.
