[bits 16]
[org 0x7C00]

section .text

; Set to -1 for error throwing purposes
%ifndef BOOT_2_SECTORS
%define BOOT_2_SECTORS -1
%endif

%ifndef KERNEL_SECTORS
%define KERNEL_SECTORS -1
%endif

%define RESERVED_SECTORS (BOOT_2_SECTORS + KERNEL_SECTORS + 1)


%ifdef DEBUG
jmp short ._debug_start
%else
jmp short _stage1_start
%endif

; FAT Header
nop
; BPB (BIOS Parameter Block)
bdb_oem:                    db 'MSWIN4.1'           ; 8 bytes
bdb_bytes_per_sector:       dw 512
bdb_sectors_per_cluster:    db 1
bdb_reserved_sectors:       dw RESERVED_SECTORS
bdb_fat_count:              db 2
bdb_dir_entries_count:      dw 0xE0
bdb_total_sectors:          dw 2880                 ; 2880 * 512 = 1.44MB
bdb_media_descriptor_type:  db 0xF0                 ; F0 = 3.5" floppy disk
bdb_sectors_per_fat:        dw 9                    ; 9 sectors/fat
bdb_sectors_per_track:      dw 18
bdb_heads:                  dw 2
bdb_hidden_sectors:         dd 0
bdb_large_sector_count:     dd 0

; EBPB (Extended BIOS Parameter Block)
ebr_drive_number:           db 0                    ; 0x00 floppy, 0x80 hdd, useless
                            db 0                    ; reserved
ebr_signature:              db 29h
ebr_volume_id:              db 0x12, 0x34, 0x56, 0x78   ; serial number, value doesn't matter
ebr_volume_label:           db 'GECKOS     '        ; 11 bytes, padded with spaces
ebr_system_id:              db 'FAT12   '           ; 8 bytes

%ifdef FAT_16
    ; TBD: Implement FAT16 specific code
%endif

%ifdef FAT_32
    ; TBD: Implement FAT32 specific code
%endif


%ifdef DEBUG
._debug_start:
    ; TBD: check that dl equals ebr_drive_number
    ; TBD: check that sector count is correct
    ; TBD: check that head count is correct


    ; Since DEBUG mode will create a header only bin
    times (510 - ($ - $$))    db 0
    dw 0xAA55
%endif
