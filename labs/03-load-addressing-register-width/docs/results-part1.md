# Results — Lab 03 Part 1

## Phase 0

**Status: PASS**

The harness established that the local z/OS ADCD environment can use standard
`ASMACLG` plus `SYSUDUMP` as the execution/observation mechanism for the
exercise.

Observed:

```text
HLASM       RC=0000
Binder      RC=0000
Execution   S0C1 (expected)
R2 low      000000AA
R3 low      00000FFF
R4 low      00000FFF
```

The Phase 0 Binder output also exposed a legacy `RMODE=24` baseline when no
explicit attributes were supplied. This was treated as a platform observation,
not copied into the final LAB101 design.

## LAB101

**Status: PASS**

Observed GPRs:

```text
R2 = 00000000_000000AA
R3 = 00000000_00000FFF
R4 = 00000000_00000FFF
R5 = 00000000_000000BB
R6 = 00000000_00000800
R7 = 00000000_000FA000
R8 = 00000000_000000FF
```

Observed toolchain:

```text
HLASM Return Code = 000
Binder Return Code = 0
AMODE = 31
RMODE = ANY
Entry point = LAB101
Execution = S0C1 (intentional)
```

The HLASM listing showed no flagged statements.

## Source/Object observations

Key instruction/literal relationships:

```text
000006  5820 C030      L    2,=F'170'
00000A  4830 C03C      LH   3,=H'4095'
00000E  1843           LR   4,3
```

Literal pool:

```text
000030  000000AA   =F'170'
000034  000000BB   =F'187'
000038  000FA000   =F'1024000'
00003C  0FFF       =H'4095'
00003E  0800       =H'2048'
000040  00FF       =H'255'
```

Relative-long checks:

```text
LRL:
X'38' - X'1C' = 28 bytes
28 / 2 = 14 = X'0000000E'

LHRL:
X'40' - X'22' = 30 bytes
30 / 2 = 15 = X'0000000F'
```

These values match the encoded relative fields shown in the listing.

## Final Part 1 assessment

The experiment validates:

- local ASMACLG execution;
- diagnostic capture through controlled S0C1;
- base-displacement addressability;
- long displacement;
- instruction-relative LOAD;
- register-to-register LOAD;
- literal generation;
- USING Map interpretation;
- GPR cross-reference;
- explicit Binder AMODE/RMODE propagation.

**Part 1 closure: PASS.**

**Overall Lab 03: IN PROGRESS.**
