# Stage 1 Bootloader
nasm -f bin src/bootloader/stage1.S -o bin/stage1.bin -i src/filesystems/FAT/FAT_Boot -i src/bootloader
# Stage 2 Bootloader

# Kernel
nasm -f bin src/kernel/kernel.S -o bin/kernel.bin

# Create virtual floppy disk
dd if=/dev/zero of=bin/GeckOS.img bs=512 count=2880
mkfs.fat -F 12 -n "GECKOS" bin/GeckOS.img
dd if=bin/stage1.bin of=bin/GeckOS.img conv=notrunc

# Add kernel to floppy
mcopy -i bin/GeckOS.img bin/kernel.bin "::kernel.bin"

# Emulate
qemu-system-x86_64 -drive format=raw,file=bin/GeckOS.img,index=0,if=floppy

# Cleanup
rm bin/*
