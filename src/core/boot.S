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
    call KernelMain
    hlt
HaltKernel:
    cli
    hlt
    jmp HaltKernel

section .bss

resb 8192 * 2

stack_space:
