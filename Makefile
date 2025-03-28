include misc/config.mk

# Define the path to config.mk
export CONFIG_PATH := $(PWD)/misc/config.mk

export FS ?= FAT12
export BITS ?= BITS32

FS_TYPES := FAT12 FAT16 FAT32
ARCHS_BITS := BITS32 BITS64

# Current target
TARGET=$(BUILD_DIR)/GeckOS_$(FS)_$(BITS).img


default: kernel bootloader image


all: clean
	@for fs in $(FS_TYPES); do \
		for arch in $(ARCHS_BITS); do \
			echo "\nBuilding GeckOS_$${fs}_$${arch}.img...\n"; \
			$(MAKE) FS=$$fs BITS=$$arch default; \
		done \
	done


kernel:
	make -C $(KERNEL_DIR)


bootloader:
	make -C $(BOOT_DIR)


image:
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
	@echo "\nCreating FAT 12 image -> $(TARGET) with 1.44MB\n"
	dd if=/dev/zero                         of=$(TARGET)     bs=512        count=2880
	mkfs.fat $(TARGET) -a -F 12 -S 512 -s 1 -r 224 -R 1
# Add stage1 bootloader
	dd if=$(BOOT_BIN)/stage1_FAT12.bin      of=$(TARGET)     bs=512	seek=0 conv=notrunc
# Add stage2 bootloader
	mcopy -i $(TARGET) $(BOOT_BIN)/stage2.bin ::
# Add files to the OS
	mcopy -i $(TARGET) $(OS_FILES)/* ::


FAT_16:
	@echo "\nCreating FAT 16 image -> $(TARGET) with 128MB\n"
	dd if=/dev/zero                         of=$(TARGET)     bs=512        count=273042
	mkfs.fat $(TARGET) -a -F 16 -S 512 -s 8 -r 512 -R 4
# Add stage1 bootloader
	dd if=$(BOOT_BIN)/stage1_FAT16.bin      of=$(TARGET)     bs=512 seek=0 conv=notrunc
# Add stage2 bootloader
	dd if=$(BOOT_BIN)/stage2.bin            of=$(TARGET)     bs=512 seek=1 conv=notrunc
# Add files to the OS
	mcopy -i $(TARGET) $(OS_FILES)/* ::


FAT_32:
	@echo "\nCreating FAT 32 image -> $(TARGET) with 128MB\n"
	dd if=/dev/zero                         of=$(TARGET)     bs=512        count=273042
	mkfs.fat $(TARGET) -a -F 32 -S 512 -s 4 -R 32
# Add stage1 bootloader
	dd if=$(BOOT_BIN)/stage1_FAT32.bin      of=$(TARGET)     bs=512	seek=0 conv=notrunc
# Add copy of bootsector (FsInfo struct already comes with the stage1 binary)
	dd if=$(BOOT_BIN)/stage1_FAT32.bin      of=$(TARGET)     bs=512 seek=6 conv=notrunc
# Add stage2 bootloader
	dd if=$(BOOT_BIN)/stage2.bin            of=$(TARGET)     bs=512	seek=2 conv=notrunc
# Add files to the OS
	mcopy -i $(TARGET) $(OS_FILES)/* ::


run: default
ifeq ($(FS), FAT12)
	$(MAKE)  run_floppy
else
	$(MAKE)  run_hard_disk
endif


run_floppy:
	$(EMULATOR) -drive file=$(TARGET),format=raw,index=0,if=floppy $(EMUL_FLAGS)


run_hard_disk:
	$(EMULATOR) -drive file=$(TARGET),format=raw,index=0,if=ide $(EMUL_FLAGS)


clean:
	clear
	rm -rf build/
	find . -type f -name "*.o" -name "*.elf" -name "*.bin" -delete


.PHONY: all
