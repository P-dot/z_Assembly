# z_Assembly — Ecosystem Integration

## Purpose

This document defines the role of the `z_Assembly` repository within the broader z/OS Engineering Laboratory.

The repository is the low-level programming and z/Architecture learning layer of the ecosystem. Its current validated scope covers High Level Assembler, assemble/link/execute workflows, register behavior, addressability, storage definition, data representation, alignment, Binder output, return-code behavior, and interpretation of HLASM listings.

The document distinguishes validated capabilities from future system-programming targets.

Master architecture:

https://github.com/P-dot/zos-adcd-hercules-engineering-lab

---

## 1. Position in the ecosystem

The current learning path is:

```text
MVS_TSO_ISPF
      |
      v
   JCL_LABS
      |
      v
 z_Assembly
      |
      +--> HLASM
      +--> object code
      +--> Binder
      +--> load module
      +--> execution
      +--> registers
      +--> addressability
      +--> storage representation
      |
      +--> future system-programming concepts
```

This repository provides the low-level foundation beneath higher-level application languages.

---

## 2. Repository responsibility

The `z_Assembly` repository currently owns practical work around:

- IBM High Level Assembler;
- z/Architecture register concepts;
- addressability;
- `CSECT`;
- `LARL`;
- `USING`;
- machine instructions;
- assembler directives;
- `DC`;
- `DS`;
- halfword/fullword/doubleword data;
- signed binary representation;
- two's complement;
- EBCDIC constants;
- hexadecimal constants;
- bit strings;
- duplication factors;
- explicit lengths;
- truncation and padding;
- storage alignment;
- object-code inspection;
- HLASM Source/Object listings;
- Binder output;
- entry-point inspection;
- register 15 return-code behavior;
- `BR 14`;
- execution evidence;
- security/publication review.

---

## 3. What this repository does not own

### JCL

General JOB/EXEC/DD syntax and batch-control concepts belong to:

```text
JCL_LABS
```

Assembler labs contain JCL only where required to invoke HLASM, Binder and execution.

### COBOL

COBOL language fundamentals belong to:

```text
COBOL
```

### PL/I

PL/I language fundamentals belong to:

```text
PL-I
```

### CICS

CICS transaction processing and runtime-resource management belong to:

```text
CICS
```

### Db2

SQL and relational data belong to:

```text
DB2-
```

### RACF

Security administration belongs to:

```text
mainframe-racf-security-evidence
```

### Core system engineering

JES2, SMF, WLM, storage, recovery, dumps, system initialization and system-level operations belong to:

```text
zos-adcd-hercules-engineering-lab
```

Assembler may later integrate with low-level system concepts, but should not duplicate the central system-engineering track.

---

## 4. Upstream dependencies

The current validated Assembler work depends on:

- z/OS;
- TSO/E;
- ISPF;
- JES2;
- SDSF;
- JCL;
- High Level Assembler;
- standard `ASMAC` and `ASMACLG` procedures;
- Binder/link-edit services;
- load-module execution support;
- source and JCL libraries.

Conceptually:

```text
TSO/ISPF
   |
   v
Assembler source
   |
   v
JCL
   |
   v
HLASM
   |
   +--> listing
   +--> object module
   |
   v
Binder
   |
   v
load module
   |
   v
execution
   |
   v
return code / SDSF evidence
```

---

## 5. Current repository structure

The repository currently contains:

```text
labs/
  01-demo1-r15-return-code/
  02-defining-storage/
```

Both labs are complete.

The repository preserves:

- reproducible JCL;
- technical notes;
- results;
- evidence indexes;
- screenshots;
- security reviews;
- Git Bash commands.

---

## 6. Lab 01 — DEMO1: R15 Return Code

Lab 01 validates the complete program-production chain:

```text
Assembler source
      |
      v
     HLASM
      |
      v
 object module
      |
      v
    Binder
      |
      v
 load module
      |
      v
  execution
```

The lab then connects source-level behavior to register state and the z/OS return code.

---

## 7. Lab 01 — validated instruction path

The key source path is:

```text
LARL 12,DEMO1
USING DEMO1,12
LH    3,INT1
LR    15,3
BR    14
```

This establishes:

- R12 as the addressability base;
- loading of a signed halfword into R3;
- copying the result to R15;
- return via R14;
- propagation of the program result into the observed step return code.

