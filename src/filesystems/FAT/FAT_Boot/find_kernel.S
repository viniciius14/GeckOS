%ifndef FIND_KERNEL_S
%define FIND_KERNEL_S
[bits 16]

; [global search_kernel]
; [global buffer]
; [extern report_error]
; [extern disk_read]
SECTION .text

%define KERNEL_LOAD_SEGMENT     0x2000
%define KERNEL_LOAD_OFFSET      0

; %include "boot_utils.S"
search_kernel:
    mov ah, 0x0E
    mov al, 'C'
    int 0x10
    mov si, kernel_bin
    mov cx, 11                          ; compare up to 11 characters
    push di
    repe cmpsb
    pop di
    je .found_kernel

    add di, 32
    inc bx
    cmp bx, [0x7C11]                    ; bdb_dir_entries_count
    jl search_kernel

    ; kernel not found
    jmp report_error

.found_kernel:

    ; di should have the address to the entry
    mov ax, [di + 26]                   ; first logical cluster field (offset 26)
    mov [kernel_cluster], ax

    ; load FAT from disk into memory
    mov ax, [0x7C11]                    ; bdb_reserved_sectors
    mov bx, buffer
    mov cl, [0x7C16]                    ; bdb_sectors_per_fat
    mov dl, [0x7C24]                    ; ebr_drive_number
    call disk_read

    ; read kernel and process FAT chain
    mov bx, KERNEL_LOAD_SEGMENT
    mov es, bx
    mov bx, KERNEL_LOAD_OFFSET

.load_kernel_loop:

    ; Read next cluster
    mov ax, [kernel_cluster]

    ; not nice :( hardcoded value
    add ax, 31                          ; first cluster = (kernel_cluster - 2) * sectors_per_cluster + start_sector
                                        ; start sector = reserved + fats + root directory size = 1 + 18 + 134 = 33
    mov cl, 1
    mov dl, [0x7C24]
    call disk_read

    add bx, [0x7C0B]                    ; (bdb_bytes_per_sector)

    ; compute location of next cluster
    mov ax, [kernel_cluster]
    mov cx, 3
    mul cx
    mov cx, 2
    div cx                              ; ax = index of entry in FAT, dx = cluster mod 2

    mov si, buffer
    add si, ax
    mov ax, [ds:si]                     ; read entry from FAT table at index ax

    or dx, dx
    jz .even

.odd:
    shr ax, 4
    jmp .next_cluster_after

.even:
    and ax, 0x0FFF

.next_cluster_after:
    cmp ax, 0x0FF8                      ; end of chain
    jae .read_finish

    mov [kernel_cluster], ax
    jmp .load_kernel_loop

.read_finish:
    ; jump to our kernel
    mov dl, [0x7C24]                    ; boot device in dl

    mov ax, KERNEL_LOAD_SEGMENT         ; set segment registers
    mov ds, ax
    mov es, ax


; SECTION .rodata
kernel_cluster:         dw  0
kernel_bin:             db  'KERNEL  BIN'
; SECTION .bss
buffer:

%endif