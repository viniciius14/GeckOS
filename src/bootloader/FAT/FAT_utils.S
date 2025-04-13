%ifndef __FAT_UTILS_S
%define __FAT_UTILS_S

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
%ifdef FAT12
    mov cl, [BPB_FATSz16]       ; cl = count of sectors occupied by one FAT
%else
    ; Since each File Allocation Table is too big to be loaded in it's entirety in FAT16 and FAT32 we'll load it only partially
    ; 0x7C00 - STACK_SIZE (+/- 500 bytes) - FAT_BUFFER(0x500) => 0x6C00 / BPB_BytsPerSec => +/- 54 sectors that we can read
    mov cl, 50                  ; load 50 sectors into memory
%endif
    mov bx, FAT_BUFFER          ; es:bx points to destination
    call BIOS_read

; Find the Root Directory on the disk - only for FAT12 and FAT16
%ifndef FAT32
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
    ; push ax                     ; Save Root Directory start location (in number of sectors)
%else
    mov ax, [BPB_RootClus]      ; Cluster number of the first cluster of the root directory.
%endif

; Load the Root Directory into memory
%ifdef FAT32
    mov bx, ROOT_DIR_BUFFER
    call FAT_load_chain         ; Go to the File Allocation Table and load the root dir into memory
%else
    ; pop ax                    ; Root Directory start location (in number of sectors)
    pop cx                      ; Save Root Directory size (in number of sectors)
    mov bx, ROOT_DIR_BUFFER
    call BIOS_read

%endif
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
%ifndef FAT12
    ; sub ax, 2 ; ! im not sure if i believe this
    mov cx, [BPB_SecPerClus]
    mul cx                      ; ax = cluster number * BPB_SecPerClus
    add ax, [dataRegionStart]   ; ax += dataRegionStart => cluster start address (LBA)
%endif
    ; ? consider doing xor cx, cx here
    mov cl, [BPB_SecPerClus]
    call BIOS_read
    print_letter "M"

; Update mem address pointed to by ES:BX
%ifdef FAT12
    add bx, [BPB_BytsPerSec]    ; assuming Sectors per Cluster will always be 1 for FAT12
%else
    mov ax, [BPB_BytsPerSec]
    mov cx, [BPB_SecPerClus]
    mul cx                      ; ax = bytes per cluster
    add bx, ax
%endif
    push bx                     ; save memory pointer

; Move to next cluster in the chain
    mov ax, [currentCluster] ; ? can be removed for FAT12
%ifdef FAT12
; FAT12 entries are 12-bit values packed together so every two clusters take up 3 bytes, meaning:
;   - If cluster number is even: use low 12 bits
;   - If odd: use high 12 bits (shifted right 4)
    mov bx, 3
    mul bx                      ; ax = currentCluster * 3
    mov bx, 2
    div bx                      ; ax = (currentCluster * 3) / 2

    add ax, FAT_BUFFER          ; add base address of FAT
    mov si, ax
    mov ax, [si]                ; read 2 bytes (covers 1.5 bytes entry)

    test dx, dx
    jnz .odd                    ; if remainder != 0, jump

.even:
    and ax, 0x0FFF
    jmp .after
.odd:
    shr ax, 4

.after:
    mov [currentCluster], ax

%else
    mov di, FAT_ENTRY_SIZE      ; 2 for FAT16 and 4 for FAT32
    mul di                      ; ax = starting cluster * FAT_ENTRY_SIZE => Offset of our cluster
    add ax, FAT_BUFFER          ; memory location of our files next cluster in the FAT
%endif
    print_letter "N"

    ; mov si, ax                  ; ax = pointer to File Allocation Table [currentCluster]
    ; mov ax, [si]                ; ax = content of File Allocation Table [currentCluster]
; Check current cluster EOF
%ifdef FAT12
    ; and ax, 0x0FFF              ; optional
    cmp word ax, 0xFF
%else
    and ax, 0xFFFF              ; optional
    cmp word ax, 0xFFF8         ; Since ax can only read 16bits we'll leave it as it for FAT32 aswell
%endif
    pop bx
    jae .done                   ; if greater than or equal
    print_letter "O"
    jmp FAT_load_chain

.done:
    print_letter "R"
    ret



%endif
