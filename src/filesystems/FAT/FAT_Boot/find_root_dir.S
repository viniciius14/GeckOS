%ifndef FIND_ROOT_DIR_S
%define FIND_ROOT_DIR_S

[bits 16]

; [global fat_root_dir]

; [extern buffer]
; [extern disk_read]

; %include "boot_utils.S"

SECTION .text

fat_root_dir:
    mov ah, 0x0E
    mov al, 'B'
    int 0x10
    ; compute size of root directory = (32 * number_of_entries) / bytes_per_sector
    mov ax, [0x7C11]                    ; bdb_dir_entries_count
    shl ax, 5                           ; ax *= 32
    xor dx, dx                          ; dx = 0
    div word [0x7C0B]                   ; number of sectors we need to read, bdb_bytes_per_sector

    test dx, dx                         ; if dx != 0, add 1
    jz .process_root_dir
    inc ax                              ; division remainder != 0, add 1
                                        ; this means we have a sector only partially filled with entries

.process_root_dir:
    ; read root directory
    mov cl, al                          ; cl = number of sectors to read = size of root directory
    pop ax                              ; ax = LBA of root directory
    mov dl, [0x7C24]                    ; dl = drive number (0x7C24)
    mov bx, buffer                      ; es:bx = buffer
    call disk_read

    ; search for kernel.bin
    xor bx, bx
    mov di, buffer

%endif
