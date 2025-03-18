[bits 32]
[global _stage2_32]
[extern fdc_init]
[extern fdc_read]
[extern hdc_init]
[extern hdc_read]

section .text

_stage2_32:
	; mov esp, stack_top
    mov esi, stage2msg2     ; Point ESI to the string
    mov ebx, 160            ; Start at the top-left corner of the screen
    call print_string_32

    jmp $                       ; should never happen
    cli                         ; disable interrupts
    hlt                         ; this way CPU can't get out of "halt" state

; Print example, to delete later
VIDEO_MEMORY equ 0xB8000
WHITE_ON_BLACK equ 0x0F
; Function to print a string
; Input: ESI = pointer to the string, EBX = position on the screen
print_string_32:
    mov edi, VIDEO_MEMORY
    add edi, ebx        ; Add the position offset to the video memory address

.print_char:
    lodsb               ; Load the next character from the string into AL
    cmp al, 0           ; Check if it's the end of the string
    je .done

    mov ah, WHITE_ON_BLACK ; Set the attribute (white on black)
    mov [edi], ax       ; Write the character and attribute to video memory
    add edi, 2          ; Move to the next character position

    jmp .print_char

.done:
    ret

section .data

stage2msg2: db "Got to stage 2 of the bootloader. (32 bits)", 0

section .bss

align 4096
stack_end:
	resb 4096
stack_start:
