//ASM032   JOB 1,'ASM LAB03',
//             CLASS=A,MSGCLASS=X,
//             MSGLEVEL=(1,1),NOTIFY=&SYSUID
//*
//* ================================================================
//* LAB 03 - LOAD, ADDRESSING AND REGISTER WIDTH
//* PART 2 / LAB102 - LOAD WITHOUT A BASE REGISTER
//*
//* OBJECTIVE:
//*   LOAD VALUES WITHOUT ESTABLISHING BASE-REGISTER ADDRESSABILITY.
//*   COMPARE RELATIVE-ADDRESSING AND IMMEDIATE-OPERAND LOADS.
//*
//* COMPATIBILITY NOTE:
//*   THE 2023 COURSE USES LFI. THIS ADCD/HLASM LEVEL DOES NOT
//*   RECOGNIZE THAT MNEMONIC, SO IILF IS USED FOR THE LOW FULLWORD.
//*
//* EXPECTED:
//*   ASSEMBLER  RC=0000
//*   BINDER     RC=0000
//*   EXECUTION  ABEND=S0C1 (INTENTIONAL)
//* ================================================================
//ASM      EXEC ASMACLG
//C.SYSIN DD *
LAB102   CSECT
LAB102   AMODE 31
LAB102   RMODE ANY

***********************************************************************
* NO BASE REGISTER
*
* THERE IS INTENTIONALLY NO:
*        LARL  12,LAB102
*        USING LAB102,12
***********************************************************************

***********************************************************************
* PART 1 - RELATIVE-ADDRESSING LOADS
***********************************************************************
         LRL   2,=F'170'
         LHRL  3,=H'4095'

***********************************************************************
* REGISTER-TO-REGISTER LOAD
***********************************************************************
         LR    4,3

***********************************************************************
* PART 2 - IMMEDIATE-OPERAND LOADS
***********************************************************************
         IILF  5,187
         LHI   6,2048

***********************************************************************
* CONTROLLED DIAGNOSTIC TERMINATION
***********************************************************************
         DC    H'0'

         END   LAB102
/*
//G.SYSUDUMP DD SYSOUT=*
