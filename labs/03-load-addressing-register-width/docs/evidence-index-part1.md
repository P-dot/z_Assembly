# Evidence Index — Lab 03 Part 1

Only evidence relevant to the Part 1 engineering claims is retained. Large,
repetitive SYSUDUMP pages were intentionally excluded.

## Phase 0 — HARN03

1. [`01-harn03-source-and-expected-results.png`](../evidence/phase0-harness/01-harn03-source-and-expected-results.png)  
   HARN03 source, standard ASMACLG invocation and expected results.

2. [`02-harn03-s0c1-and-registers.png`](../evidence/phase0-harness/02-harn03-s0c1-and-registers.png)  
   Expected S0C1 and compact GPR state proving the harness works.

3. [`03-harn03-source-object-listing.png`](../evidence/phase0-harness/03-harn03-source-object-listing.png)  
   HLASM Source/Object listing for `L`, `LH`, `LR`.

4. [`04-harn03-using-map-and-register-cross-reference.png`](../evidence/phase0-harness/04-harn03-using-map-and-register-cross-reference.png)  
   Literal cross-reference, USING Map and GPR cross-reference.

5. [`05-harn03-binder-baseline-rmode24.png`](../evidence/phase0-harness/05-harn03-binder-baseline-rmode24.png)  
   Binder baseline exposing the legacy 24-bit module attribute behavior prior
   to explicit LAB101 AMODE/RMODE declarations.

## LAB101

1. [`01-lab101-source-header-amode-rmode-addressability.png`](../evidence/lab101/01-lab101-source-header-amode-rmode-addressability.png)  
   Source header, explicit `AMODE 31`, `RMODE ANY`, `LARL` and `USING`.

2. [`02-lab101-source-load-families-and-sysudump.png`](../evidence/lab101/02-lab101-source-load-families-and-sysudump.png)  
   Complete instruction families and controlled diagnostic termination.

3. [`03-lab101-s0c1-and-register-results.png`](../evidence/lab101/03-lab101-s0c1-and-register-results.png)  
   Expected S0C1 and R2-R8 values.

4. [`04-lab101-source-object-literals-addressing.png`](../evidence/lab101/04-lab101-source-object-literals-addressing.png)  
   Object encodings, literal locations, long displacement and relative-long
   encodings.

5. [`05-lab101-using-map-register-cross-reference.png`](../evidence/lab101/05-lab101-using-map-register-cross-reference.png)  
   USING Map and GPR cross-reference.

6. [`06-lab101-hlasm-return-code-000.png`](../evidence/lab101/06-lab101-hlasm-return-code-000.png)  
   HLASM Return Code 000.

7. [`07-lab101-binder-module-map-rmode-any.png`](../evidence/lab101/07-lab101-binder-module-map-rmode-any.png)  
   Binder module map showing `RMODE=ANY`.

8. [`08-lab101-save-module-amode31-rmode-any.png`](../evidence/lab101/08-lab101-save-module-amode31-rmode-any.png)  
   Saved module attributes confirming `AMODE 31` and `RMODE ANY`.

9. [`09-lab101-binder-entry-point-rc0.png`](../evidence/lab101/09-lab101-binder-entry-point-rc0.png)  
   LAB101 entry point and Binder Return Code 0.

## Integrity

[`../evidence/SHA256SUMS.txt`](../evidence/SHA256SUMS.txt) contains SHA-256
digests for every published screenshot in this milestone.
