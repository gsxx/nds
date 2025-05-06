.arm
.align 4

.global _start
_start:
    b init

.include "crt0_nds.inc"