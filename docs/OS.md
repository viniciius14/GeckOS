# Full overview (to be later edited)

## Makefile

specifically .S (capital case) because GCC treats the file extensions ".s" (lowercase) and ".S" (uppercase) differently: Uppercase allows pre-processor directives (such as #include or #ifdef), lowercase not. {1}

## Linker

## Bootloader (independent of filesystem)

+----------------------------------------------------------------------------------------------------------------------------------------+
|                                                  Real Mode Address Space (first MiB)                                                   |
+---------+---------+--------------------------------------------------------------------------------------------------------------------+
|  Start  |   End   |    Size    |              Description               |                               Type                           |
+---------+---------+------------+----------------------------------------+--------------------------------------+-----------------------+
| 0x00000 | 0x003FF | 1 KiB      | Real Mode IVT (Interrupt Vector Table) |                                      |                       |
+---------+---------+------------+----------------------------------------+        Unusable in Real Mode         |                       |
| 0x00400 | 0x004FF | 256 Bytes  | BDA (BIOS data area)                   |                                      |                       |
+---------+---------+------------+----------------------------------------+--------------------------------------+                       |
| 0x00500 | 0x07BFF | 30 KiB     | Conventional Memory (1)                |                                      |      640 KiB RAM      |
+---------+---------+------------+----------------------------------------+                                      |      Low Memory       |
| 0x07C00 | 0x07DFF | 512 Bytes  | OS Bootsector                          |            Usable Memory             |                       |
+---------+---------+------------+----------------------------------------+                                      |                       |
| 0x07E00 | 0x7FFFF | 480.5 KiB  | Conventional Memory (2)                |                                      |                       |
+---------+---------+------------+----------------------------------------+--------------------------------------+                       |
| 0x80000 | 0x9FFFF | 128 KiB    | EBDA (Extended BIOS Data Area)         |      Partially used by the EBDA      |                       |
+---------+---------+------------+----------------------------------------+--------------------------------------+-----------------------+
| 0xA0000 | 0xBFFFF | 128 KiB    | Video Display Memory                   |           Hardware Mapped            |                       |
+---------+---------+------------+----------------------------------------+--------------------------------------+                       |
| 0xC0000 | 0xC7FFF | 32 KiB     | Video BIOS                             |                                      |    384 KiB System     |
+---------+---------+------------+----------------------------------------+                                      | Reserved Upper Memory |
| 0xC8000 | 0xEFFFF | 160 KiB    | BIOS Expansions                        | ROM and hardware mapped / Shadow RAM |                       |
+---------+---------+------------+----------------------------------------+                                      |                       |
| 0xF0000 | 0xFFFFF | 64 KiB     | Motherboard BIOS                       |                                      |                       |
+-------------------------------------------------------------------------+--------------------------------------+-----------------------+


## Filesystem

### Filesystem FAT 12

+------------------------------------------------------------------------------+
|                                DISK                                          |
+------------------------------------------------------------------------------+
| Boot   | File       | Root      | Data                                       |
| Record | Allocation | Directory |      +-----------------------------------+ |
|        | Tables     |           |      |            |        |             | |
|        |            |           |      | Bootloader | Kernel | Other Files | |
|        |            |           |      | (Stage 2)  |        |             | |
|        |            |           |      +-----------------------------------+ |
+------------------------------------------------------------------------------+
   1           18          14                                                   Sector
Data region begins at sector 35


The size of our disk is 1.44 MB

#### Boot Record - src/filesystem/FAT_12/boot_sector.s
This section contains FAT12 specific variables and the actual bootloader, it is 512 bytes long and must end in 0xAA55 to be detected as bootable.

The data that isn't code is known as the BPB.
The boot record contains both code and data, mixed together.

So, to avoid trying to execute the data we first write to skip over it (line 4 of boot_sector), and go straight to executing the code.

Our file will call bootloader so that we can ensure that the header info for the filesystem always stays on top


WE need to compile boot_Sector
bootloader needs to be compiled to a bin file because of the \[org] directive
And then compile the other files

boot_Sector + bootloader + all other .o files

#### Capabilities
    create dirs
    delete dirs
    move between dirs
    create files
    delete files
    open files
    get available space

### Filesystem FAT 16

### Filesystem FAT 32

### Filesystem exFAT

### Filesystem NTFS

### Filesystem ext3


## Kernel

### Interrutps
### FPU -- (maybe)

### Keyboard Driver
### Grafical Driver