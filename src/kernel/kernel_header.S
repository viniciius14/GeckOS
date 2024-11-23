[global _kernel_header]

section .text

_kernel_header:
; magic numbers to mark beggining of the kernel
	dd 0xDEADBEEF
	dd 0x1BADB001