---

## 8. CSECT role

The program begins with a control section:

```text
DEMO1 CSECT
```

This establishes the program section used by the Assembler and Binder.

The current repository validates `CSECT` as part of a real executable program rather than as isolated syntax.

---

## 9. Addressability

The pair:

```text
LARL 12,DEMO1
USING DEMO1,12
```

demonstrates a central Assembler concept.

`LARL` affects runtime register state.

`USING` informs the assembler about addressability.

These are different concepts:

```text
runtime instruction
      !=
assembler directive
```

The HLASM USING map provides evidence that R12 was used as the base register.

---

## 10. Machine instructions vs assembler instructions

The repository should preserve the distinction between:

- CPU instructions;
- assembler directives;
- data-definition statements.

Example:

```text
LARL   machine instruction
LH     machine instruction
LR     machine instruction
BR     machine instruction

USING  assembler directive
DC     storage-definition directive
```

This distinction becomes increasingly important as future labs become more advanced.

---

## 11. R15 return-code path

The validated path is:

```text
storage constant
      |
      v
     LH
      |
      v
     R3
      |
      v
     LR
      |
      v
     R15
      |
      v
    BR 14
      |
      v
z/OS step return code
```

The lab proves this with real system execution.

---

## 12. Return-code boundary experiment

The lab validates multiple values:

```text
10   -> RC 0010
4095 -> RC 4095
4096 -> RC 0000
4097 -> RC 0001
```

This makes visible the low-order return-code behavior associated with R15.

The purpose is not merely to memorize numbers.

The experiment demonstrates how register contents map into the step result reported by z/OS.

---

## 13. HLASM listing as evidence

The assembly listing is treated as a technical artifact, not just a success report.

The repository inspects:

- generated object code;
- symbols;
- storage bytes;
- location values;
- USING map;
- register cross-reference;
- assembler summary.

This is central to the role of the repository.

---

## 14. Binder validation

Lab 01 also inspects Binder output.

The repository therefore validates more than assembly:

```text
HLASM
  |
  v
object
  |
  v
Binder
  |
  v
load module
```

Captured Binder evidence includes:

- module map;
- processing options;
- save information;
- entry point;
- message summary.

---

## 15. Lab 02 — Defining Storage

Lab 02 shifts focus from executable control flow to representation in storage.

It uses `ASMAC` because no link or execution step is required.

The validated path is:

```text
Assembler source
      |
      v
     HLASM
      |
      +--> locations
      +--> alignment
      +--> object bytes
      +--> source/object listing
```

---

## 16. Signed binary constants

Lab 02 validates:

- halfword;
- fullword;
- doubleword;
- positive values;
- negative values;
- two's-complement representation.

Examples include:

```text
H'-1'
F'-1'
FD'-4095'
```

The generated bytes are verified directly in the HLASM listing.

---

## 17. Data width

The lab makes storage size explicit:

```text
H  -> 16-bit signed integer
F  -> 32-bit signed integer
FD -> 64-bit signed integer
```

The repository should continue relating source notation to actual bytes.

---

## 18. Automatic alignment

HLASM alignment behavior is directly observed.

Examples include:

```text
halfword sequence
      |
      v
location not suitable for fullword
      |
      v
assembler inserts alignment
```

and similar behavior before doublewords.

This is a key low-level concept.

---

## 19. Character representation

Lab 02 validates EBCDIC character constants.

The repository demonstrates:

- raw EBCDIC bytes;
- explicit character lengths;
- padding;
- truncation.

Example relationship:

```text
character source
      |
      v
EBCDIC bytes
```

---

## 20. Explicit length

The repository validates that explicit length affects storage.

For example:

```text
CL10
```

can produce padding.

A shorter requested length can produce truncation.

The listing is used to prove the result.

---

## 21. Duplication factors

The lab distinguishes:

```text
8C'*'
```

from:

```text
C'********'
```

and from:

```text
3CL2'*'
```

These may produce similar or related storage patterns while expressing different source semantics.

---

## 22. Type vs bit pattern

A major validated lesson is:

> Equal object bytes do not necessarily mean equal data type or equal alignment semantics.

The repository demonstrates this by comparing differently typed fields with equivalent bit patterns.

