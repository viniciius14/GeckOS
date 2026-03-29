include $(CONFIG_PATH)

# KERNEL_SUBDIRS = $(shell find $(SRC_DIR) -mindepth 1 -type d)
# export KERNEL_INCLUDES = $(foreach dir, $(KERNEL_SUBDIRS), -I $(dir))
C_SRCS   := $(shell find . -name "*.c" -type f)
ASM_SRCS := core/boot.S

ASM_OBJS := $(patsubst %.S, build/%.o, $(ASM_SRCS))
C_OBJS   := $(patsubst %.c, build/%.o, $(C_SRCS))


.PHONY: kernel

kernel: $(ASM_OBJS) $(C_OBJS)
# 	$(foreach subdir, $(shell find . -mindepth 2 -type f -name Makefile -exec dirname {} \;), $(MAKE) -C $(subdir);)
# Finally, compile the entry point for the kernel
# 	$(CC) $(CC_FLAGS) $(KERNEL_INCLUDES) -c main.c -o $(OBJ_DIR)/kernel_main.o


# Added 'mkdir' to ensure the build directory exists
build/%.o: %.c
	@echo "Compiling $(notdir $@)..."
	@$(CC) $(CC_FORMAT) $(CC_FLAGS) -c $< -o $(OBJ_DIR)/$(basename $(notdir $@)).o

build/%.o: %.S
	@echo "Compiling $(notdir $@)..."
	@$(ASM) $(ASM_FORMAT) $< -o $(OBJ_DIR)/$(basename $(notdir $@)).o
