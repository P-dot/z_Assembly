# Instruction Matrix — Lab 04 Part 1

| Instruction | Form | Operand source | Width | Validated result |
|---|---|---|---:|---|
| `L` | RX | storage literal | 32 | loads `0000A000` into R2 low |
| `A` | RX | storage literal | 32 | R2 low becomes `0000AAAA` |
| `LR` | RR | register | 32 | R2->R3 and R4->R5 |
| `SH` | RX | signed storage halfword | 16->32 | R3 low becomes `00008888` |
| `IILF` | RIL | immediate | 32 | inserts `0000A000` into R4 low |
| `AFI` | RIL | signed immediate | 32 | R4 low becomes `0000AAAA` |
| `AHI` | RI | signed immediate | 16->32 | R5 low becomes `00008888` |

## Operand-flow distinction

```text
RX storage arithmetic:
instruction -> address formation -> memory fetch -> ALU

Immediate arithmetic:
instruction bits -> ALU
```
