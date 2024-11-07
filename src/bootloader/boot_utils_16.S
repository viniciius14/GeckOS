%ifndef BOOT_UTILS_16_S
%define BOOT_UTILS_16_S

[bits 16]

section .text

; Carriage return and line feed
%define ENDL_CR 0x0D
%define ENDL_LF 0x0A

;
; Prints a string to the screen
; Params:
;   - ds:si points to string
;

put_str:
    push si
    push ax
    push bx

    mov ah, 0x0E        ; BIOS teletype output
.loop:
    lodsb               ; Load next character into AL
    cmp al, ENDL_CR     ; Check if character is carriage return
    jne .print_char     ; If not, print the character

    ; Check for line feed after carriage return
    lodsb               ; Load next character (expecting line feed)
    cmp al, ENDL_LF
    jne .print_char     ; If not line feed, print the character as-is

    ; Move cursor to the next line (simulate newline)
    mov al, 0x0A        ; Line feed (moves cursor down)
    int 0x10
    mov al, 0x0D        ; Carriage return (moves cursor to start of line)
    int 0x10
    jmp .done

.print_char:
    mov bh, 0           ; Set page number to 0
    int 0x10            ; Print character in AL

    jmp .loop

.done:
    pop bx
    pop ax
    pop si
    ret

%endif
