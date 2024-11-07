[bits 64]

[global _stage2_64]

[extern fdc_init]
[extern fdc_read]
; [extern _kernel_main]

section .text

%define KERNEL_LOCATION     0x100000
%define KERNEL_STACK_SIZE   4096

_stage2_64:
    cli                           ; Clear the interrupt flag.

    mov al, 'z'
    mov ah, 0x0F
    mov [0xB8000], ax

    ; setup for kernel
	mov esp, _kernel_stack_e

    ; call fdc_init




	hlt

section .bss

_kernel_stack_b:
    resb KERNEL_STACK_SIZE  ; Reserve 4 KiB stack space
_kernel_stack_e:
