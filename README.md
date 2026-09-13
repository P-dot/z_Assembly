# z_Assembly

Hands-on z/Architecture Assembler laboratories executed on a personal z/OS environment running under zPDT/ADCD.

The repository focuses on validating Assembler concepts on a real z/OS system rather than relying on disposable training lab infrastructure. Each lab preserves the JCL, technical explanation, execution evidence, and observed results.

## Labs

| Lab | Topic | Status |
|---|---|---|
| [Lab 01](labs/01-demo1-r15-return-code/) | DEMO1 — assemble, link, execute, and validate the R15 return code | ✅ Complete |
| [Lab 02](labs/02-defining-storage/) | Defining storage — signed binary integers, EBCDIC character constants, hexadecimal/bit strings, lengths, duplication, and alignment | ✅ Complete |
| [Lab 03](labs/03-load-addressing-register-width/) | LOAD, addressing and register width — Part 1: execution harness + LAB101 original/long-displacement/relative LOAD validation | 🟡 Part 1 complete / Lab in progress |

## Environment

- IBM z/OS V1R11 (ADCD laboratory environment)
- zPDT-based mainframe environment
- TSO/ISPF
- SDSF
- High Level Assembler
- Standard `ASMAC` and `ASMACLG` cataloged procedures

## Repository approach

The exercises are based on z/Architecture Assembler concepts and are adapted to the available local z/OS environment. IBM course-specific datasets, credentials, solution libraries, and custom lab procedures are not required.

Each completed lab or published lab milestone contains:

- reproducible JCL/source
- technical theory and experiment design
- expected-versus-observed validation
- execution results
- screenshots from ISPF/SDSF
- evidence index and integrity manifest
- security/publication review
- Git Bash installation and publication commands
