%ifndef BOOT_UTILS_S
%define BOOT_UTILS_S

[bits 16]

section .text

;
; Prints a string to the screen
; Params:
;   - ds:si points to string
;
put_str:
    push si
    push ax
    push bx

.loop:
    lodsb               ; loads next character in al
    or al, al           ; verify if next character is null?
    jz .done

    mov ah, 0x0E        ; call bios interrupt
    mov bh, 0           ; set page number to 0
    int 0x10

    jmp .loop

.done:
    pop bx
    pop ax
    pop si
    ret


%endif
