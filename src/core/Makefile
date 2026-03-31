include $(CONFIG_PATH)

C_SRCS   := $(shell find . -name "*.c" -type f)
ASM_SRCS := $(shell find . -name "*.S" -type f)

ASM_OBJS := $(patsubst %.S, build/%.o, $(ASM_SRCS))
C_OBJS   := $(patsubst %.c, build/%.o, $(C_SRCS))


.PHONY: core

core: $(ASM_OBJS) $(C_OBJS)

# Added 'mkdir' to ensure the build directory exists
build/%.o: %.c
	@echo "Compiling $(notdir $@)..."
	@$(CC) $(CC_FORMAT) $(CC_FLAGS) $(DEFINES) -c $< -o $(OBJ_DIR)/$(basename $(notdir $@)).o

build/%.o: %.S
	@echo "Compiling $(notdir $@)..."
	@$(ASM) $(ASM_FORMAT) $(DEFINES) $< -o $(OBJ_DIR)/$(basename $(notdir $@)).o
