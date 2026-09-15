# Theory — Lab 03 Part 2

## 1. Addressability is an assembly-time requirement

A storage-referencing instruction needs an effective address representation.
For base-displacement forms, HLASM must know which base register can reach the
symbolic operand.

Removing `USING` does not make all instructions invalid. It specifically
removes assembler knowledge needed for base-dependent symbolic storage
references.

## 2. Why LR still works

`LR 4,3` names only registers. No storage effective address is required, so
HLASM can encode the instruction without any active USING.

## 3. Long displacement is still base displacement

`LY` and `LHY` increase displacement reach; they do not eliminate the base
register.

This lab proves the distinction by observing ASMA307E on both original and
long-displacement storage forms.

## 4. Relative addressing

`LRL` and `LHRL` locate their storage operands relative to the instruction
rather than through the R12 base-register model used in LAB101.

That lets the corrected program keep storage literals while removing the
dedicated base setup for those references.

## 5. Immediate operands

An immediate form does not need a separate storage constant to supply its
value.

The modern course uses `LFI`. The local HLASM did not recognize that mnemonic,
so this environment uses `IILF` for the low-fullword immediate operation
required by the exercise.

`LHI` is accepted directly for the halfword-immediate case.

## 6. Evidence-driven compatibility

The compatibility adaptation is not based only on documentation assumptions.

The sequence was observed directly:

```text
LFI 5,187
   -> ASMA057E Undefined operation code

IILF 5,187
   -> HLASM RC 000
   -> runtime R5 low = 000000BB
```

This is the expected engineering pattern for an older platform:

```text
modern source
   -> local failure
   -> diagnose local capability
   -> compatible source
   -> revalidate at runtime
```

## 7. Controlled S0C1

The final `DC H'0'` remains a diagnostic termination mechanism.

In the negative run, however, the S0C1 had a different cause: standard
ASMACLG continued after assembly RC 8 and the generated incomplete object
contained invalid zero-filled instruction bytes.

The two S0C1 events must not be conflated.
