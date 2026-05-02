include $(CONFIG_PATH)

ASM_SRCS := $(shell find . -name "*.S" -type f)
ASM_OBJS := $(patsubst %.S, build/%.o, $(ASM_SRCS))

C_SRCS   := $(shell find . -name "*.c" -type f)
C_OBJS   := $(patsubst %.c, build/%.o, $(C_SRCS))

.PHONY: all

all: $(ASM_OBJS) $(C_OBJS)
	@echo "\n--- $(shell basename $(CURDIR)) Build Complete ---"
	@echo ""

build/%.o: %.c
	@echo "Compiling $(notdir $@)..."
	@$(CC) $(CC_FORMAT) $(CC_FLAGS) $(DEFINES) $(INCLUDE_DIRS) -c $< -o $(OBJ_DIR)/$(basename $(notdir $@)).o

build/%.o: %.S
	@echo "Compiling $(notdir $@)..."
	@$(ASM) $(ASM_FORMAT) $(DEFINES) $< -o $(OBJ_DIR)/$(basename $(notdir $@)).o
