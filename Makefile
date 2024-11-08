# Directories
PWD=${shell pwd}
BIN=$(PWD)/bin


# Additional variables

# Device to be booted from
BOOT_DEV?=floppy

# List of supported media types
MEDIA_LIST=floppy #hdd cd usb etc
MEDIA_LIST:=$(filter-out $(BOOT_DEV),$(MEDIA_LIST))

# Extend this for all the media types in media list
ifeq ($(BOOT_DEV), floppy)
# Location of the header.S file corresponding to the current FILESYSTEM
    HEADER_LOCATION=$(PWD)/src/filesystems/FAT/
	FILESYSTEM=FAT_12
endif

.PHONY: all bin media run

all: bin media run


bin:
	mkdir -p bin

media: GeckOS
# iterate over MEDIA_LIST and then make it virtually and connect it to qemu so we can see it while we run the OS (hopefully)
# find a way to attch the rest of the media to qemu
ifeq ($(BOOT_DEV),floppy)
# Create virtual floppy disk
	dd if=/dev/zero of=$(BIN)/GeckOS.img bs=512 count=2880
	mkfs.fat $(BIN)/GeckOS.img -F 12 -n "GECKOS" -R $(shell expr $$(wc -c < bin/GeckOS.bin) / 512)
	dd if=$(BIN)/GeckOS.bin of=$(BIN)/GeckOS.img bs=512 seek=0 conv=notrunc
endif

GeckOS: kernel bootloader
	cat $(BIN)/bootloader.bin $(BIN)/kernel.bin > $(BIN)/GeckOS.bin

kernel:
	$(MAKE) -C src/kernel PWD=$(PWD)

bootloader:
	$(MAKE) -C src/bootloader PWD=$(PWD) HEADER_LOCATION=$(HEADER_LOCATION)

run:
	qemu-system-x86_64 -drive file=$(BIN)/GeckOS.img,format=raw,index=0,if=$(BOOT_DEV) -m 128M -serial stdio

clean:
	rm -rf $(BIN)/*
