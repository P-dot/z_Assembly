# Technical Notes — Lab 01

## R15 is deliberately populated by the program

The return code does not come from `DC` automatically. The program explicitly creates the relationship:

```asm
         LH    3,INT1
         LR    15,3
         BR    14
```

`LH` obtains the value from storage, `LR` copies it to R15, and `BR 14` returns control to the caller. Without the `LR 15,3` instruction, changing `INT1` would not by itself make the same value appear as the program's return code.

## `USING` versus machine instructions

`USING DEMO1,12` is processed by the Assembler. It does not generate a CPU instruction. Its purpose is to tell the Assembler which general register can be used to resolve base-displacement addresses.

By contrast, `LARL`, `LH`, `LR`, and `BR` result in executable machine instructions.

## Why the assembly listing matters

The listing bridges symbolic Assembler and machine execution. It shows:

- source statement;
- location counter;
- generated object code;
- symbol information;
- literal/symbol references;
- USING map;
- general-register cross-reference;
- diagnostics and assembler return code.

For this lab, the listing proves that `INT1 DC H'10'` generated `000A`, `LR 15,3` generated `18F3`, and `BR 14` generated `07FE`.

## Why `CC 0010` is a successful lab result

The assemble and link steps both completed with `CC 0000`. The GO step ended with `CC 0010` because the program intentionally placed decimal 10 in R15. Therefore `0010` is the expected program result, not a compiler or binder failure.

## 12-bit return-code experiment

The boundary experiment was designed to make the low-order 12-bit behavior observable:

```text
4095 = X'0FFF' -> X'FFF' -> 4095
4096 = X'1000' -> X'000' -> 0
4097 = X'1001' -> X'001' -> 1
```

The result is especially useful because the same instructions are executed in all three cases. Only the halfword constant changes.

## Scope

This lab intentionally does not introduce a standard enterprise Assembler save-area prolog. Its scope is limited to the concepts required for the first machine-instruction exercise: addressability, data movement, linking, execution, and return-code behavior. Standard linkage conventions can be introduced in a later lab without obscuring these fundamentals.
