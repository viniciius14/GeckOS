# Root Makefile
include misc/config.mk

# Define the path to config.mk
export CONFIG_PATH := $(PWD)/misc/config.mk

# Targets
FAT_12=$(BUILD)/GeckOS_FAT12.img
FAT_16=$(BUILD)/GeckOS_FAT16.img
FAT_32=$(BUILD)/GeckOS_FAT32.img


all: bootloader kernel image


bootloader:
	make -C $(BOOT_DIR)


kernel:
	make -C $(KERNEL_DIR)


image: FAT_12 FAT_16 FAT_32


FAT_12:
	@echo "\nFAT_12\n"
	dd if=/dev/zero 					of=$(FAT_12) 	bs=512 			count=2880
	mkfs.fat $(FAT_12) -F 12 -a -S 512 -s 1 -r 224 -R 1
# Add stage1 bootloader
	dd if=$(BOOT_BIN)/boot_FAT12.bin	of=$(FAT_12) 	bs=512 	seek=0 	conv=notrunc
# Add stage 2 bootloader
	mcopy -i $(FAT_12) $(BOOT_BIN)/boot2.bin ::
# Add files to the OS
	mcopy -i $(FAT_12) $(OS_FILES)/* ::


FAT_16:
	@echo "\nFAT_16\n"
	dd if=/dev/zero 					of=$(FAT_16)	bs=512 			count=273042
	mkfs.fat $(FAT_16) -F 16 -a -S 512 -s 8 -r 512 -R 4
# Add stage1 bootloader
	dd if=$(BOOT_BIN)/boot_FAT16.bin	of=$(FAT_16) 	bs=512 	seek=0 	conv=notrunc
# Add stage 2 bootloader
	dd if=$(BOOT_BIN)/boot2.bin 		of=$(FAT_16) 	bs=512 	seek=1	conv=notrunc
# Add files to the OS
	mcopy -i $(FAT_16) $(OS_FILES)/* ::


FAT_32:
	@echo "\nFAT_32\n"
	dd if=/dev/zero 					of=$(FAT_32) 	bs=512 			count=273042
	mkfs.fat $(FAT_32) -F 32 -a -S 512 -s 4 -R 32
# Add stage1 bootloader
	dd if=$(BOOT_BIN)/boot_FAT32.bin	of=$(FAT_32) 	bs=512	seek=0	conv=notrunc
# Add copy of bootsector (FsInfo struct already comes with the stage1 binary)
	dd if=$(BOOT_BIN)/boot_FAT32.bin	of=$(FAT_32) 	bs=512 	seek=6	conv=notrunc
# Add stage 2 bootloader
	dd if=$(BOOT_BIN)/boot2.bin 		of=$(FAT_32) 	bs=512 	seek=2	conv=notrunc
# Add files to the OS
	mcopy -i $(FAT_32) $(OS_FILES)/* ::


# Clean target to clean all subdirectories
clean:
# rm -rf build/
# find . -type f -name "*.log" -name "*.out" -name "*.o" -name "*.elf" -name "*.bin" -delete
	find . -type f -name "*.bin" -delete


.PHONY: all
