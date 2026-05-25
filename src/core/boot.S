BITS 32

%ifdef GRUB
    %include "grub.S"
%endif

global start
extern KernelMain

section .text

start:
    cli
    mov esp, stack_space

; Push the multiboot information structure to the stack
%ifdef GRUB
    push ebx
    push eax
%endif
    call KernelMain
    hlt
HaltKernel:
    cli
    hlt
    jmp HaltKernel

section .bss

resb 8192 * 2

stack_space:
