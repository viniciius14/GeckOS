[bits 16]
[org 0x7C00]

; Compilation safety checks

; Check if no FAT type is defined
%ifndef FAT_12
    %ifndef FAT_16
        %ifndef FAT_32
            %error "No FAT type defined."
        %endif
    %endif
%endif

; Check if multiple FAT types are defined
%ifdef FAT_12
    %ifdef FAT_16
        %error "Too many FAT types defined."
    %endif
    %ifdef FAT_32
        %error "Too many FAT types defined."
    %endif
%elifdef FAT_16
    %ifdef FAT_32
        %error "Too many FAT types defined."
    %endif
%endif

; %ifndef RESERVED_SECTORS
;     %error "RESERVED_SECTORS is undefined."
; %endif

; %if RESERVED_SECTORS <= 1
;     %error "Invalid value for RESERVED_SECTORS."
; %endif

; TODO: Check the following values:
;   - BPB_SecPerTrk
;   - BPB_NumHeads
;   - BPB_HiddSec


; BIOS Parameter Block

jmp short _stage1_start
nop
BS_OEMName:                 db "MSWIN4.1"               ; OEM Name Identifier. 8 bytes.

%ifdef FAT_12
    BPB_BytsPerSec:         dw 512                      ; Count of bytes per sector. Acceptable values: 512, 1024, 2048 or 4096.
    BPB_SecPerClus:         db 0x1                      ; Number of sectors per allocation unit.
    BPB_RsvdSecCnt:         dw 0x1                      ; Number of reserved sectors in the reserved region of the volume starting at the first sector of the volume.
    BPB_NumFATs:            db 0x2                      ; The count of file allocation tables (FATs) on the volume.
    BPB_RootEntCnt:         dw 0xE0                     ; For FAT12 volumes, this field contains the count of 32-byte directory entries in the root directory.
    BPB_TotSec16:           dw 2880                     ; For FAT12 volumes, this field contains the sector count.
    BPB_Media:              db 0xF0                     ; For removable media, 0xF0 is frequently used.
    BPB_FATSz16:            dw 0x9                      ; This field is the FAT12 16-bit count of sectors occupied by one FAT.
    BPB_SecPerTrk:          dw 18                       ; Sectors per track for interrupt 0x13.
    BPB_NumHeads:           dw 2                        ; Number of heads for interrupt 0x13.
    BPB_HiddSec:            dd 0x0                      ; Count of hidden sectors preceding the partition that contains this FAT volume.
    BPB_TotSec32:           dd 0x0                      ; For FAT12 volumes, this field contains the sector count if BPB_TotSec16 is 0.
%endif

%ifdef FAT_16
    BPB_BytsPerSec:         dw 512                      ; Count of bytes per sector. Acceptable values: 512, 1024, 2048 or 4096.
    BPB_SecPerClus:         db 0x1                      ; Number of sectors per allocation unit.
    BPB_RsvdSecCnt:         dw 0x1                      ; Number of reserved sectors in the reserved region of the volume starting at the first sector of the volume.
    BPB_NumFATs:            db 0x2                      ; The count of file allocation tables (FATs) on the volume.
    BPB_RootEntCnt:         dw 0x200                    ; For maximum compatibility, FAT16 volumes should use the value 512.
    BPB_TotSec16:           dw 2880                     ; For FAT16 volumes, this field contains the sector count.
    BPB_Media:              db 0xF8                     ; 0xF8 is the standard value for “fixed” (non-removable) media.
    BPB_FATSz16:            dw 0x0                      ; This field is the FAT16 16-bit count of sectors occupied by one FAT.
    BPB_SecPerTrk:          dw 18                       ; Sectors per track for interrupt 0x13.
    BPB_NumHeads:           dw 2                        ; Number of heads for interrupt 0x13.
    BPB_HiddSec:            dd 0x0                      ; Count of hidden sectors preceding the partition that contains this FAT volume.
    BPB_TotSec32:           dd 0x0                      ; For FAT16 volumes, this field contains the sector count if BPB_TotSec16 is 0.
%endif

