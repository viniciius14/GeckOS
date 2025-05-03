include $(CONFIG_PATH)

KERNEL_SUBDIRS = $(shell find $(SRC_DIR) -mindepth 1 -type d)
export KERNEL_INCLUDES = $(foreach dir, $(KERNEL_SUBDIRS), -I $(dir))


kernel:
	$(foreach subdir, $(shell find . -mindepth 2 -type f -name Makefile -exec dirname {} \;), $(MAKE) -C $(subdir);)
# Finally, compile the entry point for the kernel
	$(CC) $(CC_FLAGS) $(KERNEL_INCLUDES) -c kernel_main.c -o $(OBJ_DIR)/kernel_main.o


.PHONY: kernel
