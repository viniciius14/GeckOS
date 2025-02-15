[bits 16]
[org 0x7C00]

; %ifndef RESERVED_SECTORS
;     %error "RESERVED_SECTORS is undefined."
; %endif

; %if RESERVED_SECTORS <= 1
;     %error "Invalid value for RESERVED_SECTORS."
; %endif
; BIOS Parameter Block
jmp short _stage1_start
nop
bs_oemname:                 db "MSWIN4.1"               ; OEM Name Identifier. 8 bytes.
bpb_bytspersec:             dw 512                      ; Count of bytes per sector. Acceptable values: 512, 1024, 2048 or 4096.
bpb_secperclus:             db 1                        ; Number of sectors per allocation unit.
bpb_rsvdseccnt:             dw 1                        ; Number of reserved sectors in the reserved region of the volume starting at the first sector of the volume.
bpb_numfats:                db 2                        ; The count of file allocation tables (FATs) on the volume.

%ifdef FAT_12
    bpb_rootentcnt:         dw 0xE0                     ; For FAT12 and FAT16 volumes, this field contains the count of 32-byte directory entries in the root directory.
    bpb_totsec16:           dw 2880                     ; For FAT12 and FAT16 volumes, this field contains the sector count. 2880 * 512 = 1.44MB
%endif

%ifdef FAT_16
    bpb_rootentcnt:         dw 512                      ; For maximum compatibility, FAT16 volumes should use the value 512.
    bpb_totsec16:           dw 2880                     ; For FAT12 and FAT16 volumes, this field contains the sector count. 2880 * 512 = 1.44MB
%endif

%ifdef FAT_32
    bpb_rootentcnt:         dw 0x0                      ; For FAT32 volumes, this field must be set to 0.
    bpb_totsec16:           dw 0x0                      ; For FAT32 volumes, this field must be 0.
%endif

%ifdef FAT_12
    bpb_media:              db 0xF0                     ; For removable media, 0xF0 is frequently used.
%else
    bpb_media:              db 0xF8                     ; 0xF8 is the standard value for “fixed” (non-removable) media.
%endif

%ifdef FAT_32
    bpb_fatsz16:            dw 9                        ; This field is the FAT12/FAT16 16-bit count of sectors occupied by one FAT.
%else
    bpb_fatsz16:            dw 0x0                      ; On FAT32 volumes this field must be 0, and BPB_FATSz32 contains the FAT size count.
%endif

; TODO: Add FAT_12/FAT_16/FAT_32 support for these values

bpb_secpertrk:              dw 18                       ; Sectors per track for interrupt 0x13.
bpb_numheads:               dw 2                        ; Number of heads for interrupt 0x13.
bpb_hiddsec:                dd 0                        ; Count of hidden sectors preceding the partition that contains this FAT volume.

%ifdef FAT_32
    bpb_totsec32:           dd 0                        ; For FAT32 volumes, this field must be non-zero.
%else
    bpb_totsec32:           dd 0                        ; For FAT12/FAT16 volumes, this field contains the sector count if BPB_TotSec16 is 0.
%endif

%ifdef FAT_12
    ; Extended BPB structure for FAT12 volumes
    bs_drvnum:              db 0x0                      ; Interrupt 0x13 drive number. 0x00 -> floppy.
    bs_reserved1:           db 0x0                      ; Reserved.
    bs_bootsig:             db 0x29                     ; Extended boot signature, indicates that the following three fields in the boot sector are present.
    bs_volid:               db 0x12, 0x34, 0x56, 0x78   ; Volume serial number.
    bs_vollab:              db "GECKOS     "            ; Volume label. This field matches the 11-byte volume label recorded in the root directory.
    bs_filsystype:          db "FAT12   "               ; FAT type. 8 bytes, padded with spaces.
%endif

%ifdef FAT_16
    ; Extended BPB structure for FAT16 volumes
    bs_drvnum:              db 0x80                     ; Interrupt 0x13 drive number. 0x80 -> hdd.
    bs_reserved1:           db 0x0                      ; Reserved.
    bs_bootsig:             db 0x29                     ; Extended boot signature, indicates that the following three fields in the boot sector are present.
    bs_volid:               db 0x12, 0x34, 0x56, 0x78   ; Volume serial number.
    bs_vollab:              db "GECKOS     "            ; Volume label. This field matches the 11-byte volume label recorded in the root directory.
    bs_filsystype:          db "FAT16   "               ; FAT type. 8 bytes, padded with spaces.
%endif

%ifdef FAT_32
    ; Extended BPB structure for FAT32 volumes
    BPB_FATSz32:            ; This field is the FAT32 32-bit count of sectors occupied by one FAT.
    BPB_ExtFlags:           dw ((1 << 7) | 1)           ; Zero-based number of active FAT. Only valid if mirroring is disabled.
    BPB_FSVer:              dw 0x0                      ; This is the version number of the FAT32 volume. Must be set to 0x0.
    BPB_RootClus:           dd 0x2                      ; This is set to the cluster number of the first cluster of the root directory.
    BPB_FSInfo:             dw 0x1                      ; Sector number of FSINFO structure in the reserved area of the FAT32 volume. Usually 1.
    BPB_BkBootSec:          dw 0x0                      ; If non-zero, indicates the sector number in the reserved area of the volume of a copy of the boot record.
    BPB_Reserved:           dd 0x0, 0x0, 0x0            ; Reserved. Must be set to 0x0.
    BS_DrvNum:              db 0x80                     ; Interrupt 0x13 drive number. 0x80 -> hdd.
    BS_Reserved1:           db 0x0                      ; Reserved. Set value to 0x0.
    BS_BootSig:             ; Extended boot signature. Set value to 0x29 if either of the following two fields are non-zero
    BS_VolID:               db 0x12, 0x34, 0x56, 0x78   ; Volume serial number.
    BS_VolLab:              db "GECKOS     "            ; Volume label. This field matches the 11-byte volume label recorded in the root directory.
    BS_FilSysType:          db "FAT32   "               ; This string is informational only and does not determine the FAT type.
%endif
