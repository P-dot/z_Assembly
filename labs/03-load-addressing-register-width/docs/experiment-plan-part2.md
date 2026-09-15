# Experiment Plan — Lab 03 Part 2

## Experiment A — Negative addressability control

### Hypothesis

With no active USING:

- `L` should fail for a symbolic storage literal;
- `LH` should fail;
- `LR` should still assemble;
- `LY` should fail;
- `LHY` should fail;
- HLASM should return RC 8.

### Original secondary hypothesis

The initial plan expected Binder and GO not to execute after assembly RC 8.

### Observed

The primary addressability hypothesis was confirmed.

The secondary toolchain hypothesis was disproved on the local system because
standard ASMACLG continued after RC 8.

That unexpected result is retained as evidence.

## Experiment B — Course mnemonic compatibility

### Hypothesis

The modern course source using `LFI 5,187` would assemble on the local HLASM.

### Observed

It did not.

```text
ASMA057E Undefined operation code - LFI
```

The hypothesis was rejected and the source was adapted.

## Experiment C — Corrected no-base-register implementation

Final operations:

```asm
         LRL   2,=F'170'
         LHRL  3,=H'4095'
         LR    4,3
         IILF  5,187
         LHI   6,2048
```

### Expected GPR values

```text
R2 low = 000000AA
R3 low = 00000FFF
R4 low = 00000FFF
R5 low = 000000BB
R6 low = 00000800
```

### Acceptance criteria

- no base-register setup in source;
- HLASM RC 0000;
- no statements flagged;
- Binder RC 0000;
- LAB102 entry point;
- expected R2-R6 values;
- controlled final S0C1.
