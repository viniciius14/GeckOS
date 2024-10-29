#!/bin/sh

# For 16-bit code:                          nasm

# For compiling 32-bit code:                i386-elf-gcc
# For linking 32-bit object files:          i386-elf-ld
# For 32-bit binaries:                      i386-elf-objcopy

# For compiling 64-bit code:                x86_64-elf-gcc
# For linking 64-bit object files:          x86_64-elf-ld
# For 64-bit binaries:                      x86_64-elf-objcopy

# Delete the last log file
rm -f misc/build/make.log

# Redirect all output to both the console and make.log
exec > >(tee -a misc/build/make.log) 2>&1

# Variables
KERNEL_SECTORS=-1
BOOT_2_SECTORS=-1
PWD=$(pwd)

SRC="$PWD/src"
INC="$PWD/include"
LINK="$PWD/misc/linker"
FILES="$PWD/misc/osFiles"
BIN="$PWD/bin"


# Functions

get_sectors() {
    local var_name=$1
    local file_path=$2

    # Get the size of the file
    local file_size=$(stat -c %s "$file_path")

    echo "$file_path is $file_size bytes long."

    # Check if we occupy an uneven number of sectors
    if [ $((file_size % 512)) -ne 0 ]; then
        file_size=$(((file_size / 512) + 1))
    else
        file_size=$(((file_size / 512)))
    fi

    echo "$file_path is $file_size sectors long."

    # Assign the value to the variable passed as argument
    eval "$var_name=$file_size"
}

export NO_AT_BRIDGE=1 # Supress a QEMU warning

# Ensure that bin/ exists
mkdir -p $BIN

# --no-warn-rwx-segments          \

# We're gonna compile everything the opposite way around

# Kernel
i386-elf-gcc                        \
    -c $SRC/kernel/kernel_main.c     \
    -I $INC/kernel               \
    -I $INC/drivers/floppy       \
    -o $BIN/_kernel.o                \
    -Wall                           \
    -Wextra                         \
    -m32                            \
    -nostdlib                       \
    -fno-builtin                    \
    -std=c11
    # -mgeneral-regs-only

i386-elf-ld                         \
    $BIN/_kernel.o                   \
    -m elf_i386                     \
    -T $LINK/kernel.ld               \
    -o $BIN/kernel.o

i386-elf-objcopy                    \
    $BIN/kernel.o                    \
    -O binary                       \
    $BIN/kernel.bin

get_sectors KERNEL_SECTORS $BIN/kernel.bin


# Stage 2 Bootloader
nasm                                \
    $SRC/bootloader/stage2.S         \
    -i $SRC/bootloader/              \
    -f elf32                        \
    -o $BIN/_stage2.o

nasm                                \
    $SRC/bootloader/stage2_32.S      \
    -f elf32                        \
    -o $BIN/_stage2_32.o

i386-elf-gcc                        \
    -c $SRC/drivers/floppy/fdc.c     \
    -I $INC/kernel/              \
    -I $INC/drivers/floppy/      \
    -o $BIN/fdc.o                    \
    -Wall                           \
    -Wextra                         \
    -nostdlib                       \
    -fno-builtin                    \
    -std=c11
    # -mgeneral-regs-only

i386-elf-gcc                        \
    -c $SRC/kernel/utils.c           \
    -I $INC/kernel/              \
    -o $BIN/utils.o                  \
    -Wall                           \
    -Wextra                         \
    -nostdlib                       \
    -fno-builtin                    \
    -std=c11
    # -mgeneral-regs-only

i386-elf-gcc                        \
    -c $SRC/kernel/memory.c          \
    -I $INC/kernel/              \
    -o $BIN/memory.o                 \
    -Wall                           \
    -Wextra                         \
    -nostdlib                       \
    -fno-builtin                    \
    -std=c11
    # -mgeneral-regs-only

i386-elf-ld                         \
    $BIN/_stage2.o                   \
    $BIN/_stage2_32.o                \
    $BIN/fdc.o                       \
    $BIN/memory.o                    \
    $BIN/utils.o                     \
    -m elf_i386                     \
    -T $LINK/bootloader.ld           \
    -o $BIN/stage2.o

i386-elf-objcopy                    \
    $BIN/stage2.o                    \
    -O binary                       \
    $BIN/stage2.bin

get_sectors BOOT_2_SECTORS $BIN/stage2.bin


# Stage 1 Bootloader
nasm                                    \
    $SRC/bootloader/stage1.S             \
    -DBOOT_2_SECTORS=$KERNEL_SECTORS    \
    -DKERNEL_SECTORS=$BOOT_2_SECTORS    \
    -i $SRC/filesystems/FAT/FAT_Boot     \
    -i $SRC/bootloader                   \
    -f $BIN                              \
    -o $BIN/stage1.bin


RESERVED_SECTORS=$((KERNEL_SECTORS + BOOT_2_SECTORS + 1))
echo "RESERVED SECTORS = $RESERVED_SECTORS"

# "Join" together all the parts
cat $BIN/stage1.bin $BIN/stage2.bin > $BIN/bootloader.bin
cat $BIN/bootloader.bin $BIN/kernel.bin > $BIN/GeckOS.bin

# Create virtual floppy disk
dd if=/dev/zero of=$BIN/GeckOS.img bs=512 count=2880

mkfs.fat $BIN/GeckOS.img             \
    -F 12                           \
    -n "GECKOS"                     \
    -R $RESERVED_SECTORS

dd if=$BIN/GeckOS.bin of=$BIN/GeckOS.img bs=512 seek=0 conv=notrunc

# Add files
mcopy -i $BIN/GeckOS.img $FILES/test.txt "::test.txt"

# Emulate
qemu-system-x86_64 -drive format=raw,file=$BIN/GeckOS.img,index=0,if=floppy

# Cleanup
# rm -f $BIN/*.bin
# rm -f $BIN/*.tags
# rm -f $BIN/*.elf
# rm -f $BIN/*.o
