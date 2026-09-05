# Observed Results

| Test | Assembly | Binder | GO | Expected | Result |
|---|---:|---:|---:|---:|---|
| `INT1=10` | `0000` | `0000` | `0010` | `0010` | PASS |
| `INT1=4095` | `0000` | `0000` | `4095` | `4095` | PASS |
| `INT1=4096` | `0000` | `0000` | `0000` | `0000` | PASS |
| `INT1=4097` | `0000` | `0000` | `0001` | `0001` | PASS |

The experiment demonstrates that the program explicitly transfers `INT1` through R3 to R15 and that the observed step return code reflects the low-order 12-bit return-code value.
