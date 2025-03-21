%ifndef __FAT12_UTILS_S
%define __FAT12_UTILS_S

%include "disk.S"

section .text

loadStage2:
    ; compute LBA of root directory = reserved_sectors + (fats * sectors_per_fat)
    mov ax, [BPB_FATSz16]       ; ax = sectors_per_fat
    mov bl, [BPB_NumFATs]       ; bl = fats
    xor bh, bh
    mul bx                      ; ax = (fats * sectors_per_fat)
    add ax, [BPB_RsvdSecCnt]    ; ax = LBA of root directory
    push ax

    ; compute size of root directory = (32 * number_of_entries) / bytes_per_sector
    mov ax, [BPB_RootEntCnt]
    shl ax, 5
    xor dx, dx                  ; dx might already be 0 here
    div word [BPB_BytsPerSec]
    test dx, dx                 ; if dx != 0, add 1
    jz .root_dir
    inc ax                      ; division remainder != 0, add 1

.root_dir:
    ; read root directory
    mov cl, al                  ; cl = number of sectors to read = size of root directory
    pop ax                      ; ax = LBA of root directory
    mov dl, [BS_DrvNum]         ; dl = drive number (we saved it previously)
    mov bx, buffer              ; es:bx = buffer
    call disk_read

    ; search for stage 2 bootloader
    xor bx, bx
    mov di, buffer

.search_stage2:
    mov si, file_stage2_bin
    mov cx, 11                  ; compare up to 11 characters
    push di
    repe cmpsb
    pop di
    je .found_stage2

    add di, 32                  ; 32 is the size of a directory entry
    inc bx
    cmp bx, [BPB_RootEntCnt]
    jl .search_stage2

    ; not found
    jmp stage2_not_found_error

.found_stage2:
    ; di should have the address to the entry
    mov ax, [di + 26]

    mov [stage2_cluster], ax

    ; load FAT from disk into memory
    mov ax, [BPB_RsvdSecCnt]
    mov bx, buffer
    mov cl, [BPB_FATSz16]
    mov dl, [BS_DrvNum]
    call disk_read

    ; read stage2 and process FAT chain
    mov bx, S2_LOAD_SEGMENT
    mov es, bx
    mov bx, S2_LOAD_OFFSET

.load_stage2_loop:
    ; Read next cluster
    mov ax, [stage2_cluster]

    ; ! not nice :( hardcoded value
    add ax, 31                  ; first cluster = (stage2_cluster - 2) * sectors_per_cluster + start_sector
                                ; start sector = reserved + fats + root directory size = 1 + 18 + 134 = 33
    mov cl, 1
    mov dl, [BS_DrvNum]
    call disk_read

    add bx, [BPB_BytsPerSec]

    ; compute location of next cluster
    mov ax, [stage2_cluster]
    mov cx, 3
    mul cx
    mov cx, 2
    div cx                      ; ax = index of entry in FAT, dx = cluster mod 2

    mov si, buffer
    add si, ax
    mov ax, [ds:si]             ; read entry from FAT table at index ax

    or dx, dx
    jz .even
.odd:
    shr ax, 4
    jmp .next_cluster_after

.even:
    and ax, 0x0FFF

.next_cluster_after:
    cmp ax, 0xFF                ; end of chain
    jae .read_finish
    mov [stage2_cluster], ax
    jmp .load_stage2_loop

.read_finish:
    ; jump to our kernel
    mov dl, [BS_DrvNum]         ; boot device in dl

    mov ax, S2_LOAD_SEGMENT     ; set segment registers
    mov ds, ax
    mov es, ax

    jmp S2_LOAD_SEGMENT:S2_LOAD_OFFSET

    jmp $                       ; should never happen
    cli                         ; disable interrupts
    hlt                         ; this way CPU can't get out of "halt" state

stage2_not_found_error:
    mov si, msg_stage2_not_found
    call puts

file_stage2_bin:        db "STAGE2  BIN"
msg_stage2_not_found:   db "ERROR - STAGE2.BIN NOT FOUND.", ENDL
stage2_cluster:         dw 0

%endif
