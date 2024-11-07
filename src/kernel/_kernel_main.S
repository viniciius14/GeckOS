[global _kernel_main]

section .text

_kernel_main:
; magic numbers to mark beggining of the kernel
	db 0xDEADBEEF
	db 0x1BADB001

	jmp kernel_main

	hlt
