# Results — Lab 03 Part 2

## Negative control

**Result: PASS**

HLASM reported:

```text
ASMA307E No active USING for operand =F'170'
ASMA307E No active USING for operand =H'4095'
ASMA307E No active USING for operand =F'187'
ASMA307E No active USING for operand =H'2048'
```

`LR 4,3` generated object code `1843`.

Assembler result:

```text
4 Statements Flagged
Highest Severity Code = 8
Return Code 008
```

### ASMACLG discovery

Contrary to the initial lab hypothesis, the local standard ASMACLG procedure
continued into Binder and GO after assembly RC 8.

The resulting runtime S0C1 occurred before the intended final diagnostic
termination because unresolved machine-instruction areas were emitted as
zero-filled object bytes.

This is an environment/toolchain result and is deliberately retained.

## Compatibility run

The first corrected version used the newer course mnemonic:

```asm
LFI 5,187
```

HLASM reported:

```text
ASMA057E Undefined operation code - LFI
```

The source was adapted to:

```asm
IILF 5,187
```

## Final corrected run

**Result: PASS**

Final HLASM summary:

```text
No Statements Flagged in this Assembly
Return Code 000
```

Runtime GPR evidence:

```text
R2 = 00000000_000000AA
R3 = 00000000_00000FFF
R4 = 00000000_00000FFF
R5 = 00000000_000000BB
R6 = 00000000_00000800
```

Binder evidence:

```text
Entry point = LAB102
AMODE = 31
Binder Return Code = 0
```

`RMODE ANY` is declared in the source and was also visible in the preceding
LAB102 Binder save-module evidence before the one-line LFI/IILF correction.

Execution ended with the expected controlled S0C1 after the tested operations
completed.

## Assessment

Part 2 validates all three engineering states:

```text
invalid base-dependent design
        ->
diagnosed addressability failure
        ->
modern mnemonic compatibility failure
        ->
local compatible no-base implementation
        ->
clean assembly and expected runtime state
```

**Part 2 closure: PASS.**
