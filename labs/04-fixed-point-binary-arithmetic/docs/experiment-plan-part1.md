# Experiment Plan — Lab 04 Part 1

## Hypothesis

Storage and immediate forms will produce identical low-word results.

```text
R2 low = 0000AAAA
R3 low = 00008888
R4 low = 0000AAAA
R5 low = 00008888
```

Expected relationships:

```text
R2 low = R4 low
R3 low = R5 low
```

## Toolchain expectations

```text
HLASM RC = 000
Binder RC = 0
Entry = LAB201
AMODE = 31
RMODE = ANY
Execution = controlled S0C1
```

## Object-code expectations

The final source/object listing must expose:

- storage-form base/displacement object code;
- Part 1 literals;
- immediate values physically encoded in IILF/AFI/AHI;
- `DDDE` as the two's-complement representation of `-8738`;
- controlled `X'0000'` termination after all tested arithmetic.

## Acceptance criteria

The milestone passes only if assembler, Binder, object-code, register and
controlled-abend evidence all agree with the hypothesis.
