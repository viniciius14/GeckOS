BITS 32

; @TODO: Add an %ifdef GRUB
; %ifdef GRUB
;     %include "grub.S"
; %endif

section .text
    align 4
    dd 0x1BADB002 ; Magic number
    dd 0x00       ; Flags
    dd -(0x1BADB002 + 0x00) ; Checksum
global start
extern KernelMain

start:
    cli
    mov esp, stack_space
    call KernelMain
    hlt
HaltKernel:
    cli
    hlt
    jmp HaltKernel

section .bss

resb 8192

stack_space:
