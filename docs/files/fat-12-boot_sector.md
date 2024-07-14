# 🦎 FAT 12 boot\_sector

The FAT12 filesystem is based on the following structure:



<table><thead><tr><th width="206">Boot Sector</th><th width="200">File Allocation Tables</th><th width="149">Root Directory</th><th>Data</th></tr></thead><tbody><tr><td>Bootloader (Stage 1)</td><td>FAT 1</td><td>File Attributes</td><td>Bootloader (Stage 2)</td></tr><tr><td></td><td>FAT 2</td><td></td><td>Kernel</td></tr><tr><td></td><td></td><td></td><td>Other Files</td></tr></tbody></table>

### Boot Sector

This section contains FAT12 specific data and the actual Bootloader, it's only 512 bytes in size and to mark it as bootable we must end it with 0xAA55.

To avoid executing the FAT12 specific data, the header starts off with a short jump to a label where Stage 1 of our bootloader starts.

#### The Header

Here we define some important parts of our filesystem.&#x20;

```nasm
; FAT12 Header
jmp short start
nop
oem:                    db 'MSWIN4.1'           ; Version of DOS being used
bytes_per_sector:       dw 512                  ; How many bytes per sector
sectors_per_cluster:    db 1                    ; How many sectors per cluster
reserved_sectors:       dw 1                    ; Number of reserved sectors (Boot sector is included here)
fat_count:              db 2                    ; How many file allocation tables
dir_entries_count:      dw 0E0h                 ; How many sectors for the root directory
total_sectors:          dw 2880                 ; How many sectors in total
media_descriptor_type:  db 0F0h                 ; What type of media this is (3.5" floppy disk)
sectors_per_fat:        dw 9                    ; How many sectors per file allocation table
sectors_per_track:      dw 18                   ; How many sectors per track
heads:                  dw 2                    ; Number of heads on the storage media
hidden_sectors:         dd 0                    ; Number of hidden sectors
large_sector_count:     dd 0                    ; Number of large sectors (only set if there are more than 65535 sectors)

; Extended Boot Record
drive_number:           db 0                    ; Drive number, 0 represents floppy
                        db 0                    ; Flags in Windows NT. Reserved otherwise.
signature:              db 29h                  ; Signature must be either 0x28 or 0x29
volume_id:              db 12h, 34h, 56h, 78h   ; Serial number
volume_label:           db 'GECKOS     '        ; Name of the volume, uses 11 bytes and is padded with spaces
system_id:              db 'FAT12   '           ; System Identifier string, uses 11 bytes and is padded with spaces
```

Space Allocation:

* Boot Sector: Sector 0
* File Allocation Tables: Sector 1 - 18
* Root Directory: Sector 19 - 32
* Data: Sector 33 - 2879

This gives us a grand total of ≈1.41 MB, of which ≈1.35 MB is for data storage.

### File Allocation Tables

The file allocation tables tell us where in the data section our file is and where it ends. This is done by writing the number of the sector where the file is and when that sector ends we go to that sectors number index in the file allocation table and see where the next sector is. In case we've reached the end of the file and there are no more sectors to read for that file the FAT will hold a value greater or equal to 0xFF8, lettings us know we've reached the end of that file.

### Root Directory

The root directory holds metadata of the files and directories, such as:

* 8.3 file name, the first 8 characters are for the name and the last 3 are for the file extension
* Attributes of the file (read only, hidden, system, volume\_id, directory, etc)
* Creation time
* Last accessed data
* The high 16 bits of this entry's first cluster number (always 0)
* Last modification time
* Last modification date
* The low 16 bits of this entry's first cluster number
* The size of the file in bytes
