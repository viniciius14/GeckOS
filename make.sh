# Make sure bin directory exists
mkdir -p bin/

# Stage 2 Bootloader
nasm src/bootloader/stage2.S        \
    -i src/bootloader/              \
    -f bin                          \
    -o bin/stage2.bin

# Kernel
# nasm src/kernel/kernel.S            \
#     -i src/bootloader/              \
#     -f bin                          \
#     -o bin/kernel.bin

# Get size of Stage 2 Bootloader + kernel to know how many sectors to reserve
STAGE2_SIZE=$(stat -c %s bin/stage2.bin)
KERNEL_SIZE=$(stat -c %s bin/kernel.bin)

echo "Stage 2 size = $STAGE2_SIZE"
echo "Kernel size  = $KERNEL_SIZE"

RSV_SCTRS=$((STAGE2_SIZE + KERNEL_SIZE))

# Check if we ocuppy an uneven number of sectors and add the default reserved sector
if [ $((RSV_SCTRS % 512)) -ne 0 ]; then
    RSV_SCTRS=$(((RSV_SCTRS / 512) + 2))
else
    RSV_SCTRS=$(((RSV_SCTRS / 512) + 1))
fi

echo "Reserved sectors = $RSV_SCTRS"

# Stage 1 Bootloader
nasm src/bootloader/stage1.S        \
    -DRESERVED_SECTORS=$RSV_SCTRS   \
    -i src/filesystems/FAT/FAT_Boot \
    -i src/bootloader               \
    -f bin                          \
    -o bin/stage1.bin

cat bin/stage1.bin bin/stage2.bin > bin/bootloader.bin
# cat bin/bootloader.bin bin/kernel.bin > GeckOS.bin

# Create virtual floppy disk
dd if=/dev/zero of=bin/GeckOS.img bs=512 count=2880

mkfs.fat bin/GeckOS.img             \
    -F 12                           \
    -n "GECKOS"                     \
    -R $RSV_SCTRS

dd if=bin/bootloader.bin of=bin/GeckOS.img bs=512 seek=0 conv=notrunc
# dd if=bin/GeckOS.bin of=bin/GeckOS.img bs=512 seek=0 conv=notrunc

# Add files
mcopy -i bin/GeckOS.img test.txt "::test.txt"

# Emulate
qemu-system-x86_64 -drive format=raw,file=bin/GeckOS.img,index=0,if=floppy

# Cleanup
rm -f bin/*.bin
rm -f bin/*.tags
