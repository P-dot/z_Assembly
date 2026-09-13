# Theory — Lab 03 Part 1

## 1. Why LOAD is an addressability lab

A LOAD instruction is not only a data-movement operation. When the source
operand resides in storage, the processor must determine where that storage is.

Part 1 therefore studies two questions at the same time:

1. what value is transferred to a GPR; and
2. how the effective address of the source operand is formed.

## 2. GPR width

z/Architecture general-purpose registers are 64 bits wide.

The instruction families in this first part operate on the low 32-bit half of
the destination GPR. The test therefore validates the low 32 bits and does not
claim that these instructions initialize the high 32 bits.

The full-register behavior is reserved for LAB103.

## 3. Base-displacement addressability

For the original `L` and `LH` forms used here, a storage reference is resolved
using a base register plus a 12-bit unsigned displacement.

```text
effective address = contents(base GPR) + displacement
```

`LARL 12,LAB101` establishes the runtime address in R12.

`USING LAB101,12` tells HLASM that R12 may be used as the assembler's base for
symbolic storage references. `USING` does not load R12.

## 4. Long displacement

`LY` and `LHY` provide long-displacement forms. They continue to use a base
register but provide a 20-bit signed displacement field.

The key distinction is therefore:

```text
L / LH   -> base + 12-bit unsigned displacement
LY / LHY -> base + 20-bit signed displacement
```

Long displacement increases reach. It does not eliminate base-register
addressability.

## 5. Relative addressing

`LRL` and `LHRL` form the operand address relative to the instruction location.

The validated listing makes this visible because the encoded relative fields
match the halfword-scaled distance between each instruction and its literal.

This matters because relative addressing reduces dependence on a dedicated
base register for those operands.

## 6. Register-to-register LOAD

`LR 4,3` does not reference storage. It copies the low 32-bit value from R3 to
R4.

As a result it needs neither a literal nor a base register for an operand
address.

## 7. Literals

Operands such as:

```asm
=F'170'
=H'4095'
```

request assembler-generated constants. HLASM places them in the literal pool
and resolves the referencing instructions to those storage locations.

The listing is therefore essential evidence: it shows both the instruction and
the generated constant.

## 8. AMODE and RMODE

`AMODE` controls the addressing mode in which the program is entered.

`RMODE` controls the residency constraint applied to the bound module.

Phase 0 exposed legacy 24-bit defaults. LAB101 removes that ambiguity with:

```asm
LAB101 AMODE 31
LAB101 RMODE ANY
```

The Binder output proves that these source attributes propagated to the load
module.

## 9. Controlled diagnostic termination

`DC H'0'` defines a halfword of zero data. It is intentionally placed on the
fall-through execution path.

When instruction fetch reaches those bytes, an operation exception occurs and
z/OS reports S0C1. This is intentionally used as a teaching/debugging
instrument so the register state can be captured.

The S0C1 is therefore an expected observation, not the success criterion by
itself. The success criterion is that assembly and binding succeed, the expected
GPR values are present, and the expected diagnostic termination occurs.
