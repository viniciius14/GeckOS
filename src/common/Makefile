include $(CONFIG_PATH)

SRCS := $(wildcard *.c)
OBJS := $(patsubst %.c, $(OBJ_DIR)/%.o, $(SRCS))

default: echo $(OBJS)


echo:
	@echo "\nCommon\n"


$(OBJ_DIR)/%.o: %.c
	$(CC) $(CC_FLAGS) $(KERNEL_INCLUDES) -c $< -o $@


.PHONY: default
