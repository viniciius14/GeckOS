%ifdef FAT32
%ifndef __FAT32_UTILS_S
%define __FAT32_UTILS_S

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
    ; Since each File Allocation Table is too big to be loaded in it's entirety in FAT16 and FAT32 we'll load it only partially
    ; 0x7C00 - STACK_SIZE (+/- 500 bytes) - FAT_BUFFER(0x500) => 0x6C00 / BPB_BytsPerSec => +/- 54 sectors that we can read
    mov cl, 50                  ; load 50 sectors into memory
    mov bx, FAT_BUFFER          ; es:bx points to destination
    call BIOS_read

; Load the Root Directory into memory
    mov ax, [BPB_RootClus]      ; Cluster number of the first cluster of the root directory.
    mov bx, ROOT_DIR_BUFFER
    call FAT_load_chain         ; Go to the File Allocation Table and load the root dir into memory

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
FAT_load_chain:
    print_letter "L"
    mov [currentCluster], ax
; read cluster into memory
    xor cx, cx
    mov cl, [BPB_SecPerClus]
    mul cx                      ; ax = cluster number * BPB_SecPerClus
    add ax, [dataRegionSector]  ; ax += dataRegionSector => cluster start address (LBA)
    xor cx, cx
    mov cl, [BPB_SecPerClus]
    mov dl, [BS_DrvNum]
    call BIOS_read
    print_letter "M"

; Update mem address pointed to by ES:BX
    mov ax, [BPB_BytsPerSec]
    mov cx, [BPB_SecPerClus]
    mul cx                      ; ax = bytes per cluster
    add bx, ax
    push bx                     ; save memory pointer

; Move to next cluster in the chain
    mov ax, [currentCluster]
    mov di, FAT_ENTRY_SIZE      ; 4 for FAT32
    mul di                      ; ax = starting cluster * FAT_ENTRY_SIZE => Offset of our cluster
    add ax, FAT_BUFFER          ; memory location of our files next cluster in the FAT
    print_letter "N"

; Check current cluster EOF
    and ax, 0xFFFF              ; optional
    cmp word ax, 0xFFF8         ; Since ax can only read 16bits we'll leave it as it for FAT32 aswell
    pop bx                      ; get back out memory pointer to restore the stack
    jae .done                   ; if greater than or equal

    print_letter "O"
    mov [currentCluster], ax
    jmp FAT_load_chain

.done:
    print_letter "R"
    ret

%endif
%endif
