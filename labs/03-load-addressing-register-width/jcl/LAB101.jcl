//ASM031   JOB 1,'ASM LAB03',
//             CLASS=A,MSGCLASS=X,
//             MSGLEVEL=(1,1),NOTIFY=&SYSUID
//*
//* ================================================================
//* LAB 03 - LOAD, ADDRESSING AND REGISTER WIDTH
//* LAB101 - LOW-HALF LOAD INSTRUCTION FAMILIES
//*
//* OBJECTIVE:
//*   COMPARE ORIGINAL, LONG-DISPLACEMENT AND
//*   RELATIVE-ADDRESSING LOAD INSTRUCTIONS.
//*
//* EXPECTED:
//*   ASSEMBLER  RC=0000
//*   BINDER     RC=0000
//*   EXECUTION  ABEND=S0C1 (INTENTIONAL)
//* ================================================================
//ASM      EXEC ASMACLG
//C.SYSIN DD *
LAB101   CSECT
LAB101   AMODE 31
LAB101   RMODE ANY

***********************************************************************
* ADDRESSABILITY
***********************************************************************
         LARL  12,LAB101
         USING LAB101,12

***********************************************************************
* PART 1 - ORIGINAL LOAD INSTRUCTIONS
*
* L AND LH ADDRESS STORAGE THROUGH A BASE REGISTER AND
* 12-BIT UNSIGNED DISPLACEMENT.
***********************************************************************
         L     2,=F'170'
         LH    3,=H'4095'
         LR    4,3

***********************************************************************
* PART 2 - LONG-DISPLACEMENT LOAD INSTRUCTIONS
*
* LY AND LHY EXTEND THE AVAILABLE STORAGE DISPLACEMENT.
***********************************************************************
         LY    5,=F'187'
         LHY   6,=H'2048'

***********************************************************************
* PART 3 - RELATIVE-ADDRESSING LOAD INSTRUCTIONS
*
* LRL AND LHRL ADDRESS THE OPERAND RELATIVE TO THE
* INSTRUCTION LOCATION AND DO NOT REQUIRE R12 TO FORM
* THE EFFECTIVE OPERAND ADDRESS.
***********************************************************************
         LRL   7,=F'1024000'
         LHRL  8,=H'255'

***********************************************************************
* CONTROLLED DIAGNOSTIC TERMINATION
***********************************************************************
         DC    H'0'

         END   LAB101
/*
//G.SYSUDUMP DD SYSOUT=*
