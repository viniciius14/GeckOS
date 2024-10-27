# For 16-bit code:                          nasm

# For compiling 32-bit code:                i386-elf-gcc
# For linking 32-bit object files:          i386-elf-ld
# For 32-bit binaries:                      i386-elf-objcopy

# For compiling 64-bit code:                x86_64-elf-gcc
# For linking 64-bit object files:          x86_64-elf-ld
# For 64-bit binaries:                      x86_64-elf-objcopy


# Variables
KERNEL_SECTORS=-1
BOOT_2_SECTORS=-1

# Ensure that bin/ exists
mkdir -p bin/

# --no-warn-rwx-segments          \

# We're gonna compile everything the opposite way around

# Kernel
i386-elf-gcc                        \
    -c src/kernel/kernel_main.c     \
    -I include/kernel               \
    -I include/drivers/floppy       \
    -o bin/_kernel.o                \
    -Wall                           \
    -Wextra                         \
    -m32                            \
    -nostdlib                       \
    -fno-builtin                    \
    -mgeneral-regs-only

i386-elf-ld                         \
    bin/_kernel.o                   \
    -m elf_i386                     \
    -T misc/kernel.ld               \
    -o bin/kernel.o

i386-elf-objcopy                    \
    bin/kernel.o                    \
    -O binary                       \
    bin/kernel.bin

get_sectors KERNEL_SECTORS bin/kernel.bin


# Stage 2 Bootloader
nasm                                \
    src/bootloader/stage2.S         \
    -i src/bootloader/              \
    -f elf32                        \
    -o bin/_stage2.o

nasm                                \
    src/bootloader/stage2_32.S      \
    -f elf32                        \
    -o bin/_stage2_32.o

i386-elf-gcc                        \
    -c src/drivers/floppy/fdc.c     \
    -I include/kernel/              \
    -I include/drivers/floppy/      \
    -o bin/fdc.o                    \
    -Wall                           \
    -Wextra                         \
    -nostdlib                       \
    -fno-builtin                    \
    -mgeneral-regs-only

i386-elf-gcc                        \
    -c src/kernel/utils.c           \
    -I include/kernel/              \
    -o bin/utils.o                  \
    -Wall                           \
    -Wextra                         \
    -nostdlib                       \
    -fno-builtin                    \
    -mgeneral-regs-only

i386-elf-gcc                        \
    -c src/kernel/memory.c          \
    -I include/kernel/              \
    -o bin/memory.o                 \
    -Wall                           \
    -Wextra                         \
    -nostdlib                       \
    -fno-builtin                    \
    -mgeneral-regs-only

i386-elf-ld                         \
    bin/_stage2.o                   \
    bin/_stage2_32.o                \
    bin/fdc.o                       \
    bin/memory.o                    \
    bin/utils.o                     \
    -m elf_i386                     \
    -T misc/bootloader.ld           \
    -o bin/stage2.o

i386-elf-objcopy                    \
    bin/stage2.o                    \
    -O binary                       \
    bin/stage2.bin

get_sectors BOOT_2_SECTORS bin/stage2.bin


# Stage 1 Bootloader
nasm                                    \
    src/bootloader/stage1.S             \
    -DBOOT_2_SECTORS=$KERNEL_SECTORS    \
    -DKERNEL_SECTORS=$BOOT_2_SECTORS    \
    -i src/filesystems/FAT/FAT_Boot     \
    -i src/bootloader                   \
    -f bin                              \
    -o bin/stage1.bin


RESERVED_SECTORS=$((KERNEL_SECTORS + BOOT_2_SECTORS + 1))
echo "RESERVED SECTORS = $RESERVED_SECTORS"

# "Join" together all the parts
cat bin/stage1.bin bin/stage2.bin > bin/bootloader.bin
cat bin/bootloader.bin bin/kernel.bin > bin/GeckOS.bin

# Create virtual floppy disk
dd if=/dev/zero of=bin/GeckOS.img bs=512 count=2880

mkfs.fat bin/GeckOS.img             \
    -F 12                           \
    -n "GECKOS"                     \
    -R $RESERVED_SECTORS

dd if=bin/GeckOS.bin of=bin/GeckOS.img bs=512 seek=0 conv=notrunc

# Add files
mcopy -i bin/GeckOS.img test.txt "::test.txt"

# Emulate
qemu-system-x86_64 -drive format=raw,file=bin/GeckOS.img,index=0,if=floppy

# Cleanup
# rm -f bin/*.bin
# rm -f bin/*.tags
# rm -f bin/*.elf
# rm -f bin/*.o



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
