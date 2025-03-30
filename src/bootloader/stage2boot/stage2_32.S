[bits 32]
[global _stage2_32]

%ifdef BITS64
[extern _stage2_64]
%else
[extern _load_kernel]
%endif

%include "macros.S"

section _stage2_32.text

_stage2_32:
	; mov esp, stack_start

    mov esi, stage2msg2     ; Point ESI to the string
    mov ebx, 160            ; Start at the top-left corner of the screen

    call print_string_32
    jmp $
    jmp $

%ifdef BITS64
;     ; jump to _stage2_64
;     jmp _stage2_64
%else
    ; jmp _load_kernel
%endif

    unreachable


; Print example, to delete later
VIDEO_MEMORY equ 0xB8000
WHITE_ON_BLACK equ 0x0F
; Function to print a string
; Input: ESI = pointer to the string, EBX = position on the screen
print_string_32:
    mov edi, VIDEO_MEMORY
    add edi, ebx            ; Add the position offset to the video memory address

.print_char:
    lodsb                   ; Load the next character from the string into AL
    cmp al, 0               ; Check if it's the end of the string
    je .done

    mov ah, WHITE_ON_BLACK  ; Set the attribute (white on black)
    mov [edi], ax           ; Write the character and attribute to video memory
    add edi, 2              ; Move to the next character position

    jmp .print_char

.done:
    ret

section .data

stage2msg2: db "Got to stage 2 of the bootloader. (32 bits)", 0

section .bss

align 4096
stack_start:
	resb 4096
stack_end:
