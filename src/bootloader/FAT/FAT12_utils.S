; Find a file in a FAT filesystem
; Inputs:
;   SI = pointer to 11-byte filename
; Outputs:
;   AX = starting cluster
; Assumptions:
;   Direction flag is cleared
;   DL = Drive Number
FAT_find_file:
; Load the File Allocation Table into memory
    mov ax, [BPB_RsvdSecCnt]    ; ax = File Allocation Table region start sector
    mov cl, [BPB_FATSz16]       ; cl = count of sectors occupied by one FAT
    mov bx, FAT_BUFFER          ; es:bx points to destination
    call BIOS_read

; Find the Root Directory on the disk - only for FAT12 and FAT16
    xor dx, dx
    mov ax, [BPB_RootEntCnt]    ; Count of directory entries in the Root Directory
    mov bx, DIR_ENTRY_SIZE      ; 32 bytes per entry
    mul bx                      ; ax = BPB_RootEntCnt * 32 BYTE
    add ax, [BPB_BytsPerSec]    ; Add the number of bytes per sector (for rounding up purposes later)
    dec ax                      ; ax = (BPB_RootEntCnt * 32 BYTE) + BPB_BytsPerSec -1
    mov bx, [BPB_BytsPerSec]
    div bx                      ; ax = ((BPB_RootEntCnt * 32 BYTE) + BPB_BytsPerSec -1) / BPB_BytsPerSec => Root Directory size
    push ax                     ; Save Root Directory size (in number of sectors)

    xor bx, bx
    mov ax, [BPB_FATSz16]       ; Sectors per FAT
    mov bl, [BPB_NumFATs]       ; Number of FATs
    mul bx                      ; ax = (BPB_NumFATs * BPB_FATSz16) => FAT Region Size
    add ax, [BPB_RsvdSecCnt]    ; ax += ReservedSectorCount => Root Directory start location (For FAT12 & FAT16)

; Load the Root Directory into memory
    pop cx                      ; Save Root Directory size (in number of sectors)
    mov bx, ROOT_DIR_BUFFER
    call BIOS_read

; Find the file in the root directory
    mov di, ROOT_DIR_BUFFER
    mov ax, 1                   ; counter for number of entries checked
.search_file:
    mov cx, FILE_NAME_SIZE
    push di                     ; cmpsb modifies DI so save it
    repe cmpsb                  ; Compares byte at address DS:SI with byte at address ES:DI and sets the status flags accordingly
    pop di
    je .get_start_cluster

    add di, DIR_ENTRY_SIZE      ; move to next directory entry
    inc ax                      ; another entry has been checked
    cmp ax, [BPB_RootEntCnt]    ; keep looping until all entries checked
    jl .search_file

    jmp failure                 ; in case all entries are exausted and the file isn't found

.get_start_cluster:
    mov ax, [di + CLUSTER_LOW_OFFSET]
    print_letter "X"
    ret


; Inputs:
;   AX = starting cluster number
;   ES:BX = memory address to load file
; Assumptions
;   FAT has been loaded into RAM at FAT_BUFFER
;   ES = 0
;   DL = Drive Number
FAT_load_chain:
    print_letter "L"
    mov [currentCluster], ax

; read cluster into memory
    ; ? consider doing xor cx, cx here
    mov cl, [BPB_SecPerClus]
    call BIOS_read
    print_letter "M"

; Update mem address pointed to by ES:BX
    add bx, [BPB_BytsPerSec]    ; assuming Sectors per Cluster will always be 1 for FAT12
    push bx                     ; save memory pointer

; Move to next cluster in the chain
    mov ax, [currentCluster] ; ? can be removed for FAT12
; FAT12 entries are 12-bit values packed together so every two clusters take up 3 bytes, meaning:
;   - If cluster number is even: use low 12 bits
;   - If odd: use high 12 bits (shifted right 4)
    mov bx, 3
    mul bx                      ; ax = currentCluster * 3
    mov bx, 2
    div bx                      ; ax = (currentCluster * 3) / 2 => File Allocation Table offset
    add ax, FAT_BUFFER          ; add base address of FAT
    mov si, ax
    mov ax, [si]                ; read 2 bytes from File Allocation Table offset
    test dx, dx                 ; check division remainder
    jnz .odd                    ; if remainder != 0, jump

.even:
    and ax, 0x0FFF
    jmp .after

.odd:
    shr ax, 4

.after:
    print_letter "N"
; Check current cluster EOF
    ; and ax, 0x0FFF              ; optional
    cmp word ax, 0xFF
    pop bx                      ; get back out memory pointer to restore the stack
    jae .done                   ; if greater than or equal

    print_letter "O"
    mov [currentCluster], ax
    jmp FAT_load_chain

.done:
    print_letter "R"
    ret
