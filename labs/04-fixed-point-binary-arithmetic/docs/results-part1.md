# Results — Lab 04 Part 1 / LAB201

## Status

**PASS**

## Runtime

```text
R2 = 00000000_0000AAAA
R3 = 00000000_00008888
R4 = 00000000_0000AAAA
R5 = 00000000_00008888
```

Validated:

```text
R2 low = R4 low
R3 low = R5 low
```

## HLASM

```text
No Statements Flagged in this Assembly
Return Code 000
```

## Binder

```text
Entry point: LAB201
AMODE: 31
RMODE: ANY
Return Code: 0
```

## Final Source/Object observations

```text
000006 5820 C028       L     2,=F'40960'
00000A 5A20 C02C       A     2,=F'2730'
00000E 1832            LR    3,2
000010 4B30 C030       SH    3,=H'8738'

000014 C049 0000 A000  IILF  4,40960
00001A C249 0000 0AAA  AFI   4,2730
000020 1854            LR    5,4
000022 A75A DDDE       AHI   5,-8738

000026 0000            DC H'0'

000028 0000A000        =F'40960'
00002C 00000AAA        =F'2730'
000030 2222            =H'8738'
```

## Controlled termination

S0C1 occurred only after the arithmetic under test completed and the CPU
reached the deliberate `DC H'0'`.

## Conclusion

LAB201 proves equivalent arithmetic results through two operand-delivery
mechanisms while exposing their different machine-code and memory behavior.
