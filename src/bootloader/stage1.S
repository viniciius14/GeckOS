[bits 16]

%define S2_LOAD_SEGMENT 0x0
%define S2_LOAD_OFFSET  0x7E00
%define ENDL            0x0D, 0x0A

%include "header.S"

_stage1_start:
    mov ah, 0xE
    mov al, 'H'
    int 0x10
    mov ah, 0xE
    mov al, 'e'
    int 0x10
    mov ah, 0xE
    mov al, 'l'
    int 0x10
    mov ah, 0xE
    mov al, 'l'
    int 0x10
    mov ah, 0xE
    mov al, 'o'
    int 0x10
    mov ah, 0xE
    mov al, '!'
    int 0x10

    cli                 ; Clear interrupt flag
    cld                 ; Clear direction flag
	xor ax, ax          ; Clear main registers
	mov ds, ax
	mov es, ax
	mov ss, ax
	mov sp, 0x7C00
; Find stage 2 of the bootloader and load it into memory



;     ; Setup to call disk_read
;     mov ax, 1                       ; LBA Address
;     ; mov cl, (RESERVED_SECTORS - 1)  ; Sector Number
;     mov dl, [ebr_drive_number]
;     mov bx, S2_LOAD_OFFSET

;     ; Load stage2 of the bootloader into RAM address 0x7E00
;     call disk_read
;     ; TBD: Add error checking here

;     mov si, disk_read_msg
;     ; call put_str

;     jmp S2_LOAD_SEGMENT:S2_LOAD_OFFSET

;     hlt

; ; Reads sectors from a disk
; ; Parameters:
; ;   - ax: LBA address
; ;   - cl: number of sectors to read (up to 128)
; ;   - dl: drive number
; ;   - es:bx: memory address where to store read data
; disk_read:
;     push ax                             ; save registers we will modify
;     push bx
;     push cx
;     push dx
;     push di

;     push cx                             ; temporarily save CL (number of sectors to read)
;     call lba_to_chs                     ; compute CHS
;     pop ax                              ; AL = number of sectors to read

;     mov ah, 02h
;     mov di, 3                           ; retry count

; .retry:
;     pusha                               ; save all registers, we don't know what bios modifies
;     stc                                 ; set carry flag, some BIOS'es don't set it
;     int 13h                             ; carry flag cleared = success
;     jnc .done                           ; jump if carry not set

;     ; read failed
;     popa
;     call disk_reset

;     dec di
;     test di, di
;     jnz .retry

; .fail:
;     jmp report_error

; .done:
;     popa

;     pop di
;     pop dx
;     pop cx
;     pop bx
;     pop ax
;     ret

; disk_reset:
;     pusha

;     mov ah, 0
;     stc
;     int 13h
;     jc report_error
;     popa
;     ret

; report_error:
;     mov si, error_message
;     ; call put_str

;     jmp $

; ;
; ; Converts an LBA address to a CHS address
; ; Parameters:
; ;   - ax: LBA address
; ; Returns:
; ;   - cx [bits 0-5]:  sector number
; ;   - cx [bits 6-15]: cylinder
; ;   - dh: head
; ;

; lba_to_chs:
;     push ax
;     push dx

;     xor dx, dx                          ; dx = 0
;     div word [bdb_sectors_per_track]    ; ax = LBA / SectorsPerTrack
;                                         ; dx = LBA % SectorsPerTrack
;     inc dx                              ; dx = (LBA % SectorsPerTrack + 1) = sector
;     mov cx, dx                          ; cx = sector

;     xor dx, dx                          ; dx = 0
;     div word [bdb_heads]                ; ax = (LBA / SectorsPerTrack) / Heads = cylinder
;                                         ; dx = (LBA / SectorsPerTrack) % Heads = head
;     mov dh, dl                          ; dh = head
;     mov ch, al                          ; ch = cylinder (lower 8 bits)
;     shl ah, 6
;     or cl, ah                           ; put upper 2 bits of cylinder in CL

;     pop ax
;     mov dl, al                          ; restore DL
;     pop ax
;     ret

; %include "boot_utils_16.S"

; disk_read_msg: db "Disk read sucessfully.", ENDL
; error_message: db "Error reading disk.", ENDL

times (510 - ($ - $$)) db 0
dw 0xAA55

