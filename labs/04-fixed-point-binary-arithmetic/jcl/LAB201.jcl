//ASM041   JOB 1,'ASM LAB04',
//             CLASS=A,MSGCLASS=X,
//             MSGLEVEL=(1,1),NOTIFY=&SYSUID
//*
//* ================================================================
//* LAB 04 - FIXED-POINT BINARY ARITHMETIC
//* LAB201 - ADD AND SUBTRACT
//*
//* PART 1:
//*   VALIDATE 32-BIT FIXED-POINT ADD/SUBTRACT USING STORAGE
//*   OPERANDS.
//*
//* PART 2:
//*   REPEAT THE SAME CALCULATION USING IMMEDIATE OPERANDS.
//*
//* EXPECTED:
//*   HLASM      RC=0000
//*   BINDER     RC=0000
//*
//*   R2 LOW     0000AAAA
//*   R3 LOW     00008888
//*   R4 LOW     0000AAAA
//*   R5 LOW     00008888
//*
//*   EXECUTION  S0C1 INTENTIONAL
//* ================================================================
//ASM      EXEC ASMACLG
//C.SYSIN DD *
LAB201   CSECT
LAB201   AMODE 31
LAB201   RMODE ANY

***********************************************************************
* ESTABLISH BASE REGISTER ADDRESSABILITY
***********************************************************************
         LARL  12,LAB201
         USING LAB201,12

***********************************************************************
* PART 1 - STORAGE-OPERAND INSTRUCTIONS
***********************************************************************
* LOAD 40960 INTO LOW 32 BITS OF R2
* 40960 DECIMAL = X'0000A000'
         L     2,=F'40960'

* ADD 2730 FROM STORAGE
* 2730 DECIMAL = X'00000AAA'
*   0000A000
* + 00000AAA
* -----------
*   0000AAAA
         A     2,=F'2730'

* COPY LOW 32 BITS OF R2 INTO R3
         LR    3,2

* SUBTRACT SIGNED 16-BIT HALFWORD FROM R3
* 8738 DECIMAL = X'2222'
*   0000AAAA
* - 00002222
* -----------
*   00008888
         SH    3,=H'8738'

***********************************************************************
* PART 2 - IMMEDIATE-OPERAND INSTRUCTIONS
***********************************************************************
* LOCAL HLASM ADAPTATION:
* COURSE MNEMONIC LFI IS NOT RECOGNIZED ON THIS LOCAL HLASM LEVEL.
* IILF WAS PREVIOUSLY VALIDATED IN LAB 03 / LAB102.
*
* 40960 = X'0000A000'
         IILF  4,40960

* 2730 = X'00000AAA'
         AFI   4,2730

* COPY LOW 32 BITS OF R4 INTO R5
         LR    5,4

* SUBTRACT 8738 BY ADDING SIGNED IMMEDIATE -8738.
* +8738 = X'2222'
* TWO'S COMPLEMENT:
*   2222 -> DDDD -> DDDE
* -8738 = X'DDDE'
* SIGN-EXTENDED 32-BIT VALUE = X'FFFFDDDE'
*
*   0000AAAA
* + FFFFDDDE
* -----------
*   00008888
         AHI   5,-8738

***********************************************************************
* CONTROLLED DIAGNOSTIC TERMINATION
***********************************************************************
         DC    H'0'

***********************************************************************
* PLACE PART 1 STORAGE LITERALS AT A CONTROLLED POINT
***********************************************************************
         LTORG

         END   LAB201
/*
//G.SYSUDUMP DD SYSOUT=*
