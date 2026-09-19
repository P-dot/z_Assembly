# Troubleshooting — Lab 04 Part 1

## LFI compatibility

The training material uses the newer `LFI` mnemonic for immediate low-fullword
loading.

This local HLASM level previously rejected `LFI` with `ASMA057E Undefined
operation code` during Lab 03.

The validated local adaptation is:

```asm
IILF 4,40960
```

LAB201 assembled cleanly with this adaptation and produced the expected R4
value.

## Why AHI is used for subtraction

A separate `SHI` mnemonic is not required here.

```text
x - 8738 == x + (-8738)
```

`AHI 5,-8738` uses the signed 16-bit two's-complement immediate `X'DDDE'`,
which was confirmed directly in the HLASM Source/Object listing.

## Literal displacements changed

After adding Part 2, the Part 1 literal pool moved:

```text
=F'40960' -> X'28'
=F'2730'  -> X'2C'
=H'8738'  -> X'30'
```

Therefore the storage instruction displacements also changed. This is expected:
the instruction semantics did not change; the distance to the literal pool did.

## S0C1

The S0C1 is intentional. It is produced by the final `DC H'0'` after the tested
arithmetic completes and is used to obtain SYSUDUMP register evidence.
