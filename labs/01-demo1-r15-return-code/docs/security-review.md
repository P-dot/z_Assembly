# Publication Security Review — Lab 01

The Lab 01 evidence set was reviewed before packaging for publication.

## Reviewed categories

- IPv4 / IPv6 addresses
- MAC addresses
- host-network adapter identifiers
- local workstation network configuration
- passwords / credentials
- authentication tokens
- private keys

## Result

No host IP address, MAC address, network-adapter identifier, password, token, or private key is intentionally included in the published lab files.

The screenshots contain normal z/OS lab identifiers such as job names, dataset names, procedure names, system library names, return codes, timestamps, and Assembler/Binder output because these are directly relevant to the technical evidence.

## Text scan command

The repository can be rechecked before publication with:

```bash
grep -RIE "([0-9]{1,3}\.){3}[0-9]{1,3}|([0-9A-Fa-f]{2}[:-]){5}[0-9A-Fa-f]{2}" labs/01-demo1-r15-return-code --exclude='*.png' || true
```

Screenshots require visual review because ordinary `grep` does not inspect raster image contents.
