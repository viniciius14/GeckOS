include $(CONFIG_PATH)

ASM_SRCS := $(shell find . -name "*.S" -type f)
ASM_OBJS := $(patsubst %.S, $(OBJ_DIR)/%.o, $(ASM_SRCS))

C_SRCS   := $(shell find . -name "*.c" -type f)
C_OBJS   := $(patsubst %.c, $(OBJ_DIR)/%.o, $(C_SRCS))

.PHONY: all

all: $(ASM_OBJS) $(C_OBJS)
	@echo "\n--- $(shell basename $(CURDIR)) Build Complete ---"
	@echo ""

$(OBJ_DIR)/%.o: %.c
	@echo "Compiling $(notdir $@)..."
	@$(CC) $(CC_FORMAT) $(CC_FLAGS) $(DEFINES) $(INCLUDE_DIRS) -c $< -o $(OBJ_DIR)/$(basename $(notdir $@)).o

$(OBJ_DIR)/%.o: %.S
	@echo "Compiling $(notdir $@)..."
	@$(ASM) $(ASM_FORMAT) $(DEFINES) $< -o $(OBJ_DIR)/$(basename $(notdir $@)).o
