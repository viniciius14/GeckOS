include $(CONFIG_PATH)

# Targets
FAT_12=$(BUILD)/GeckOS_FAT12.img
FAT_16=$(BUILD)/GeckOS_FAT16.img
FAT_32=$(BUILD)/GeckOS_FAT32.img

# Binaries
FAT_12_BIN=$(BIN)/boot_FAT12.bin
FAT_16_BIN=$(BIN)/boot_FAT16.bin
FAT_32_BIN=$(BIN)/boot_FAT32.bin

ASM_FLAGS=-f bin

all: bootloader boot_img

bootloader: stage1_boot stage2_boot

stage2_boot:
	@echo "\nStage 2 Bootlaoder\n"

stage1_boot:
	@echo "\nStage 1 Bootloader\n"
	$(ASM) $(ASM_FLAGS)	stage1.S        -DFAT_12    -o $(FAT_12_BIN)
	$(ASM) $(ASM_FLAGS)	stage1.S        -DFAT_16    -o $(FAT_16_BIN)
	$(ASM) $(ASM_FLAGS)	stage1.S        -DFAT_32    -o $(FAT_32_BIN)
	$(ASM) $(ASM_FLAGS)	FSInfo_FAT32.S  -DFAT_32    -o $(BIN)/FSInfo_FAT32.bin


boot_img: $(FAT_12) $(FAT_32) $(FAT_16)

$(FAT_12):
	@echo "\nFAT_12\n"
	dd if=/dev/zero 				of=$(FAT_12) 	bs=512 			count=2880
	mkfs.fat $(FAT_12) -F 12 -a -S 512 -s 1 -r 224 -R 1
	dd if=$(FAT_12_BIN)				of=$(FAT_12) 	bs=512 	seek=0 	conv=notrunc
	mcopy -i $(FAT_12) $(MISC)/test.txt ::

$(FAT_16):
	@echo "\nFAT_16\n"
	dd if=/dev/zero 				of=$(FAT_16)	bs=512 			count=273042
	mkfs.fat $(FAT_16) -F 16 -a -S 512 -s 8 -r 512 -R 4
	dd if=$(FAT_16_BIN) 			of=$(FAT_16) 	bs=512 	seek=0 	conv=notrunc
	mcopy -i $(FAT_16) $(MISC)/test.txt ::

$(FAT_32):
	@echo "\nFAT_32\n"
	dd if=/dev/zero 				of=$(FAT_32) 	bs=512 			count=273042
	mkfs.fat $(FAT_32) -F 32 -a -S 512 -s 4 -R 32
	dd if=$(FAT_32_BIN) 			of=$(FAT_32) 	bs=512	seek=0	conv=notrunc
# Add file system information structure
	dd if=$(BIN)/FSInfo_FAT32.bin 	of=$(FAT_32) 	bs=512 	seek=1	conv=notrunc
# Add copy of bootsector
	dd if=$(FAT_32_BIN) 			of=$(FAT_32) 	bs=512 	seek=6	conv=notrunc
# Add copy of system information structure
	dd if=$(BIN)/FSInfo_FAT32.bin 	of=$(FAT_32) 	bs=512 	seek=7	conv=notrunc
	mcopy -i $(FAT_32) $(MISC)/test.txt ::

.PHONY: all
