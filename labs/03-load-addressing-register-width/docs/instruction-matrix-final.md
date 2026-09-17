# Final LOAD Instruction Matrix

| Instruction | Source | Addressing | Source width | Destination behavior |
|---|---|---|---:|---|
| `L` | storage | base + 12-bit disp | 32 | low 32 bits |
| `LH` | storage | base + 12-bit disp | 16 | sign-extend into low 32 |
| `LR` | GPR | register | 32 | low 32 bits |
| `LY` | storage | base + 20-bit disp | 32 | low 32 bits |
| `LHY` | storage | base + 20-bit disp | 16 | sign-extend into low 32 |
| `LRL` | storage | relative-long | 32 | low 32 bits |
| `LHRL` | storage | relative-long | 16 | sign-extend into low 32 |
| `IILF` | immediate | immediate | 32 | insert low fullword |
| `LHI` | immediate | immediate | 16 | low-half immediate form used in LAB102 |
| `LG` | storage | base-displacement | 64 | full 64-bit GPR |
| `LGF` | storage | base-displacement | 32 | signed 32 -> 64 |
| `LGH` | storage | base-displacement | 16 | signed 16 -> 64 |
| `LGRL` | storage | relative-long | 64 | full 64-bit GPR |
| `LGFRL` | storage | relative-long | 32 | signed 32 -> 64 |
| `LGHRL` | storage | relative-long | 16 | signed 16 -> 64 |
| `LGFI` | immediate | immediate | 32 | signed immediate -> 64 |
| `LGHI` | immediate | immediate | 16 | signed immediate -> 64 |

## Addressability lessons

```text
base-displacement -> requires suitable active addressability
relative-long     -> instruction-relative source address
register form     -> no storage address
immediate form    -> value encoded in instruction
```
