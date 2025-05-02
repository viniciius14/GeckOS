include $(CONFIG_PATH)

KERNEL_SUBDIRS = $(shell find $(KERNEL_DIR) -mindepth 1 -type d)
export KERNEL_INCLUDES = $(foreach dir, $(KERNEL_SUBDIRS), -I $(dir))


GeckOS: kernel #stats image

kernel: echo dirs link
	$(OBJ_CPY) $(OBJ_FLAGS) $(OBJ)/kernel.elf $(BIN)/kernel.bin


link: entry kernel_directories
	$(LD) $(LD_FLAGS) -T kernel.ld $(wildcard $(OBJ)/*.o) -o $(OBJ)/kernel.elf


entry:
	$(CC) $(CC_FLAGS) $(KERNEL_INCLUDES) -c kernel_main.c -o $(OBJ)/kernel_main.o


# Rule to iterate through each subdirectory and call its Makefile (with exception for the current one)
kernel_directories:
	$(foreach subdir, $(shell find . -mindepth 2 -type f -name Makefile -exec dirname {} \;), $(MAKE) -C $(subdir);)



clean:
	rm -rf $(BUILD_DIR)
	clear



echo:
	@echo "\n--- Kernel ---\n"


dirs:
	mkdir -p $(BIN_DIR)
	mkdir -p $(OBJ_DIR)
	mkdir -p $(DEBUG_DIR)


.PHONY: GeckOS
