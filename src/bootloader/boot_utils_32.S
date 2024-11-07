%ifndef BOOT_UTILS_32_S
%define BOOT_UTILS_32_S

[bits 32]

; Carriage return and line feed
%define ENDL    		0x0D 0x0A
%define ENDL_CR 		0x0D
%define ENDL_LF 		0x0A

%define VIDEO_MEMORY 	0xB8000

section .text

checkCPUID:
    ; Check if CPUID is supported by attempting to flip the ID bit (bit 21) in
    ; the FLAGS register. If we can flip it, CPUID is available.

    ; Copy FLAGS in to EAX via stack
    pushfd
    pop eax

    ; Copy to ECX as well for comparing later on
    mov ecx, eax

    ; Flip the ID bit
    xor eax, 1 << 21

    ; Copy EAX to FLAGS via the stack
    push eax
    popfd

    ; Copy FLAGS back to EAX (with the flipped bit if CPUID is supported)
    pushfd
    pop eax

    ; Restore FLAGS from the old version stored in ECX (i.e. flipping the ID bit
    ; back if it was ever flipped).
    push ecx
    popfd

    ; Compare EAX and ECX. If they are equal then that means the bit wasn"t
    ; flipped, and CPUID isn"t supported.
    xor eax, ecx
    jz .noCPUID

	mov si, ok_msg_CPUID
	call put_str32

    ret

.noCPUID:
    mov si, error_msg_CPUID
	call put_str32
    hlt
checkLongMode:
    mov eax, 0x80000000    ; Set the A-register to 0x80000000.
    cpuid                  ; CPU identification.
    cmp eax, 0x80000001    ; Compare the A-register with 0x80000001.
    jb .noLongMode         ; It is less, there is no long mode.

	mov eax, 0x80000001    ; Set the A-register to 0x80000001.
    cpuid                  ; CPU identification.
    test edx, 1 << 29      ; Test if the LM-bit, which is bit 29, is set in the D-register.
    jz .noLongMode         ; They aren't, there is no long mode.

	mov si, ok_msg_LongMode
	call put_str32
	ret
.noLongMode:
	mov si, error_msg_LongMode
	call put_str32
	hlt


; TBD implement carriage return
put_str32:
	pusha

	mov ah, 0x0F			; White characters on black background
	mov edx, VIDEO_MEMORY

	lodsb               ; Load next character into AL
.print_char:
	mov [edx], ax
	add edx, 2

.loop:
	lodsb
	cmp al, 0
	jne .print_char
	; cmp al, ENDL_CR     ; Check if character is carriage return
    ; jne .print_char     ; If not, print the character

	; jmp .done

    ; ; Check for line feed after carriage return
    ; lodsb               ; Load next character (expecting line feed)
    ; cmp al, ENDL_LF
    ; jne .print_char     ; If not line feed, print the character as-is

.done:
	popa
    ret


section .data

ok_msg_CPUID: db "[OK] CPUID supported.", ENDL, 0
error_msg_CPUID: db "[ERROR] CPUID instruction is not supported.", ENDL, 0

ok_msg_LongMode: db "[OK] Long Mode supported.", ENDL, 0
error_msg_LongMode: db "[ERROR] Long Mode not supported.", ENDL, 0

%endif
