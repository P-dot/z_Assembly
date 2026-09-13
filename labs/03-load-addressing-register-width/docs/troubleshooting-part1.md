# Troubleshooting Notes — Lab 03 Part 1

## S0C1 is expected

The program deliberately falls through into `DC H'0'`.

Do not classify the job as failed merely because SDSF reports:

```text
SYSTEM COMPLETION CODE=0C1
```

The correct evaluation separates the steps:

```text
Assembler -> RC 0000
Binder    -> RC 0000
Execution -> expected S0C1
```

## Do not infer full 64-bit initialization

The Part 1 instructions under test modify the low 32-bit portion according to
their architecture.

The fact that the captured high halves were zero in these runs must not be used
to claim that `L`, `LH`, `LR`, `LY`, `LHY`, `LRL` or `LHRL` initialized the
entire 64-bit GPR.

That behavior is a LAB103 topic.

## Long displacement still depends on a base

`LY` and `LHY` extend displacement range. They do not remove base-register
addressability.

This distinction becomes the central negative test in LAB102.

## `USING` does not load R12

If the program contains a `USING` but does not place the expected address in
the selected GPR at runtime, the generated base-displacement instructions may
reference the wrong storage.

`LARL` and `USING` solve different parts of the problem.

## Large SYSUDUMP output

A complete SYSUDUMP is intentionally not published as the primary evidence.
The curated screenshots preserve the specific facts required to validate the
experiment without flooding the repository with repetitive dump pages.
