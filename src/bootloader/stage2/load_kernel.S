%ifdef BITS64
[bits 64]
%else
[bits 32]
%endif

[global _load_kernel]

[extern print_string_32]

%include "macros.S"
%include "constants.S"

section .text

_load_kernel:
    mov esi, stage2msg3     ; Point ESI to the string
    mov ebx, 320            ; Start at the top-left corner of the screen
    ; to delete later
    call print_string_32


    jmp $

    unreachable

section .data
stage2msg3: db "Got to load kernel. (32 bits)", 0
