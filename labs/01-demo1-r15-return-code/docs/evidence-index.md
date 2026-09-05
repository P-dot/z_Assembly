# Evidence Index — Lab 01

All images in this directory were captured from the actual zPDT/ADCD z/OS lab execution.

| # | File | What it proves |
|---:|---|---|
| 01 | `01-sys1-proclib-asmaclg-available.png` | Standard Assembler procedures, including `ASMACLG`, are available in `SYS1.PROCLIB`. |
| 02 | `02-ibmuser-asm-jcl-dataset-attributes.png` | `IBMUSER.ASM.JCL` is a PDS with FB/80 characteristics and track allocation. |
| 03 | `03-demo1-source-baseline-h10.png` | Baseline DEMO1 source in ISPF Edit with `INT1 DC H'10'`. |
| 04 | `04-joblog-asm-demo1-execution.png` | JES2 job log for `ASMDEMO`. |
| 05 | `05-asmaclg-step-summary-part1.png` | ASMACLG processing and successful assembly/link stages. |
| 06 | `06-asmaclg-go-rc0010.png` | GO step completed with condition code `0010`. |
| 07 | `07-hlasm-option-summary.png` | High Level Assembler option summary for the assembly. |
| 08 | `08-assembly-listing-object-code.png` | Generated machine code and `INT1` object data (`000A`). |
| 09 | `09-using-map-register-cross-reference.png` | USING map confirms R12 addressability; register cross-reference is visible. |
| 10 | `10-assembler-summary-rc0000.png` | No statements flagged and assembler return code `0000`. |
| 11 | `11-binder-module-map.png` | Binder module map and CSECT information. |
| 12 | `12-binder-processing-options.png` | Binder processing options. |
| 13 | `13-binder-save-operation-summary.png` | Binder SAVE/module attributes. |
| 14 | `14-binder-entry-point-message-summary.png` | `DEMO1` entry point and Binder message summary. |
| 15 | `15-binder-message-summary-end.png` | End of Binder message report. |
| 16 | `16-demo1-source-h4095.png` | Modified source for the return-code boundary experiment with `H'4095'`. |
| 17 | `17-maxcc4095-message.png` | Job completion message showing `MAXCC=4095`. |
| 18 | `18-go-cond-code4095.png` | GO step condition code `4095`. |
| 19 | `19-go-cond-code0000-h4096.png` | 4096 experiment produced GO condition code `0000`. |
| 20 | `20-go-cond-code0001-h4097.png` | 4097 experiment produced GO condition code `0001`. |

## Key evidence set

For a concise review of the lab, the most important screenshots are:

1. `01-sys1-proclib-asmaclg-available.png`
2. `03-demo1-source-baseline-h10.png`
3. `06-asmaclg-go-rc0010.png`
4. `08-assembly-listing-object-code.png`
5. `09-using-map-register-cross-reference.png`
6. `10-assembler-summary-rc0000.png`
7. `16-demo1-source-h4095.png`
8. `18-go-cond-code4095.png`
9. `19-go-cond-code0000-h4096.png`
10. `20-go-cond-code0001-h4097.png`
