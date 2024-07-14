dd if=/dev/zero of=bin/main_floppy.img bs=512 count=2880
mkfs.fat -F 12 -n "GECKOS" bin/main_floppy.img
dd if=bin/MyOS.bin of=bin/main_floppy.img conv=notrunc
# mcopy -i bin/main_floppy.img test.txt "::test.txt"

# qemu-system-x86_64 -drive format=raw,file=bin/boot.iso,index=0,if=floppy -m 128M

qemu-system-x86_64 -drive format=raw,file=bin/main_floppy.img,index=0,if=floppy