This is important for low-level systems work.

---

## 23. Hexadecimal and bit strings

Lab 02 validates equivalence between:

```text
X'1A2B'
```

and the equivalent binary bit string.

This directly connects:

```text
binary representation
      |
      v
hexadecimal notation
      |
      v
object bytes
```

---

## 24. Explicit alignment with DS 0F

The lab validates:

```text
DS 0F
```

as an alignment request.

The zero duplication factor means no fullword data field is created.

Instead, the location counter advances to the required boundary.

This distinction is documented from the actual listing.

---

## 25. Validated capability map

The repository currently demonstrates:

```text
Assembler source
      |
      +--> CSECT
      +--> machine instructions
      +--> assembler directives
      +--> storage definitions
      |
      v
HLASM
      |
      +--> object bytes
      +--> location counter
      +--> alignment
      +--> symbols
      +--> USING map
      +--> diagnostics
      |
      +--> optional object module
                |
                v
              Binder
                |
                v
           load module
                |
                v
            execution
                |
                v
          R15 / return code
```

---

## 26. Inputs consumed by the repository

The repository consumes:

- Assembler source;
- JCL;
- HLASM procedures;
- Binder services;
- system libraries;
- TSO/ISPF;
- JES2;
- SDSF.

---

## 27. Outputs produced by the repository

The repository produces:

- HLASM source;
- JCL;
- assembly listings;
- object code;
- object modules;
- load modules;
- Binder output;
- return-code evidence;
- technical notes;
- evidence indexes;
- screenshots;
- security reviews.

---

## 28. Relationship with JCL_LABS

The intended relationship is:

```text
JCL_LABS
   |
   v
general batch-control knowledge
   |
   v
Assembler-specific JCL
```

The Assembler repository should not re-teach basic JCL.

It should focus on how JCL invokes:

- `ASMAC`;
- `ASMACLG`;
- Binder;
- execution.

---

## 29. Relationship with MVS_TSO_ISPF

The interactive preparation path is:

```text
MVS_TSO_ISPF
      |
      v
edit JCL/source
      |
      v
submit
      |
      v
SDSF
```

The TSO/ISPF repository remains the source of truth for interactive environment fundamentals.

---

## 30. Relationship with PL/I and COBOL

The language-layer relationship is:

```text
        z_Assembly
          /    \
         v      v
      COBOL    PL/I
```

Not as a direct dependency, but as a conceptual foundation.

Assembler exposes:

- registers;
- addresses;
- object representation;
- load modules;
- storage;
- machine instructions.

Higher-level languages abstract many of these details.

---

## 31. Relationship with Binder and load modules

The repository provides a useful bridge between language source and z/OS executable form.

Conceptually:

```text
source
 |
 v
translator/compiler/assembler
 |
 v
object
 |
 v
Binder
 |
 v
load module
```

Assembler makes this chain especially visible.

---

## 32. Relationship with system programming

The long-term role of the repository includes preparation for system-programming topics.

Possible future subjects include:

```text
macros
parameter lists
save areas
calling conventions
control blocks
system services
exits
authorized environments
```

These are future topics.

They are not validated by the current repository.

---

## 33. Scope boundary — no system exits yet

The current labs do not validate:

- SMF exits;
- JES exits;
- RACF exits;
- installation exits;
- subsystem exits.

These must not be claimed as completed.

---

## 34. Scope boundary — no authorized code yet

The current repository does not validate:

- APF authorization;
- supervisor state;
- key-controlled execution;
- privileged instructions;
- SVC implementation.

These remain advanced future work.

---

## 35. Scope boundary — no control-block exploitation yet

The current labs do not yet walk structures such as:

```text
TCB
ASCB
PSA
CVT
JFCB
TIOT
```

Any such work belongs in future system-programming labs and must be carefully documented.

---

## 36. Scope boundary — no CICS/Db2 integration yet

The current repository does not validate Assembler application integration with:

- CICS;
- Db2;
- VSAM.

Such work may be valuable later, but should be introduced only when there is a clear technical objective.

---

## 37. Validated vs planned

