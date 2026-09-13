# Instruction Matrix — Lab 03 Part 1

| Mnemonic | Source | Addressing | Operand size | Destination effect in this lab |
|---|---|---|---|---|
| `L` | storage | base + 12-bit unsigned displacement | fullword | low 32 bits |
| `LH` | storage | base + 12-bit unsigned displacement | halfword | sign-extended into low 32 bits |
| `LR` | GPR | register-to-register | 32 bits | low 32 bits |
| `LY` | storage | base + 20-bit signed displacement | fullword | low 32 bits |
| `LHY` | storage | base + 20-bit signed displacement | halfword | sign-extended into low 32 bits |
| `LRL` | storage | relative-long | fullword | low 32 bits |
| `LHRL` | storage | relative-long | halfword | sign-extended into low 32 bits |

## Related assembler instructions

| Statement | Runtime CPU instruction? | Purpose |
|---|---|---|
| `CSECT` | No | defines a control section |
| `AMODE 31` | No | declares entry addressing mode |
| `RMODE ANY` | No | declares residency constraint |
| `USING LAB101,12` | No | declares addressability to HLASM |
| `DC H'0'` | No | defines data; deliberately reached as invalid instruction bytes |

## Runtime setup

`LARL 12,LAB101` **is** a machine instruction and physically loads the
runtime address of LAB101 into R12.
