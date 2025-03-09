include $(CONFIG_PATH)

BOOT_SUBDIRS=$(shell find $(BOOT_DIR) -mindepth 1 -type d)
BOOT_INCLUDES=$(foreach dir, $(BOOT_SUBDIRS), -i $(dir))

ASM_FLAGS=-f bin


all: FAT_32_FSInfo

FAT_32_FSInfo:
	$(ASM) $(ASM_FLAGS)	FSInfo_FAT32.S -DFAT_32	$(BOOT_INCLUDES) -o $(BIN)/FSInfo_FAT32.bin