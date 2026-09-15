# Troubleshooting — Lab 03 Part 2

## ASMA307E No active USING

Cause in this experiment:

```text
symbolic storage operand
+
base-displacement instruction
+
no active USING
```

Do not solve this automatically by adding a base register. The purpose of
LAB102 is to evaluate relative and immediate alternatives.

## RC 8 did not stop ASMACLG

The negative run demonstrated that the standard local ASMACLG procedure can
continue after HLASM RC 8.

That means a negative assembler test should not assume that RC 8 alone prevents
Binder or execution under every PROC.

For a future assembler-only negative test, `ASMAC` is a cleaner harness when
link/run are intentionally unwanted.

## ASMA057E Undefined operation code - LFI

The course mnemonic `LFI` is not recognized by the HLASM level in this ADCD
environment.

For this low-fullword immediate exercise, the local compatible implementation
uses:

```asm
IILF 5,187
```

Functional validation:

```text
HLASM RC 000
R5 low = 000000BB
```

## Distinguish the two S0C1 cases

Negative L102NEG run:

```text
assembly RC 8
-> incomplete/zero-filled object fields
-> ASMACLG continued
-> runtime operation exception
```

Final LAB102 run:

```text
assembly RC 0
-> all tested instructions execute
-> deliberate DC H'0'
-> controlled S0C1
```

These are different failure paths and should never be documented as the same
event.
