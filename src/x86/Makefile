include $(PROJECT)/misc/config.mk

C_SRCS := $(shell find . -name "*.c" -type f)
C_OBJS := $(patsubst %.c,$(OBJ_DIR)/%.o,$(notdir $(C_SRCS)))

.PHONY: all

all: $(C_OBJS)
	@echo "\n--- $(shell basename $(CURDIR)) Build Complete ---"
	@echo ""

$(OBJ_DIR)/%.o: %.c
	@echo "Compiling $(notdir $@)..."
	@$(CC) $(CC_FORMAT) $(CC_FLAGS) $(DEFINES) $(INCLUDE_DIRS) -c $< -o $(OBJ_DIR)/$(basename $(notdir $@)).o
