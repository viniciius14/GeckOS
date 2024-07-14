
# Bootloader


nasm -f bin src/filesystems/FAT/FAT_Boot/header.S   -o bin/header.bin
HEADER_SIZE=$(wc -c < "bin/header.bin")
#if DEBUG
echo "Header file is "$HEADER_SIZE "bytes long"
#enfid
nasm -f elf64 src/bootloader/stage1.S -DHEADER_SIZE=$HEADER_SIZE -o bin/stage1.o -i src/filesystems/FAT/FAT_Boot -i src/bootloader
ld -m elf_x86_64 -T misc/_linker.ld bin/stage1.o -o bin/stage1.bin --oformat binary

cat bin/header.bin bin/stage1.bin > bin/bootloader.bin

# ld misc/linker.ld bin/stage1.o bin/header.o -o bin/kernel.bin
dd if=/dev/zero of=bin/GeckOS.img bs=512 count=2880
mkfs.fat -F 12 -n "GECKOS" bin/GeckOS.img
dd if=bin/bootloader.bin of=bin/GeckOS.img conv=notrunc

# mcopy -i bin/GeckOS.img bin/kernel.bin "::kernel.bin"

qemu-system-x86_64 -drive format=raw,file=bin/GeckOS.img,index=0,if=floppy



# usefull commands

# objdump -b binary -m i386:x86-64 -D bin/header.bin