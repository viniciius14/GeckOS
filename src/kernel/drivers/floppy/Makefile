include $(CONFIG_PATH)

SRCS := $(wildcard *.c)
OBJS := $(patsubst %.c, $(OBJ)/%.o, $(SRCS))

default: echo floppy


echo:
	@echo "\nFloppy Driver\n"
	@echo $(DRIVER_SRCS)


floppy: $(OBJS)


$(OBJ)/%.o: %.c
	$(CC) $(CC_FLAGS) $(KERNEL_INCLUDES) -c $< -o $@


.PHONY: default