%ifdef FAT_32
    BPB_BytsPerSec:         dw 512                      ; Count of bytes per sector. Acceptable values: 512, 1024, 2048 or 4096.
    BPB_SecPerClus:         db 0x1                      ; Number of sectors per allocation unit.
    BPB_RsvdSecCnt:         dw 0x1                      ; Number of reserved sectors in the reserved region of the volume starting at the first sector of the volume.
    BPB_NumFATs:            db 0x2                      ; The count of file allocation tables (FATs) on the volume.
    BPB_RootEntCnt:         dw 0x0                      ; For FAT32 volumes, this field must be set to 0.
    BPB_TotSec16:           dw 0x0                      ; For FAT32 volumes, this field must be 0.
    BPB_Media:              db 0xF8                     ; 0xF8 is the standard value for “fixed” (non-removable) media.
    BPB_FATSz16:            dw 0x0                      ; On FAT32 volumes this field must be 0, and BPB_FATSz32 contains the FAT size count.
    BPB_SecPerTrk:          dw 18                       ; Sectors per track for interrupt 0x13.
    BPB_NumHeads:           dw 0x2                      ; Number of heads for interrupt 0x13.
    BPB_HiddSec:            dd 0x0                      ; Count of hidden sectors preceding the partition that contains this FAT volume.
    BPB_TotSec32:           dd 0x0                      ; For FAT32 volumes, this field must be non-zero.

%endif

; Extended BPB structure

%ifdef FAT_12
    BS_DrvNum:              db 0x0                      ; Interrupt 0x13 drive number. 0x00 -> floppy.
    BS_Reserved1:           db 0x0                      ; Reserved.
    BS_BootSig:             db 0x29                     ; Extended boot signature, indicates that the following three fields in the boot sector are present.
    BS_VolID:               db 0x12, 0x34, 0x56, 0x78   ; Volume serial number.
    BS_VolLab:              db "GECKOS     "            ; Volume label. This field matches the 11-byte volume label recorded in the root directory.
    BS_FilSysType:          db "FAT12   "               ; FAT type. 8 bytes, padded with spaces.
%endif

%ifdef FAT_16
    BS_DrvNum:              db 0x80                     ; Interrupt 0x13 drive number. 0x80 -> hdd.
    BS_Reserved1:           db 0x0                      ; Reserved.
    BS_BootSig:             db 0x29                     ; Extended boot signature, indicates that the following three fields in the boot sector are present.
    BS_VolID:               db 0x12, 0x34, 0x56, 0x78   ; Volume serial number.
    BS_VolLab:              db "GECKOS     "            ; Volume label. This field matches the 11-byte volume label recorded in the root directory.
    BS_FilSysType:          db "FAT16   "               ; FAT type. 8 bytes, padded with spaces.
%endif

%ifdef FAT_32
    BPB_FATSz32:            dd 10   ; This field is the FAT32 32-bit count of sectors occupied by one FAT.
    BPB_ExtFlags:           dw ((1 << 7) | 1)           ; Zero-based number of active FAT. Only valid if mirroring is disabled.
    BPB_FSVer:              dw 0x0                      ; This is the version number of the FAT32 volume. Must be set to 0x0.
    BPB_RootClus:           dd 0x2                      ; This is set to the cluster number of the first cluster of the root directory.
    BPB_FSInfo:             dw 0x1                      ; Sector number of FSINFO structure in the reserved area of the FAT32 volume. Usually 1.
    BPB_BkBootSec:          dw 0x0                      ; If non-zero, indicates the sector number in the reserved area of the volume of a copy of the boot record.
    BPB_Reserved:           dd 0x0, 0x0, 0x0            ; Reserved. Must be set to 0x0.
    BS_DrvNum:              db 0x80                     ; Interrupt 0x13 drive number. 0x80 -> hdd.
    BS_Reserved1:           db 0x0                      ; Reserved. Set value to 0x0.
    BS_BootSig:             db 0x29                     ; Extended boot signature. Set value to 0x29 if either of the following two fields are non-zero
    BS_VolID:               db 0x12, 0x34, 0x56, 0x78   ; Volume serial number.
    BS_VolLab:              db "GECKOS     "            ; Volume label. This field matches the 11-byte volume label recorded in the root directory.
    BS_FilSysType:          db "FAT32   "               ; This string is informational only and does not determine the FAT type.
%endif
