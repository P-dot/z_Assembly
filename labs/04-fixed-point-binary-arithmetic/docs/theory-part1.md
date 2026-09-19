# Theory — Lab 04 Part 1 / LAB201

## Fixed-point arithmetic path

LAB201 compares two operand-delivery models for the same arithmetic.

### Storage operands

```text
instruction
  -> base/displacement
  -> effective address
  -> memory operand
  -> ALU
  -> GPR result
```

### Immediate operands

```text
instruction bytes contain operand
  -> ALU
  -> GPR result
```

## Storage calculation

```text
40960 = X'0000A000'
2730  = X'00000AAA'

0000A000 + 00000AAA = 0000AAAA
```

`LR 3,2` copies the low 32-bit result to R3.

The halfword `8738 = X'2222'` is a signed 16-bit storage operand used by `SH`.

```text
0000AAAA - 00002222 = 00008888
```

## Immediate calculation

`IILF` places `X'0000A000'` directly in the low fullword of R4.

`AFI` contains the 32-bit immediate `X'00000AAA'` in its six-byte machine
instruction.

`AHI 5,-8738` encodes the signed 16-bit immediate as `X'DDDE'`.

```text
+8738 = 2222
invert = DDDD
+1     = DDDE
```

The signed 16-bit value is conceptually sign-extended for 32-bit arithmetic:

```text
DDDE -> FFFFDDDE
```

Then:

```text
0000AAAA
+FFFFDDDE
---------
00008888   (low 32-bit result)
```

## Validated object bytes

```text
IILF 4,40960 -> C049 0000 A000
AFI  4,2730  -> C249 0000 0AAA
LR   5,4     -> 1854
AHI  5,-8738 -> A75A DDDE
```

The object code makes the data path directly visible: the immediate values are
encoded inside the instructions rather than stored in the literal pool.
