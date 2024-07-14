# Standalone, Stage 1 of the Bootloader
nasm -f bin src/boot_sectors/FS_FAT12.S -o bin/boot_sector.bin
nasm -f elf64 src/bootloader/bootloader.S -i src/kernel/ -o bin/bootloader.o
nasm -f elf64 src/kernel/kernel.S -o bin/kernel.o

# ld -m elf_x86_64 -T misc/linker.ld bin/bootloader.o bin/kernel.o -o bin/kernel.bin


ld -m elf_x86_64 -T misc/linker.ld  bin/bootloader.o bin/kernel.o -o bin/kernel.bin --oformat binary

# This section will create the kernel.bin which consists of:
# Stage 2 of the Bootloader
# nasm -f elf64 src/bootloader/bootloader.S -I src/kernel -o bin/boot.o
# # Kernel start
# nasm -f elf64 src/kernel/kernel.S -o bin/kernel.o

# ld -T misc/linker.ld bin/boot.o bin/kernel.o -o boot.bin


# nasm -f elf64 src/filesystem/FAT/disk.S            -o bin/disk.o
# nasm -f elf64 src/bootloader/string.S              -o bin/string.o


dd if=/dev/zero of=bin/main_floppy.img bs=512 count=2880
mkfs.fat -F 12 -n "GECKOS" bin/main_floppy.img

dd if=bin/boot_sector.bin of=bin/main_floppy.img conv=notrunc       # Set boot sector as the "base" of the OS

mcopy -i bin/main_floppy.img bin/kernel.bin "::kernel.bin"          # Add bootloader (stage 2)
# mcopy -i bin/main_floppy.img bin/kernel.bin "::kernel.bin"          # Add kernel
mcopy -i bin/main_floppy.img test.txt "::test.txt"                  # Add test TXT file

qemu-system-x86_64 -drive format=raw,file=bin/main_floppy.img,index=0,if=floppy # Emulate