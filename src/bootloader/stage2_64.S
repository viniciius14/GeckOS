[bits 64]

[global _stage2_64]

[extern fdc_init]
[extern fdc_read]

section .text

KERNEL_LOCATION 	equ 	0xFFFF80
KERNEL_STACK_SIZE 	equ 	4096


_stage2_64:
	mov esp, _kernel_stack_e

    ; call fdc_init      ; Call the function
    ; ; movzx eax, al      ; Zero-extend the 8-bit result from AL to EAX if needed

    ; ; push KERNEL_LOCATION
    ; ; ; TBD REMOVE THIS HARDCODED VALUE
    ; ; ; THIS IS JUST STAGE1_SIZE + STAGE2_SIZE
    ; push 12
    ; push kernel
    ; call fdc_read    ; Call the function



	hlt
section .bss

_kernel_stack_b:
    resb KERNEL_STACK_SIZE  ; Reserve 4 KiB stack space
_kernel_stack_e: