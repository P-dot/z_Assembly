# Lab 01 — DEMO1: Assembly, Linking, Execution, and the R15 Return Code

## 1. Objective

Build and execute a minimal z/Architecture Assembler program on the local zPDT/ADCD z/OS system and prove, with system evidence, the complete path from source code to a z/OS return code.

The lab validates all of the following on the real system:

- availability of the standard `ASMACLG` cataloged procedure;
- creation of a dedicated PDS for Assembler JCL;
- successful assembly with High Level Assembler;
- successful binder/link-edit processing;
- execution of the resulting load module;
- use of `LARL` and `USING` to establish addressability;
- loading a signed halfword from storage with `LH`;
- copying a register value into register 15 with `LR`;
- returning to the caller with `BR 14`;
- relationship between the low-order 12 bits of R15 and the z/OS step return code;
- inspection of generated object code, symbol information, the USING map, and binder output in SDSF.

This is intentionally more than a "first program" exercise: the goal is to connect the Assembler source, the generated machine code, register behavior, and the return code reported by z/OS.

---

## 2. Environment

| Component | Value |
|---|---|
| Platform | IBM z/Architecture under zPDT |
| Operating system | z/OS V1R11 ADCD laboratory system |
| Interactive environment | TSO / ISPF |
| Job/output inspection | SDSF |
| Assembler | IBM High Level Assembler |
| Assemble/link/go procedure | `ASMACLG` |
| User JCL library | `IBMUSER.ASM.JCL` |
| Library organization | PDS (`DSORG=PO`) |
| Record format | `FB` |
| Logical record length | `80` |
| Allocation | `TRK(1,1)` |
| Directory blocks | `10` |

The system library inspection confirmed that `ASMAC`, `ASMACG`, `ASMACL`, and `ASMACLG` are available in `SYS1.PROCLIB`. Therefore, no IBM-course-specific `HLLASMA` procedure and no locally invented replacement procedure were required.

Evidence: [ASMACLG available](evidence/01-sys1-proclib-asmaclg-available.png) and [PDS attributes](evidence/02-ibmuser-asm-jcl-dataset-attributes.png).

---

## 3. Why `ASMACLG` is used

`ASMACLG` provides the classic three-stage workflow required by this exercise:

```text
Assembler source
      |
      v
   Assemble
      |
      v
 Object module
      |
      v
 Binder / link-edit
      |
      v
  Load module
      |
      v
    Execute
```

The lab feeds the source program to the Assembler through the procedure override:

```jcl
//ASM      EXEC ASMACLG
//C.SYSIN  DD *
```

Using the standard system procedure is important because the exercise then validates the actual toolchain already present in the ADCD system rather than recreating an artificial course environment.

---

## 4. Baseline JCL and source

The reproducible baseline is stored in [`jcl/DEMO1.jcl`](jcl/DEMO1.jcl).

```jcl
//ASMDEMO  JOB 1,'ASM LAB01',
//             CLASS=A,MSGCLASS=X,
//             MSGLEVEL=(1,1),NOTIFY=&SYSUID
//*
//* ================================================================
//* LAB 01 - Z/ARCHITECTURE ASSEMBLER DEMO1
//* ASSEMBLE -> LINK -> EXECUTE
//* ================================================================
//ASM      EXEC ASMACLG
//C.SYSIN DD *
DEMO1    CSECT
         LARL  12,DEMO1
         USING DEMO1,12

         LH    3,INT1
         LR    15,3
         BR    14

INT1     DC    H'10'

         END   DEMO1
/*
```

Evidence: [baseline member in ISPF Edit](evidence/03-demo1-source-baseline-h10.png).

---

## 5. Source explanation

### `DEMO1 CSECT`

```asm
DEMO1    CSECT
```

Defines the program's control section. `DEMO1` becomes the symbolic name associated with the start of this control section.

### `LARL 12,DEMO1`

```asm
         LARL  12,DEMO1
```

Loads the address of `DEMO1` into general register 12 using relative addressing.

At this point R12 contains a usable address for the program's control section.

### `USING DEMO1,12`

