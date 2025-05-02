include $(CONFIG_PATH)

SRCS := $(wildcard *.c)
OBJS := $(patsubst %.c, $(OBJ)/%.o, $(SRCS))

default: echo common


echo:
	@echo "\nCommon\n"


common: $(OBJS)


$(OBJ)/%.o: %.c
	$(CC) $(CC_FLAGS) $(KERNEL_INCLUDES) -c $< -o $@


.PHONY: default
