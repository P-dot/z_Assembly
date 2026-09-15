# Compatibility Note — LFI to IILF

## Context

The 2023 training material uses:

```asm
LFI 5,187
```

The local z/OS V1R11 ADCD High Level Assembler rejected the mnemonic:

```text
ASMA057E Undefined operation code - LFI
```

## Local adaptation

The lab uses:

```asm
IILF 5,187
```

for the required low-fullword immediate result.

## Validation

The adapted source produced:

```text
HLASM RC 000
R5 low = 000000BB
```

Therefore the adaptation is accepted for this laboratory objective.

## Evidence boundary

The final rerun did not capture a new Source/Object screen containing the IILF
encoding. This document consequently makes a functional compatibility claim,
not a byte-level object-code claim.

That distinction should be preserved if the lab is later expanded.
