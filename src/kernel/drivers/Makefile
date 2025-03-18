include $(CONFIG_PATH)

# Find all subdirectories containing .c files
DRIVER_DIRS := $(shell find . -mindepth 1 -maxdepth 1 -type d)
DRIVER_SRCS := $(wildcard $(foreach dir, $(DRIVER_DIRS), $(dir)/*.c))

OBJS = $(DRIVER_SRCS:.c=.o)

# Default target
all: echo drivers


echo:
	@echo "\nDrivers\n"


drivers: $(OBJS)


%.o: %.c
	$(CC) $(CC_FLAGS) $(KERNEL_INCLUDES) -c $< -o $(OBJ)/$(notdir $@)


.PHONY: all
