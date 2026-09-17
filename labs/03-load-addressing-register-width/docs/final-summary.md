# Lab 03 Final Engineering Summary

Lab 03 progressed from a basic LOAD exercise into a platform-adapted
addressability and register-width study.

## What was proved

1. The local ASMACLG/Binder/SYSUDUMP harness is reproducible.
2. Base-displacement LOADs can be reconciled with HLASM object code and literal
   locations.
3. Long displacement extends reach but does not remove the base register.
4. Relative-long instructions remove the base-register dependency for the
   tested storage operands.
5. Register-to-register operations do not need storage addressability.
6. Immediate operations can eliminate storage literals.
7. Negative addressability failures are diagnosable through ASMA307E.
8. The local standard ASMACLG behavior after RC 8 differs from the initial
   training-procedure assumption and was documented rather than hidden.
9. The modern `LFI` mnemonic is not accepted by the local HLASM; `IILF` was
   validated as the local adaptation for the LAB102 objective.
10. Full 64-bit loads and 16/32-bit sign extension were validated in LAB103.

## Evidence quality

The lab uses multiple independent evidence layers:

```text
source
listing/object code
symbol/literal locations
USING Map
GPR cross-reference
JES step results
Binder attributes
runtime register dump
```

The conclusions therefore do not depend on a single screenshot or return code.

## Final state

```text
Phase 0   PASS
LAB101    PASS
LAB102    PASS
LAB103    PASS
Lab 03    COMPLETE
```
