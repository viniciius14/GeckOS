include $(CONFIG_PATH)

# Targets
FAT_12=$(BUILD)/GeckOS_FAT12.img
FAT_16=$(BUILD)/GeckOS_FAT16.img
FAT_32=$(BUILD)/GeckOS_FAT32.img

BOOT_SUBDIRS=$(shell find $(BOOT_DIR) -mindepth 1 -type d)
BOOT_INCLUDES=$(foreach dir, $(BOOT_SUBDIRS), -i $(dir))

ASM_FLAGS=-f bin

all: stage1_boot boot_img

stage1_boot:
	@echo "\nStage 1 Bootloader\n"
	$(ASM) $(ASM_FLAGS)	stage1.S      					-DFAT_12	$(BOOT_INCLUDES)	-o $(BIN)/boot_FAT12.bin
	$(ASM) $(ASM_FLAGS)	stage1.S      					-DFAT_16	$(BOOT_INCLUDES)	-o $(BIN)/boot_FAT16.bin
	$(ASM) $(ASM_FLAGS)	stage1.S      					-DFAT_32	$(BOOT_INCLUDES)	-o $(BIN)/boot_FAT32.bin
	$(ASM) $(ASM_FLAGS)	$(BOOT_DIR)/FAT/FSInfo_FAT32.S	-DFAT_32	$(BOOT_INCLUDES)	-o $(BIN)/FSInfo_FAT32.bin
	$(ASM) $(ASM_FLAGS)	../stage2boot/stage2.S 					    $(BOOT_INCLUDES)	-o $(BIN)/boot2.bin

boot_img: $(FAT_12) $(FAT_16) $(FAT_32)

$(FAT_12):
	@echo "\nFAT_12\n"
	dd if=/dev/zero 				of=$(FAT_12) 	bs=512 			count=2880
	mkfs.fat $(FAT_12) -F 12 -a -S 512 -s 1 -r 224 -R 1
	dd if=$(BIN)/boot_FAT12.bin		of=$(FAT_12) 	bs=512 	seek=0 	conv=notrunc
	mcopy -i $(FAT_12) $(BIN)/boot2.bin ::
	mcopy -i $(FAT_12) $(OS_FILES)/test.txt ::


$(FAT_16):
	@echo "\nFAT_16\n"
	dd if=/dev/zero 				of=$(FAT_16)	bs=512 			count=273042
	mkfs.fat $(FAT_16) -F 16 -a -S 512 -s 8 -r 512 -R 4
	dd if=$(BIN)/boot_FAT16.bin		of=$(FAT_16) 	bs=512 	seek=0 	conv=notrunc
	mcopy -i $(FAT_16) $(OS_FILES)/test.txt ::

$(FAT_32):
	@echo "\nFAT_32\n"
	dd if=/dev/zero 				of=$(FAT_32) 	bs=512 			count=273042
	mkfs.fat $(FAT_32) -F 32 -a -S 512 -s 4 -R 32
	dd if=$(BIN)/boot_FAT32.bin		of=$(FAT_32) 	bs=512	seek=0	conv=notrunc
# Add file system information structure
	dd if=$(BIN)/FSInfo_FAT32.bin 	of=$(FAT_32) 	bs=512 	seek=1	conv=notrunc
# Add copy of bootsector
	dd if=$(BIN)/boot_FAT32.bin		of=$(FAT_32) 	bs=512 	seek=6	conv=notrunc
# Add copy of system information structure
	dd if=$(BIN)/FSInfo_FAT32.bin 	of=$(FAT_32) 	bs=512 	seek=7	conv=notrunc
	mcopy -i $(FAT_32) $(OS_FILES)/test.txt ::

.PHONY: all
