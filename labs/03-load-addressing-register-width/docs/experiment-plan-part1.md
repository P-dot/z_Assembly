# Experiment Plan — Lab 03 Part 1

## Phase 0 hypothesis

The standard local `ASMACLG` path should:

- assemble `HARN03` with RC 0000;
- bind it with RC 0000;
- execute it;
- produce an intentional S0C1 at `DC H'0'`;
- expose the loaded GPR values through z/OS diagnostic output.

Expected low halves:

```text
R2 = 000000AA
R3 = 00000FFF
R4 = 00000FFF
```

## LAB101 hypothesis

The three LOAD storage-addressing families should place distinct, predictable
values in R2 through R8.

| GPR | Instruction family | Expected |
|---|---|---:|
| R2 | original fullword | `000000AA` |
| R3 | original halfword | `00000FFF` |
| R4 | register-to-register | `00000FFF` |
| R5 | long-displacement fullword | `000000BB` |
| R6 | long-displacement halfword | `00000800` |
| R7 | relative-long fullword | `000FA000` |
| R8 | relative-long halfword | `000000FF` |

Additional hypotheses:

- HLASM RC = 0000.
- Binder RC = 0000.
- `USING` Map identifies R12.
- Binder preserves `AMODE 31`.
- Binder preserves `RMODE ANY`.
- execution reaches the intentional S0C1.
- the literal pool contains all requested constants.
- relative-long encoded fields reconcile with listing locations.

## Acceptance criteria

Part 1 is accepted only when all expected values and toolchain states are
supported by captured evidence.
