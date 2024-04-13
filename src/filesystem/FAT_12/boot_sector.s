%ifdef FS_12

; Include the file system specific boot_sector
%include bootloader.s

; BPB (BIOS Parameter Block)
.Boot_Record:
    jmp short Bootloader
    nop

    oem_id:                 db 'MSWIN4.1'
    bytes_per_sector:       dw 512
    Sectors_per_cluster:    db 1
    reserved_sectors:       dw 1
    fat_count:              db 2
    dir_entries_count:      dw 0E0h
    total_sectors:          dw 2880
    media_descriptor_type:  db 0F0h
    sectors_per_fat:        dw 9
    sectors_per_track:      dw 18
    heads:                  dw 2
    hidden_sectors:         dd 0
    large_sector_count:     dd 0

; EBPB (Extended BIOS Parameter Block)
    drive_number:           db 0
                            db 0        ; reserved
    signature:              db 29h
    volume_id:              db 12h, 34h, 56h, 78h
    volume_label:           db 'geckOS     '
    system_id:              db 'FAT12   '

%endif
