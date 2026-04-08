include $(PROJECT)/misc/config.mk

C_SRCS := $(shell find . -name "*.c" -type f)

C_OBJS := $(patsubst %.c,$(OBJ_DIR)/%.o,$(notdir $(C_SRCS)))

.PHONY: libs32 libs64

utils:$(C_OBJS)
	@echo "--- Utils 32 Build Complete ---"
	@echo ""

$(OBJ_DIR)/%.o: %.c
	$(CC) $(CC_FLAGS) \
	$(USER_INPUTS) \
	$(LIB_INCLUDES) \
	-c $< -o $@
	@echo ""
