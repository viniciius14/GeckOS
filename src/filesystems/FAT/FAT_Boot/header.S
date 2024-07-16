[bits 16]
[org 0x7C00]

SECTION .text

; FAT12 header
; %ifdef DEBUG
; jmp short ._debug_start
; %else
jmp short _stage1_start
; %endif
nop

; BPB (BIOS Parameter Block)
bdb_oem:                    db 'MSWIN4.1'           ; 8 bytes
bdb_bytes_per_sector:       dw 512
bdb_sectors_per_cluster:    db 1
bdb_reserved_sectors:       dw 1
bdb_fat_count:              db 2
bdb_dir_entries_count:      dw 0E0h
bdb_total_sectors:          dw 2880                 ; 2880 * 512 = 1.44MB
bdb_media_descriptor_type:  db 0F0h                 ; F0 = 3.5" floppy disk
bdb_sectors_per_fat:        dw 9                    ; 9 sectors/fat
bdb_sectors_per_track:      dw 18
bdb_heads:                  dw 2
bdb_hidden_sectors:         dd 0
bdb_large_sector_count:     dd 0

; EBPB (Extended BIOS Parameter Block)
ebr_drive_number:           db 0                    ; 0x00 floppy, 0x80 hdd, useless
                            db 0                    ; reserved
ebr_signature:              db 29h
ebr_volume_id:              db 12h, 34h, 56h, 78h   ; serial number, value doesn't matter
ebr_volume_label:           db 'GECKOS     '        ; 11 bytes, padded with spaces
ebr_system_id:              db 'FAT12   '           ; 8 bytes

%ifdef FAT_16
    ; TBD: Implement FAT16 specific code
%endif

%ifdef FAT_32
    ; TBD: Implement FAT32 specific code
%endif

; _stage1_start:

%ifdef DEBUG
._debug_start:
    ; TBD: check that dl equals ebr_drive_number
    ; TBD: check that sector count is correct
    ; TBD: check that head count is correct
%endif
