# Directories
PWD=${shell pwd}
SRC=${shell find src -type d}
INC=${shell find include -type d}
BIN=$(PWD)/bin
MISC=$(PWD)/misc


# Tools
ASM=nasm
ASM_FLAGS=-f elf64

CC=x86_64-elf-gcc
CC_FLAGS=-Wall -Wextra -nostdlib -fno-builtin -m64 -ffreestanding -mcmodel=kernel -mno-red-zone -mgeneral-regs-only -std=c11

LD=x86_64-elf-ld
LD_FLAGS=-m elf_x86_64

OBJ=x86_64-elf-objcopy
OBJ_FLAGS=-O binary


# Additional args/variables
# Device to be booted from
BOOT_DEV?=floppy
# List of supported media types
MEDIA_LIST=floppy
MEDIA_LIST:=$(filter-out $(BOOT_DEV),$(MEDIA_LIST))

# Extend this for all the media types in media list
ifeq ($(BOOT_DEV), floppy)
# Location of the header.S file corresponding to the current FILESYSTEM
    HEADER_LOCATION=$(PWD)/src/filesystems/FAT/
	FILESYSTEM=FAT_12
endif

.PHONY: all media GeckOS kernel bootloader boot_stage_2 boot_stage_1 boot_64 boot_32 boot_16

all: bin media run


bin:
	${shell mkdir -p bin}
	$(info MEDIA_LIST = $(MEDIA_LIST))


media: GeckOS
ifeq ($(BOOT_DEV),floppy)
# Create virtual floppy disk
	$(shell dd if=/dev/zero of=$(BIN)/GeckOS.img bs=512 count=2880)
	mkfs.fat $(BIN)/GeckOS.img -F 12 -n "GECKOS" -R $(RESERVED_SECTORS)
	dd if=$(BIN)/GeckOS.bin of=$(BIN)/GeckOS.img bs=512 seek=0 conv=notrunc
endif


GeckOS: kernel bootloader
	$(shell cat $(BIN)/bootloader.bin $(BIN)/kernel.bin > $(BIN)/GeckOS.bin)


bootloader: boot_stage_2 boot_stage_1
	$(shell cat $(BIN)/stage1.bin $(BIN)/stage2.bin > $(BIN)/_bootloader.bin)
	@$(eval padding=$(call calculate_padding,$(BIN)/_bootloader.bin))
	$(info padding = $(padding))
	$(shell dd if=/dev/zero of=$(BIN)/_padding.bin bs=1 count=$(padding))
	$(shell cat $(BIN)/_bootloader.bin $(BIN)/_padding.bin > $(BIN)/bootloader.bin)


boot_stage_2: boot_64 boot_32 boot_16
	$(shell $(LD) $(BIN)/_stage2_16.elf $(BIN)/_stage2_32.elf $(BIN)/_stage2_64.elf \
	$(LD_FLAGS) -T $(MISC)/linker/bootloader.ld -o $(BIN)/stage2.o)
	$(shell $(OBJ) $(BIN)/stage2.o $(OBJ_FLAGS) $(BIN)/stage2.bin)
	@$(eval BOOT_S2_SECTORS=$(strip $(call get_sectors, $(BIN)/stage2.bin)))


boot_64:
# Stage 2 Bootloader (64 bit)
	$(ASM) ${shell find src -name stage2_64.S} \
	-i src/bootloader/ \
	$(ASM_FLAGS) -o $(BIN)/_stage2_64.elf


boot_32:
# Stage 2 Bootloader (32 bit)
	$(ASM) ${shell find src -name stage2_32.S} \
	-i src/bootloader/ \
	$(ASM_FLAGS) -o $(BIN)/_stage2_32.elf


boot_16:
# Stage 2 Bootloader (16 bit)
	$(ASM) ${shell find src -name stage2_16.S} \
	-i src/bootloader/ \
	$(ASM_FLAGS) -o $(BIN)/_stage2_16.elf


boot_stage_1:
	@$(eval RESERVED_SECTORS=$(shell expr $(KERNEL_SECTORS) + $(BOOT_S2_SECTORS) + 1))
# Stage 1 Bootloader
	$(ASM) ${shell find src -name stage1.S} \
	-DRESERVED_SECTORS=$(RESERVED_SECTORS) \
	-i $(HEADER_LOCATION) -i src/bootloader/ \
	-f bin -o $(BIN)/stage1.bin


kernel:
# Place holder for actual kernel
	$(shell dd if=/dev/zero of=$(BIN)/kernel.bin bs=512 count=2)
	@$(eval KERNEL_SECTORS=$(strip $(call get_sectors, $(BIN)/kernel.bin)))
	$(info KERNEL_SECTORS = $(KERNEL_SECTORS))


# media:
# iterate over MEDIA_LIST and then make it virtually and connect it to qemu so we can see it while we run the OS (hopefully)
# find a way to attch the rest of the media to qemu


run:
	qemu-system-x86_64 -drive format=raw,file=bin/GeckOS.img,index=0,if=floppy -m 128M


clean:
	rm -rf $(BIN)/*


# Function definitions
define get_sectors
    $(shell echo $$((($$(stat -c%s $(1)) + 511) / 512)))
endef

define calculate_padding
    $(shell wc -c < $(1) | awk '{print $$1 % 512 == 0 ? 0 : 512 - ($$1 % 512)}')
endef
