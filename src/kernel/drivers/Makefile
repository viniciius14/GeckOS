include $(CONFIG_PATH)

SRCS := $(wildcard *.c)
OBJS := $(patsubst %.c, $(OBJ)/%.o, $(SRCS))

default: echo $(OBJS)

echo:
	@echo "\nDrivers\n"


$(OBJ)/%.o: %.c
	$(CC) $(CC_FLAGS) $(KERNEL_INCLUDES) -c $< -o $@


.PHONY: default
