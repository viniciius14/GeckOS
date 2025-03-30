%ifdef BITS64
[bits 64]
%else
[bits 32]
%endif

[global _load_kernel]

%ifdef FAT12
[extern FdcInit]
[extern FdcRead]
%else
[extern HdcInit]
[extern HdcRead]
%endif

%include "macros.S"

section _load_kernel.text

_load_kernel:
    mov esi, stage2msg3     ; Point ESI to the string
    mov ebx, 320            ; Start at the top-left corner of the screen
    call print_string_32

    jmp $

    call FdcInit

    jmp $
    ; find kernel
    ; load kernel into 0x1000000
    ; jmp to 0x1000000

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
stage2msg3: db "Got to stage 2 of the bootloader. 123213(32 bits)", 0
