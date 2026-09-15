# Evidence Index — Lab 03 Part 2

## Negative control

1. `lab102-negative/01-l102neg-source-header-and-hypothesis.png`  
   Negative-control objective, missing base setup and original hypothesis.

2. `lab102-negative/02-l102neg-base-dependent-loads.png`  
   `L`, `LH`, `LR`, `LY`, `LHY` source used for the experiment.

3. `lab102-negative/03-l102neg-asma307e-no-active-using.png`  
   HLASM listing showing four ASMA307E diagnostics and valid `LR 4,3`.

4. `lab102-negative/04-l102neg-assembler-rc008.png`  
   HLASM Return Code 008.

5. `lab102-negative/05-l102neg-asmaclg-continued-to-runtime-s0c1.png`  
   Evidence that the standard local ASMACLG path continued into runtime.

## Compatibility discovery

1. `lab102-compatibility/01-lab102-lfi-unsupported-asma057e.png`  
   `ASMA057E Undefined operation code - LFI`.

2. `lab102-compatibility/02-lab102-amode31-rmode-any-before-iilf-fix.png`  
   Save-module attributes from the LAB102 compatibility attempt, including
   AMODE 31 and RMODE ANY.

## Final corrected LAB102

1. `lab102-final/01-lab102-source-header-no-base-register.png`  
   LAB102 source header and explicit absence of `LARL` / `USING`.

2. `lab102-final/02-lab102-final-source-iilf-lhi.png`  
   Final source using `IILF 5,187` and `LHI 6,2048`.

3. `lab102-final/03-lab102-final-registers-and-intentional-s0c1.png`  
   Final R2-R6 state plus controlled S0C1.

4. `lab102-final/04-lab102-final-hlasm-rc000.png`  
   No statements flagged; HLASM Return Code 000.

5. `lab102-final/05-lab102-final-binder-entry-rc0.png`  
   LAB102 entry point, AMODE 31 and Binder Return Code 0.

## Evidence boundary

A fresh final Source/Object screen showing `IILF` object bytes was not captured.
The package does not claim byte-level IILF encoding evidence.

`../evidence/SHA256SUMS-part2.txt` provides SHA-256 integrity values for all
Part 2 screenshots.
