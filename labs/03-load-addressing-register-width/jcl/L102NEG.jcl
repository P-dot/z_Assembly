//ASM032N  JOB 1,'ASM LAB03',
//             CLASS=A,MSGCLASS=X,
//             MSGLEVEL=(1,1),NOTIFY=&SYSUID
//*
//* ================================================================
//* LAB 03 - LOAD, ADDRESSING AND REGISTER WIDTH
//* PART 2 / LAB102 - NEGATIVE ADDRESSABILITY CONTROL
//*
//* OBJECTIVE:
//*   PROVE THAT BASE-DISPLACEMENT LOAD INSTRUCTIONS CANNOT
//*   RESOLVE SYMBOLIC STORAGE OPERANDS WITHOUT ACTIVE USING.
//*
//* ORIGINAL HYPOTHESIS:
//*   ASSEMBLER  RC=0008
//*   ASMA307E   NO ACTIVE USING
//*   BINDER     NOT EXECUTED
//*   EXECUTION  NOT EXECUTED
//*
//* OBSERVATION:
//*   STANDARD ASMACLG CONTINUED AFTER RC=0008.
//*   SEE docs/results-part2.md AND troubleshooting-part2.md.
//* ================================================================
//ASM      EXEC ASMACLG
//C.SYSIN DD *
LAB102N  CSECT
LAB102N  AMODE 31
LAB102N  RMODE ANY

***********************************************************************
* NO BASE REGISTER IS ESTABLISHED ON PURPOSE.
*
* THERE IS NO:
*        LARL  12,LAB102N
*        USING LAB102N,12
***********************************************************************

***********************************************************************
* PART 1 - ORIGINAL BASE-DISPLACEMENT LOADS
***********************************************************************
         L     2,=F'170'
         LH    3,=H'4095'

***********************************************************************
* REGISTER-TO-REGISTER CONTROL
***********************************************************************
         LR    4,3

***********************************************************************
* PART 2 - LONG-DISPLACEMENT LOADS
***********************************************************************
         LY    5,=F'187'
         LHY   6,=H'2048'

***********************************************************************
* WOULD BE REACHED ONLY IF THE PROGRAM COULD BE BUILT AND RUN
***********************************************************************
         DC    H'0'

         END   LAB102N
/*