```asm
         USING DEMO1,12
```

`USING` is an Assembler instruction, not a CPU instruction. It tells the Assembler that R12 can be treated as a base register for addresses in the range beginning at `DEMO1`.

The assembler listing later confirms this relationship in the USING map.

### `LH 3,INT1`

```asm
         LH    3,INT1
```

Loads the signed halfword at `INT1` into the low-order part of R3. In the baseline test:

```asm
INT1     DC    H'10'
```

The halfword contains decimal `10`, represented as hexadecimal `000A`.

### `LR 15,3`

```asm
         LR    15,3
```

Copies the low 32-bit value in R3 to the low 32-bit portion of R15. This is the critical instruction that deliberately places the program result in register 15.

There is nothing inherently special about `INT1` as a return code. The connection exists because this program explicitly moves its value into R15.

### `BR 14`

```asm
         BR    14
```

Returns control to the caller using the return address in R14. When control is returned, z/OS/JES processing observes the program's return code from the low-order return-code field derived from R15.

### `INT1 DC H'10'`

```asm
INT1     DC    H'10'
```

Defines a signed binary halfword containing decimal `10`. The assembly listing proves that the generated storage bytes are `000A`.

---

## 6. Baseline execution: decimal 10

The first run used:

```asm
INT1     DC    H'10'
```

The data flow is:

```text
INT1 = H'10'
      |
      | LH 3,INT1
      v
R3 = 10
      |
      | LR 15,3
      v
R15 = 10
      |
      | BR 14
      v
return to caller
      |
      v
step return code = 0010
```

### Observed results

| Stage | Observed result | Meaning |
|---|---:|---|
| Assembly | `CC 0000` | Source assembled successfully |
| Link-edit / Binder | `CC 0000` | Load module created successfully |
| GO / execution | `CC 0010` | Program returned decimal 10 |

Evidence: [ASMACLG execution log](evidence/05-asmaclg-step-summary-part1.png) and [GO condition code 0010](evidence/06-asmaclg-go-rc0010.png).

This is the expected result. `CC 0010` is not an assembly or binder failure; it is the value deliberately returned by the program.

---

## 7. Assembly listing and generated machine code

The High Level Assembler listing was inspected in SDSF rather than treating successful execution as a black box.

The listing shows the source statement beside the generated object code. Among the relevant values visible in the evidence are:

| Source statement | Generated/observed object representation |
|---|---|
| `LARL 12,DEMO1` | generated instruction visible in listing |
| `LH 3,INT1` | generated RX-format instruction using the established base |
| `LR 15,3` | `18F3` |
| `BR 14` | `07FE` |
| `INT1 DC H'10'` | `000A` |

Evidence: [assembly listing and object code](evidence/08-assembly-listing-object-code.png).

The most important point is not memorizing the opcodes. The listing demonstrates that the Assembler transformed the symbolic source into actual machine instructions and storage constants.

---

## 8. Verifying the base register

The assembler's USING map confirms that the `USING DEMO1,12` statement established R12 as the base register for the control section.

This directly connects the source statements:

```asm
         LARL  12,DEMO1
         USING DEMO1,12
```

with the addressability information used by the Assembler when resolving the storage operand `INT1`.

Evidence: [USING map and register cross-reference](evidence/09-using-map-register-cross-reference.png).

The same listing reports that no statements were flagged in the assembly and that the assembler return code was zero.

Evidence: [assembler summary](evidence/10-assembler-summary-rc0000.png).

---

## 9. Binder validation

The Binder processed the object module successfully and created the executable module used by the GO step. The captured output includes:

- module map;
- section information for `DEMO1`;
- binder processing options;
- save/module attributes;
- entry-point information;
- message summary with no severe/error/warning messages.

Evidence:

- [Binder module map](evidence/11-binder-module-map.png)
- [Binder processing options](evidence/12-binder-processing-options.png)
- [Binder save/module information](evidence/13-binder-save-operation-summary.png)
- [Entry point and message summary](evidence/14-binder-entry-point-message-summary.png)
- [End of Binder message summary](evidence/15-binder-message-summary-end.png)

