# Directories
PWD=${shell pwd}
BIN=$(PWD)/bin

# Additional variables
# Device to be booted from
BOOT_DEV?=floppy

# List of supported media types
MEDIA_LIST=floppy hdd #cd usb etc
MEDIA_LIST:=$(filter-out $(BOOT_DEV),$(MEDIA_LIST))

# Extend this for all the media types in media list
ifeq ($(BOOT_DEV), floppy)
# Location of the header.S file corresponding to the current FILESYSTEM
    HEADER_LOCATION=$(PWD)/src/filesystems/FAT/
	FILESYSTEM=FAT_12
endif
ifeq ($(BOOT_DEV), hdd)
# Location of the header.S file corresponding to the current FILESYSTEM
    HEADER_LOCATION=$(PWD)/src/filesystems/FAT/
	FILESYSTEM=FAT_12
endif

.PHONY: all bin media run

all: bin media run


bin:
	mkdir -p bin

media: GeckOS
#foreach in media list create virtual HW for it

ifeq ($(BOOT_DEV),floppy)
# Create virtual floppy disk
	dd if=/dev/zero of=$(BIN)/GeckOS.img bs=512 count=2880
	mkfs.fat $(BIN)/GeckOS.img -F 12 -n "GECKOS" -R $(strip $(RESERVED_SECTORS))
	dd if=$(BIN)/GeckOS.bin of=$(BIN)/GeckOS.img bs=512 seek=0 conv=notrunc
endif


GeckOS: kernel bootloader
	cat $(BIN)/bootloader.bin $(BIN)/kernel.bin > $(BIN)/GeckOS.bin


kernel: drivers
	$(MAKE) -C src/kernel PWD=$(PWD)


bootloader:
	$(MAKE) -C src/bootloader PWD=$(PWD) HEADER_LOCATION=$(HEADER_LOCATION)


drivers:
	$(MAKE) -C src/drivers PWD=$(PWD)

run:
ifeq ($(BOOT_DEV), hdd)
	qemu-system-x86_64 -hda disk.img -device ide-hd,drive=disk -drive file=disk.img,format=raw,id=disk
# for each in media list attach it here somehow
endif
	qemu-system-x86_64 -drive file=$(BIN)/GeckOS.img,format=raw,index=0,if=$(BOOT_DEV) -m 128M -serial stdio

clean:
	rm -rf $(BIN)/*


define BOOT_S2_SECTORS
	$(shell echo $$((($$(stat -c%s $(BIN)/stage2.bin) + 511) / 512)))
endef

define KERNEL_SECTORS
	$(shell echo $$((($$(stat -c%s $(BIN)/kernel.bin) + 511) / 512)))
endef

define RESERVED_SECTORS
	$(shell expr $(KERNEL_SECTORS) + $(BOOT_S2_SECTORS) + 1)
endef