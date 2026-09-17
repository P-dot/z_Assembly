# Theory — Lab 03 Part 3

## Whole-register LOAD

z/Architecture GPRs are 64 bits wide. LAB103 validates LOAD forms that write a
complete 64-bit result rather than only the low 32-bit half.

## Storage source widths

Three source sizes are deliberately used:

```text
DW1 -> 8 bytes
F1  -> 4 bytes
H1  -> 2 bytes
```

`LG` transfers an entire 8-byte field.

`LGF` loads a signed 32-bit fullword and sign-extends it to 64 bits.

`LGH` loads a signed 16-bit halfword and sign-extends it to 64 bits.

## Sign extension

For `F1 DC F'-1'`:

```text
FFFFFFFF
   ->
FFFFFFFF_FFFFFFFF
```

For `H1 DC H'-32768'`:

```text
8000
   ->
FFFFFFFF_FFFF8000
```

The high-order ones preserve the negative signed value.

## Relative-long equivalents

`LGRL`, `LGFRL`, and `LGHRL` obtain the same fields through relative-long
address formation.

The runtime equality:

```text
R2 = R5
R3 = R6
R4 = R7
```

proves that the different addressing mechanisms reach the same source data.

## Immediate values

`LGFI 8,-131072` produces:

```text
FFFFFFFF_FFFE0000
```

`LGHI 9,0` produces:

```text
00000000_00000000
```

No separate storage field is needed for these immediate values.

## DW1 representation

`DW1 DC D'100000000000'` generated:

```text
4A174876E8000000
```

The `D` type is an eight-byte long floating-point constant representation.

The LOAD experiment does not perform floating-point arithmetic. `LG` and
`LGRL` simply transfer the eight bytes into a GPR. Therefore the correct
validation is:

```text
contents(DW1) == R2 == R5
```

not conversion of the decimal source text into a fixed-binary integer pattern.

## Controlled termination

After all tested instructions execute, the program falls through into
`DC H'0'`, intentionally causing S0C1 so `SYSUDUMP` exposes the complete GPR
state.
