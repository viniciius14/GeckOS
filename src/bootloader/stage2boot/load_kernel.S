%ifdef BITS64
[bits 64]
%else
[bits 32]
%endif

[global _load_kernel]

%ifdef FAT12
[extern fdc_init]
[extern fdc_read]
%else
[extern hdc_init]
[extern hdc_read]
%endif

section .text

_load_kernel:
    mov eax, 12
    jmp $
    ; find kernel
    ; load kernel into 0x1000000
    ; jmp to 0x1000000



