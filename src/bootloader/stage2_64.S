[bits 64]

[global _stage2_64]

[extern _load_kernel]
[extern fdc_init]
[extern fdc_read]
; [extern _kernel_main]

section .text

%define KERNEL_LOCATION     0x100000

_stage2_64:
    cli         ; Clear the interrupt flag.

    mov ax, 0
    mov ss, ax
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov al, 'z'
    mov ah, 0x0F
    mov [0xB8000], ax

    ; call _load_kernel

    ; jmp KERNEL_LOCATION

	hlt