This proves that the lab completed the full assemble → link → execute lifecycle, not just assembly.

---

## 10. R15 return-code boundary experiment

The baseline run explains *how* a value reaches R15. The second part of the lab demonstrates *how the value is interpreted as a z/OS return code*.

Only the constant was changed between runs:

```asm
INT1     DC    H'n'
```

The rest of the program remained the same.

### Why 4095, 4096, and 4097?

A 12-bit unsigned value has the range:

```text
0x000 = 0
...
0xFFF = 4095
```

The observed return-code behavior uses the low-order 12 bits. Twelve bits correspond to three hexadecimal digits.

### Test 1 — 4095

```text
4095 decimal = X'0FFF'
low 12 bits  = X'FFF'
return code  = 4095
```

The source was changed to:

```asm
INT1     DC    H'4095'
```

Evidence: [source with H'4095'](evidence/16-demo1-source-h4095.png), [MAXCC=4095](evidence/17-maxcc4095-message.png), and [GO condition code 4095](evidence/18-go-cond-code4095.png).

### Test 2 — 4096

```text
4096 decimal = X'1000'
low 12 bits  = X'000'
return code  = 0
```

Observed:

```text
COND CODE 0000
```

Evidence: [4096 experiment — GO CC 0000](evidence/19-go-cond-code0000-h4096.png).

### Test 3 — 4097

```text
4097 decimal = X'1001'
low 12 bits  = X'001'
return code  = 1
```

Observed:

```text
COND CODE 0001
```

Evidence: [4097 experiment — GO CC 0001](evidence/20-go-cond-code0001-h4097.png).

### Result table

| `INT1` decimal | Hexadecimal | Low-order 12 bits | Observed return code |
|---:|---:|---:|---:|
| 10 | `00A` | `00A` | `0010` |
| 4095 | `0FFF` | `FFF` | `4095` |
| 4096 | `1000` | `000` | `0000` |
| 4097 | `1001` | `001` | `0001` |

The three boundary tests make the 12-bit behavior visible rather than merely describing it theoretically.

---

## 11. What the lab proves

The completed lab provides direct system evidence for the following chain:

```text
DC defines a binary value in storage
                |
                v
LH loads that value into R3
                |
                v
LR copies the value to R15
                |
                v
BR 14 returns to the caller
                |
                v
z/OS reports the return code derived from R15
```

It also validates the wider program-production chain:

```text
Source code
   -> High Level Assembler
      -> object module
         -> Binder
            -> load module
               -> execution
                  -> return code
```

This connects several concepts that are often learned separately: storage constants, registers, addressability, machine instructions, assembler instructions, object code, linking, execution, and return-code handling.

---

## 12. Final result

**Lab status: COMPLETE**

Validated outcomes:

- ✅ `ASMACLG` found in the system procedure library
- ✅ `IBMUSER.ASM.JCL` created and verified
- ✅ baseline Assembler source accepted
- ✅ High Level Assembler `RC=0000`
- ✅ Binder/link-edit `RC=0000`
- ✅ executable module successfully run
- ✅ baseline program returned `RC=0010`
- ✅ generated object code inspected
- ✅ R12 base-register relationship verified in USING map
- ✅ assembler diagnostics clean
- ✅ Binder output and entry point inspected
- ✅ `4095 -> RC 4095` validated
- ✅ `4096 -> RC 0000` validated
- ✅ `4097 -> RC 0001` validated
- ✅ evidence retained as screenshots

---

## 13. Evidence

All captured screenshots are preserved under [`evidence/`](evidence/). See [`docs/evidence-index.md`](docs/evidence-index.md) for a description of every image.

---

## 14. Reference

Primary exercise reference:

- IBM Training, **z/Architecture Assembler. Part 2: Machine instructions**, course code **EZ341G**, Exercise Guide, August 2023 edition — Exercise 1, DEMO1 program.

The IBM material is used as a learning reference. The lab itself was executed independently on the local zPDT/ADCD z/OS environment and does not depend on IBM's hosted course lab, course datasets, credentials, or custom lab procedures.

