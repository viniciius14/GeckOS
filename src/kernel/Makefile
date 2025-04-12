include $(CONFIG_PATH)

KERNEL_SUBDIRS=$(shell find $(KERNEL_DIR) -mindepth 1 -type d)
export KERNEL_INCLUDES=$(foreach dir, $(KERNEL_SUBDIRS), -I $(dir))

export BIN=$(BUILD_DIR)/kernel/bin
export OBJ=$(BUILD_DIR)/kernel/obj

OBJS = $(wildcard $(OBJ)/*.o)

kernel: echo dirs extract


echo:
	@echo "\nKernel\n"

dirs:
	mkdir -p $(KERNEL_BIN)
	mkdir -p $(KERNEL_OBJ)

# Rule to iterate through each subdirectory and call its Makefile (with exception for the current one)
kernel_directories:
	$(foreach subdir, $(shell find . -mindepth 2 -type f -name Makefile -exec dirname {} \;), $(MAKE) -C $(subdir);)


link: kernel_directories main
	$(LD) $(LD_FLAGS) -T kernel.ld $(OBJS) -o $(OBJ)/kernel.elf


extract: link
	$(OBJ_CPY) $(OBJ_FLAGS) $(OBJ)/kernel.elf $(BIN)/kernel.bin

main:
	$(CC) $(CC_FLAGS) $(KERNEL_INCLUDES) -c kernel_main.c -o $(OBJ)/kernel_main.o


.PHONY: kernel