| Capability | State |
|---|---|
| HLASM assembly | Validated |
| `ASMAC` use | Validated |
| `ASMACLG` use | Validated |
| `CSECT` | Validated |
| `LARL` | Validated |
| `USING` | Validated |
| `LH` | Validated |
| `LR` | Validated |
| `BR 14` | Validated |
| R15 return-code behavior | Validated |
| Binder/link-edit | Validated |
| Load-module execution | Validated |
| HLASM Source/Object listing analysis | Validated |
| Signed H/F/FD constants | Validated |
| two's complement | Validated |
| EBCDIC character constants | Validated |
| duplication factors | Validated |
| explicit lengths | Validated |
| truncation/padding | Validated |
| hex/bit equivalence | Validated |
| automatic alignment | Validated |
| `DS 0F` alignment | Validated |
| macros | Planned |
| save areas | Planned |
| calling conventions | Planned |
| control blocks | Planned |
| system exits | Planned |
| authorized programming | Planned |
| CICS integration | Planned |
| Db2 integration | Planned |

---

## 38. Evidence discipline

Assembler evidence should allow a reviewer to determine:

- what source was assembled;
- which procedure was used;
- what RC the assembler returned;
- what object bytes were generated;
- where symbols were located;
- what alignment was inserted;
- what Binder output was produced;
- what load module executed;
- what return code was observed.

The current repository already follows this model well.

---

## 39. Security/publication discipline

Public material must be reviewed for:

- credentials;
- passwords;
- tokens;
- private keys;
- IP addresses;
- MAC addresses;
- terminal/session identifiers;
- host adapter names;
- unnecessary system-identifying details;
- infrastructure data unrelated to the exercise.

Assembler screenshots can expose more system-level detail than ordinary application code, so evidence review should remain strict.

---

## 40. Engineering methodology

The repository follows:

```text
Build
  |
Execute
  |
Observe
  |
Diagnose
  |
Correct
  |
Validate
  |
Document
```

This applies to both executable and non-executable labs.

For storage-definition labs, "Execute" may effectively mean running the assembler and inspecting generated output rather than running a program.

---

## 41. Recommended future branch model

Future low-level integration work can use short-lived branches such as:

```text
integration/assembler-calling-conventions
integration/assembler-system-services
integration/assembler-control-blocks
integration/assembler-smf-observability
integration/assembler-system-programming
```

Lifecycle:

```text
main
 |
 +--> integration branch
          |
          +--> implementation
          +--> evidence
          +--> validation
          +--> security review
          +--> documentation
          |
          v
         PR
          |
          v
        main
          |
          v
    delete branch
```

---

## 42. Current maturity

The repository has progressed through:

```text
first executable program
        |
        v
register return-code behavior
        |
        v
addressability
        |
        v
object-code inspection
        |
        v
Binder validation
        |
        v
storage representation
        |
        v
alignment and data semantics
```

This is a strong low-level foundation.

---

## 43. Immediate next-stage opportunities

A logical progression may include:

```text
more machine instructions
        |
        v
condition codes
        |
        v
branching
        |
        v
loops
        |
        v
packed/zoned decimal
        |
        v
parameter passing
        |
        v
save areas
        |
        v
subroutines
```

These should remain aligned with the training sequence and actual lab capabilities.

---

## 44. Future system-programming bridge

Once the language foundation is mature, the repository can become a bridge toward:

```text
HLASM
 |
 v
calling conventions
 |
 v
system macros
 |
 v
control blocks
 |
 v
system services
```

At that point it can integrate more directly with the central z/OS engineering repository.

---

## 45. Target ecosystem role

The long-term role of `z_Assembly` is:

> Provide the validated low-level z/Architecture, HLASM, storage, register, addressability, object-code and executable-module foundation required for deeper z/OS system-programming work.

Conceptually:

```text
             Core z/OS Engineering
                     ^
                     |
              future integration
                     |
                 z_Assembly
                 /   |   \
                /    |    \
               v     v     v
             JCL   COBOL   PL/I
```

The current repository already validates the central low-level execution and representation concepts.

Advanced system-programming integration remains planned.

---

## 46. Engineering rule

The repository should continue to follow one central rule:

> Do not stop at symbolic Assembler source when the system can show what HLASM and the Binder actually produced.

That means inspecting and documenting:

- object bytes;
- addresses;
- registers;
- storage values;
- alignment;
- Binder maps;
- return codes;
- actual runtime behavior.

This is what gives the repository its low-level engineering value.
