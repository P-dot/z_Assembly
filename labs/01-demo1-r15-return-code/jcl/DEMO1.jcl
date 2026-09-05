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
