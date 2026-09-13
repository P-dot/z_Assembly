## Objective

Publish Lab 03 Part 1: local execution-harness validation and low-half
z/Architecture LOAD/addressing validation.

## Scope

- Phase 0 `HARN03`
- `LAB101`
- original, long-displacement and relative-long LOAD forms
- HLASM Source/Object and literal-pool analysis
- USING Map / GPR cross-reference
- explicit AMODE 31 / RMODE ANY
- controlled S0C1 diagnostic workflow

`LAB102` and `LAB103` remain out of scope and Lab 03 remains in progress.

## Systems/components affected

- IBM z/OS V1R11 ADCD
- zPDT
- TSO/ISPF
- JES2/SDSF
- High Level Assembler
- Binder
- ASMACLG

## Validation performed

- HLASM RC 0000
- Binder RC 0000
- expected R2-R8 values observed
- expected S0C1 observed
- literal and object-code relationships validated
- AMODE 31 / RMODE ANY confirmed in Binder output
- evidence SHA-256 manifest generated

## Expected result

Part 1 PASS; overall Lab 03 remains in progress.

## Negative / diagnostic behavior

The S0C1 is intentional and produced by execution reaching `DC H'0'`.

## Rollback

Revert this PR. No z/OS system configuration is changed by the repository
publication.

## Publication security

Selected evidence was visually reviewed. Repository text is scanned for
IP/MAC patterns before commit.

## Related work

- Lab 01 — DEMO1 / R15 return code
- Lab 02 — defining storage / representation / alignment
- Future Lab 03 Part 2 — LAB102 and LAB103
