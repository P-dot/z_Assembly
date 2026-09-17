# Experiment Plan — Lab 03 Part 3

## Hypothesis

The storage, relative-long and immediate LOAD forms will produce these complete
64-bit results:

| GPR | Expected |
|---|---|
| R2 | same eight bytes as DW1 |
| R3 | `FFFFFFFF_FFFFFFFF` |
| R4 | `FFFFFFFF_FFFF8000` |
| R5 | same eight bytes as DW1 |
| R6 | `FFFFFFFF_FFFFFFFF` |
| R7 | `FFFFFFFF_FFFF8000` |
| R8 | `FFFFFFFF_FFFE0000` |
| R9 | `00000000_00000000` |

Additional expected relationships:

```text
R2 = R5
R3 = R6
R4 = R7
```

## Toolchain expectations

```text
HLASM RC = 0000
Binder RC = 0000
AMODE = 31
RMODE = ANY
Entry point = LAB103
Execution = controlled S0C1
```

## Evidence required

- complete source;
- ASMACLG step results;
- full R2-R9 register display;
- Source/Object listing for storage LOADs;
- Source/Object listing for relative/immediate LOADs;
- generated program data;
- USING Map / GPR cross-reference;
- HLASM RC 000;
- Binder AMODE/RMODE and entry point.
