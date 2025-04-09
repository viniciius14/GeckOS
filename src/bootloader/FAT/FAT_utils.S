%ifndef __FAT_UTILS_S
%define __FAT_UTILS_S

; Find a file in a FAT filesystem
; Inputs:
;   SI = pointer to 11-byte filename
; Outputs:
;   AX = starting cluster (if found)
;   ZF = 1 if not found, 0 if found
FAT_find_file:
    mov ax, [BPB_FATSz16]       ; ax = sectors per FAT
    mov bl, [BPB_NumFATs]       ; number of FATs (usually 2)
    xor bh, bh
    mul bx                      ; ax = (number of FATs *  sectors per FAT)
    add ax, [BPB_RsvdSecCnt]    ; add reserved sectors
    push ax                     ; save the root directory LBA

.compute_size_root_dir:
    mov ax, [BPB_RootEntCnt]    ; number of root entries
    shl ax, 5                   ; 32 bytes per entry -> multiply by 32
    xor dx, dx
    div word [BPB_BytsPerSec]   ; divide by bytes per sector -> gives number of sectors
    test dx, dx
    jz .read_root_dir

    inc ax                      ; if there's a remainder, add 1 more sector

.read_root_dir:
    mov cl, al                  ; cl = sector count
    pop ax                      ; ax = root directory LBA
    mov dl, [BS_DrvNum]         ; dl = boot drive
    mov bx, ROOT_DIR_BUFFER     ; es:bx points to destination
    call BIOS_read
    xor bx, bx
    mov di, ROOT_DIR_BUFFER

.search_file:
    mov cx, 11
    push di
    repe cmpsb                  ; compare file names
    pop di
    je .found_file

    add di, 32                  ; move to next directory entry
    inc bx
    cmp bx, [BPB_RootEntCnt]    ; keep looping until all entries checked
    jl .search_file

    ret                         ; in case no entry is found

.found_file:
    mov ax, [di + 26]           ; get the file's starting cluster
    mov [current_cluster], ax
    ret


; Inputs:
;   AX = starting cluster
;   DS:Si = memory address to load file
;   DL = drive number (BIOS drive number)
; Returns:
;   File loaded into memory at ES:BX
;   ZF = 0 on success, 1 on early EOF or error
;   AX = last valid cluster
FAT_load_file:
    mov ax, [BPB_RsvdSecCnt]    ; FAT starts after reserved sectors
    mov bx, FAT_BUFFER          ; Buffer for the FAT
    mov cl, [BPB_FATSz16]       ; Sectors per FAT
    mov dl, [BS_DrvNum]         ; Drive number
    call BIOS_read

.read_file_loop:
    mov ax, [current_cluster]
    add ax, 31                  ; ! calculate LBA (hacky: hardcoded offset)
    mov cl, 1
    mov dl, [BS_DrvNum]

    ; Set ES:BX to point to DS:SI so BIOS_read loads to that address
    push ds
    pop es
    mov bx, si
    call BIOS_read

    add bx, [BPB_BytsPerSec]

.find_next_cluster:
    mov ax, [current_cluster]
    mov cx, 3
    mul cx
    mov cx, 2
    div cx                      ; ax = index, dx = cluster mod 2
    mov si, FAT_BUFFER
    add si, ax
    mov ax, [ds:si]

    or dx, dx
    jz .even
.odd:
    shr ax, 4
    jmp .next_cluster

.even:
    and ax, 0x0FFF

.next_cluster:
    cmp ax, 0xFF8
    jae .read_finish

    mov [current_cluster], ax
    jmp .read_file_loop

.read_finish:
    ret

%endif
