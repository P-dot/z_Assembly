## Objective

Publish Lab 03 Part 2: LAB102 no-base-register LOAD engineering experiment.

## Scope

- L102NEG negative addressability control
- ASMA307E / HLASM RC 8 analysis
- standard ASMACLG continuation after RC 8
- relative-addressing correction with LRL / LHRL
- immediate operand correction
- LFI compatibility failure on local HLASM
- IILF adaptation
- final R2-R6 runtime validation
- controlled S0C1 diagnostic termination

LAB103 remains out of scope. Lab 03 remains in progress.

## Validation

Negative control:
- four ASMA307E diagnostics observed
- LR remained encodable
- HLASM RC 008 observed

Compatibility:
- LFI rejected with ASMA057E
- IILF adaptation validated

Final LAB102:
- no statements flagged
- HLASM RC 000
- Binder RC 0
- entry point LAB102
- AMODE 31
- expected R2-R6 values observed
- controlled final S0C1 observed

## Evidence boundary

The final rerun did not capture a fresh Source/Object screen containing IILF
object bytes, so no byte-level IILF encoding claim is made.

## Publication security

Selected screenshots were visually reviewed and repository text is scanned for
IP/MAC patterns before commit.

## Rollback

Revert the PR. Repository publication does not alter z/OS system
configuration.

## Related work

- Lab 03 Part 1 — HARN03 + LAB101
- Future Lab 03 Part 3 — LAB103 64-bit LOAD/sign extension
