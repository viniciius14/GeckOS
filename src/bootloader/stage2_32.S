[bits 32]
[global _stage2_32]

section .text

KERNEL_LOCATION equ 0xFFFF80
KERNEL_STACK_SIZE equ 4096

_stage2_32:
    mov esp, _kernel_stack_e

    mov al, 'A'
    mov ah, 0x0F
    mov [0xb8000], ax

    jmp KERNEL_LOCATION

    jmp $


section .bss
_kernel_stack_b:
    resb KERNEL_STACK_SIZE  ; Reserve 4 KiB stack space
_kernel_stack_e:
