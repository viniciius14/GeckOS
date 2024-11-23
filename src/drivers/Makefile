# Drivers folder Makefile

# Directories
BIN=$(PWD)/bin
MISC=$(PWD)/misc
DRIVER_SRC=$(PWD)/src/drivers
INC_DIRS=${shell find $(PWD)/include -type d}

# Vars
CC=x86_64-elf-gcc
CC_FLAGS=-m64 -Wall -Wextra -Werror -nostdlib -fno-builtin -ffreestanding -mcmodel=large -mno-red-zone -mgeneral-regs-only -std=c11
# CC_FLAGS+=-fPIC -shared
# gcc -c src/drivers/fdc.c -I include/drivers -I include/kernel -m64 -Wall -Wextra -Werror -nostdlib -fno-builtin -ffreestanding -mcmodel=large -mno-red-zone -mgeneral-regs-only -std=c11
LD=x86_64-elf-ld
LD_FLAGS=-m elf_x86_64

OBJ=x86_64-elf-objcopy
OBJ_FLAGS=-O binary

.PHONY: all

DRIVER_SRC = ${shell find *.c}

drivers:
	$(info CREATING DRIVERS LIBRARY WITH THE FOLLOWING FILES:$(NEWLINE)$(DRIVER_SRC))
	$(foreach FILE, $(DRIVER_SRC),$(CC) $(CC_FLAGS) -c $(FILE) $(foreach DIR, $(INC_DIRS),-I$(DIR) ) -o $(BIN)/$(basename $(FILE)).elf $(NEWLINE))
	ar rcs $(BIN)/drivers.a $(foreach FILE, $(DRIVER_SRC), $(BIN)/$(basename $(FILE)).elf)

define NEWLINE


endef