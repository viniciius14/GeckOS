%ifndef BOOT_UTILS_S
%define BOOT_UTILS_S

[bits 16]

; [global disk_read]
; [global report_error]

SECTION .text

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
    lodsb                               ; loads next character in al
    or al, al                           ; verify if next character is null?
    jz .done

    mov ah, 0x0E                        ; call bios interrupt
    mov bh, 0                           ; set page number to 0
    int 0x10

    jmp .loop

.done:
    pop bx
    pop ax
    pop si
    ret



;
; Disk routines
;

;
; Converts an LBA address to a CHS address
; Parameters:
;   - ax: LBA address
; Returns:
;   - cx [bits 0-5]:  sector number
;   - cx [bits 6-15]: cylinder
;   - dh: head
;

lba_to_chs:

    push ax
    push dx

    xor dx, dx                          ; dx = 0

    div word [0x7C18]                   ; address of bdb_sectors_per_track

    inc dx                              ; dx = (LBA % SectorsPerTrack + 1) = sector
    mov cx, dx                          ; cx = sector

    xor dx, dx                          ; dx = 0

    div word [0x7C1A]                   ; address of bdb_heads
                                        ; dx = (LBA / SectorsPerTrack) % Heads = head
    mov dh, dl                          ; dh = head
    mov ch, al                          ; ch = cylinder (lower 8 bits)
    shl ah, 6
    or cl, ah                           ; put upper 2 bits of cylinder in CL

    pop ax
    mov dl, al                          ; restore DL
    pop ax
    ret

;
; Reads sectors from a disk
; Parameters:
;   - ax: LBA address
;   - cl: number of sectors to read (up to 128)
;   - dl: drive number
;   - es:bx: memory address where to store read data
;
disk_read:

    push ax                             ; save registers we will modify
    push bx
    push cx
    push dx
    push di

    push cx                             ; temporarily save CL (number of sectors to read)
    call lba_to_chs                     ; compute CHS
    pop ax                              ; AL = number of sectors to read

    mov ah, 02h
    mov di, 3                           ; retry count

.retry:
    pusha                               ; save all registers, we don't know what bios modifies
    stc                                 ; set carry flag, some BIOS'es don't set it
    int 13h                             ; carry flag cleared = success
    jnc .done                           ; jump if carry not set

    ; read failed
    popa
    call disk_reset

    dec di
    test di, di
    jnz .retry

.fail:
    jmp report_error                    ; all attempts are exhausted

.done:
    popa

    pop di
    pop dx
    pop cx
    pop bx
    pop ax                              ; restore registers modified
    ret


;
; Resets disk controller
; Parameters:
;   dl: drive number
;
disk_reset:
    pusha
    mov ah, 0
    stc
    int 13h
    jc report_error
    popa
    ret


;
; Error handler
;
report_error:
    mov si, error_message
    call put_str

    jmp $

; SECTION .rodata
error_message:        db "ERROR DETECTED."

%endif
