//ASM03H   JOB 1,'ASM LAB03',
//             CLASS=A,MSGCLASS=X,
//             MSGLEVEL=(1,1),NOTIFY=&SYSUID
//*
//* ================================================================
//* LAB 03 - LOAD, ADDRESSING AND REGISTER WIDTH
//* PHASE 0 - EXECUTION HARNESS VALIDATION
//*
//* EXPECTED:
//*   ASSEMBLER  RC=0000
//*   BINDER     RC=0000
//*   EXECUTION  ABEND=S0C1 (INTENTIONAL)
//* ================================================================
//ASM      EXEC ASMACLG
//C.SYSIN DD *
HARN03   CSECT

***********************************************************************
* ESTABLISH SIMPLE ADDRESSABILITY
***********************************************************************
         LARL  12,HARN03
         USING HARN03,12

***********************************************************************
* LOAD KNOWN VALUES INTO GENERAL-PURPOSE REGISTERS
***********************************************************************
         L     2,=F'170'
         LH    3,=H'4095'
         LR    4,3

***********************************************************************
* CONTROLLED DIAGNOSTIC TERMINATION
*
* X'0000' IS NOT AN EXECUTABLE INSTRUCTION.
* REACHING THIS FIELD INTENTIONALLY CAUSES S0C1 SO THAT THE
* REGISTER STATE CAN BE OBSERVED IN THE ABEND INFORMATION.
***********************************************************************
         DC    H'0'

         END   HARN03
/*
//G.SYSUDUMP DD SYSOUT=*
