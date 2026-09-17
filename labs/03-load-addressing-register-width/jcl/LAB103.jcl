//ASM033   JOB 1,'ASM LAB03',
//             CLASS=A,MSGCLASS=X,
//             MSGLEVEL=(1,1),NOTIFY=&SYSUID
//*
//* ================================================================
//* LAB 03 - LOAD, ADDRESSING AND REGISTER WIDTH
//* PART 3 / LAB103 - FULL 64-BIT LOAD OPERATIONS
//*
//* OBJECTIVE:
//*   VALIDATE 64-BIT LOAD, SIGN EXTENSION, RELATIVE ADDRESSING
//*   AND IMMEDIATE OPERANDS USING COMPLETE GENERAL-PURPOSE REGISTERS.
//*
//* EXPECTED:
//*   ASSEMBLER  RC=0000
//*   BINDER     RC=0000
//*   EXECUTION  ABEND=S0C1 (INTENTIONAL)
//* ================================================================
//ASM      EXEC ASMACLG
//C.SYSIN DD *
LAB103   CSECT
LAB103   AMODE 31
LAB103   RMODE ANY

***********************************************************************
* ADDRESSABILITY REQUIRED BY PART 1
***********************************************************************
         LARL  12,LAB103
         USING LAB103,12

***********************************************************************
* PART 1 - 64-BIT LOADS FROM STORAGE
***********************************************************************
         LG    2,DW1
         LGF   3,F1
         LGH   4,H1

***********************************************************************
* PART 2 - 64-BIT RELATIVE-ADDRESSING LOADS
***********************************************************************
         LGRL  5,DW1
         LGFRL 6,F1
         LGHRL 7,H1

***********************************************************************
* PART 3 - 64-BIT IMMEDIATE-OPERAND LOADS
***********************************************************************
         LGFI  8,-131072
         LGHI  9,0

***********************************************************************
* CONTROLLED DIAGNOSTIC TERMINATION
***********************************************************************
         DC    H'0'

***********************************************************************
* PROGRAM DATA
***********************************************************************
DW1      DC    D'100000000000'
F1       DC    F'-1'
H1       DC    H'-32768'

         END   LAB103
/*
//G.SYSUDUMP DD SYSOUT=*
