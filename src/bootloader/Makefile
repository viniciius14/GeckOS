include $(CONFIG_PATH)

all: bootloader boot_img

bootloader:
	@echo "\t\t  bootloader"
	$(ASM) -f bin stage1.S -i header.S -DFAT_12 -o $(BUILD)/bin/boot_FAT12.bin
	$(ASM) -f bin stage1.S -i header.S -DFAT_16 -o $(BUILD)/bin/boot_FAT16.bin
	$(ASM) -f bin stage1.S -i header.S -DFAT_32 -o $(BUILD)/bin/boot_FAT32.bin
	$(ASM) -f bin FSInfo_FAT32.S       -DFAT_32 -o $(BUILD)/bin/FSInfo_FAT32.bin

boot_img:
	@echo "\t\t FAT_12"
	dd if=/dev/zero of=$(BUILD)/GeckOS_FAT12.img bs=512 count=2880
	mkfs.fat $(BUILD)/GeckOS_FAT12.img -F 12 -n "GECKOS"
	dd if=$(BUILD)/bin/boot_FAT12.bin of=$(BUILD)/GeckOS_FAT12.img bs=512 seek=0 conv=notrunc

	@echo "\t\t FAT_16"
	dd if=/dev/zero of=$(BUILD)/GeckOS_FAT16.img bs=512 count=262144
	mkfs.fat $(BUILD)/GeckOS_FAT16.img -F 16 -n "GECKOS"
	dd if=$(BUILD)/bin/boot_FAT16.bin of=$(BUILD)/GeckOS_FAT16.img bs=512 seek=0 conv=notrunc

	@echo "\t\t FAT_32"
	dd if=/dev/zero of=$(BUILD)/GeckOS_FAT32.img bs=512 count=262144
	mkfs.fat $(BUILD)/GeckOS_FAT32.img -F 16 -n "GECKOS"
	dd if=$(BUILD)/bin/boot_FAT32.bin of=$(BUILD)/GeckOS_FAT32.img bs=512 seek=0 conv=notrunc
# Add file system information structure
	dd if=$(BUILD)/bin/FSInfo_FAT32.bin of=$(BUILD)/GeckOS_FAT32.img bs=512 seek=1 conv=notrunc
# Add reapeated bootsector
	dd if=$(BUILD)/bin/boot_FAT32.bin of=$(BUILD)/GeckOS_FAT32.img bs=512 seek=6 conv=notrunc

.PHONY: all
