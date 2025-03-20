# Root Makefile
include misc/config.mk

# Define the path to config.mk
export CONFIG_PATH := $(PWD)/misc/config.mk

export FS ?= FAT32
export BITS ?= BITS64

FS_TYPES := FAT12 FAT16 FAT32
ARCHS_BITS := BITS32 BITS64

# Current target
TARGET=$(BUILD)/GeckOS_$(FS)_$(BITS).img


default: bootloader kernel image


all:
	@for fs in $(FS_TYPES); do \
		for arch in $(ARCHS_BITS); do \
			echo "\nBuilding GeckOS_$$fs\_$$arch.img...\n"; \
			$(MAKE) FS=$$fs BITS=$$arch default; \
		done \
	done


bootloader:
	make -C $(BOOT_DIR)


kernel:
	make -C $(KERNEL_DIR)


image:
	@echo "\nCreating $(TARGET) for $(FS) with $(BITS)...\n"
ifeq ($(FS), FAT12)
	$(MAKE)  FAT_12
else ifeq ($(FS), FAT16)
	$(MAKE)  FAT_16
else ifeq ($(FS), FAT32)
	$(MAKE)  FAT_32
else
	@echo "Error: Invalid FS type $(FS)"
	exit 1
endif


 FAT_12:
	@echo "\nCreating a FAT 12 image -> $(TARGET)\n"
	dd if=/dev/zero                     of=$(TARGET)     bs=512        count=2880
	mkfs.fat $(TARGET) -a -F 12 -S 512 -s 1 -r 224 -R 1
# Add stage1 bootloader
	dd if=$(BOOT_BIN)/stage1_FAT12.bin    of=$(TARGET)     bs=512	seek=0 conv=notrunc
# Add stage 2 bootloader
	mcopy -i $(TARGET) $(BOOT_BIN)/boot2.bin ::
# Add files to the OS
	mcopy -i $(TARGET) $(OS_FILES)/* ::


 FAT_16:
	@echo "\nCreating a FAT 16 image -> $(TARGET)\n"
	dd if=/dev/zero                     of=$(TARGET)     bs=512        count=273042
	mkfs.fat $(TARGET) -a -F 16 -S 512 -s 8 -r 512 -R 4
# Add stage1 bootloader
	dd if=$(BOOT_BIN)/stage1_FAT16.bin    of=$(TARGET)     bs=512 seek=0 conv=notrunc
# Add stage 2 bootloader
	dd if=$(BOOT_BIN)/boot2.bin of=$(TARGET)     bs=512 seek=1 conv=notrunc
# Add files to the OS
	mcopy -i $(TARGET) $(OS_FILES)/* ::


 FAT_32:
	@echo "\nCreating a FAT 32 image -> $(TARGET)\n"
	dd if=/dev/zero                     of=$(TARGET)     bs=512        count=273042
	mkfs.fat $(TARGET) -a -F 32 -S 512 -s 4 -R 32
# Add stage1 bootloader
	dd if=$(BOOT_BIN)/stage1_FAT32.bin    of=$(TARGET)     bs=512	seek=0 conv=notrunc
# Add copy of bootsector (FsInfo struct already comes with the stage1 binary)
	dd if=$(BOOT_BIN)/stage1_FAT32.bin    of=$(TARGET)     bs=512 seek=6 conv=notrunc
# Add stage 2 bootloader
	dd if=$(BOOT_BIN)/boot2.bin of=$(TARGET)     bs=512	seek=2 conv=notrunc
# Add files to the OS
	mcopy -i $(TARGET) $(OS_FILES)/* ::


clean:
	rm -rf build/
	find . -type f -name "*.o" -name "*.elf" -name "*.bin" -delete


.PHONY: all