# Compilers and flags for C
CC = gcc
C_FLAGS = -Wall -Wextra -g

# Compilers and flags for Assembly
ASM = nasm
ASM_FLAGS = -f elf64 #-D FS_12

# Linker and flags
LINKER = ld
LINKER_FLAGS = -m elf_x86_64 #--oformat binary

# Global Directories
PROJECT_DIR = $(shell pwd)
PROJECT_SRC = $(PROJECT_DIR)/src
PROJECT_MSC = $(PROJECT_DIR)/misc
PROJECT_INC = $(PROJECT_DIR)/include
PROJECT_BIN = $(PROJECT_DIR)/bin

# Local Directories
SRC := src
INC := include
BIN := bin

# Find all source files
C_SRCS := $(shell find $(SRC) -name '*.c')
ASM_SRCS := $(shell find $(SRC) -name '*.S')


# List all directories and subdirectories inside the include folder
INCLUDE_DIRS := $(shell find include -type d)
# Add the -I prefix to each include directory
INCLUDE_SRCS := $(foreach i, $(INCLUDE_DIRS), -I $i)

INCLUDE_ASM := $(shell find src -type f -name '*.S' -exec dirname {} \; | sort -u)
INCLUDE_ASM := $(foreach i, $(INCLUDE_ASM), -i $i)

# Object files
C_OBJS := $(patsubst $(SRC)/%.c, $(PROJECT_BIN)/%.o, $(C_SRCS))
ASM_OBJS := $(patsubst $(SRC)/%.S, $(PROJECT_BIN)/%.o, $(ASM_SRCS))


# Define the rule for compiling C objects
$(PROJECT_BIN)/%.o: $(PROJECT_SRC)/%.c
	@echo "Compiling $(notdir $<)"
	@$(CC) $(C_FLAGS) -c $< $(INCLUDE_SRCS) -o $(PROJECT_BIN)/$(basename $(notdir $<)).o


# Define the rule for compiling Assembly objects
$(PROJECT_BIN)/%.o: $(PROJECT_SRC)/%.S
	@echo "Compiling $(notdir $<)"
	@$(ASM) $(ASM_FLAGS) $< $(INCLUDE_ASM) -o $(PROJECT_BIN)/$(basename $(notdir $<)).o


# Recipes
.PHONY: default

default: compile link floppy run#clean


# Define the compile target to compile both C and Assembly files
compile: $(C_OBJS) $(ASM_OBJS)


link:
	$(LINKER) $(LINKER_FLAGS) -T $(PROJECT_MSC)/linker.ld $(PROJECT_BIN)/boot_sector.o $(shell find $(PROJECT_BIN) -name '*.o' ! -name 'boot_sector.o') -o $(PROJECT_BIN)/MyOS.bin

floppy:
	dd if=/dev/zero of=bin/GeckOS.img bs=512 count=2880
	mkfs.fat -F 12 bin/GeckOS.img
	dd if=bin/MyOS.bin of=bin/GeckOS.img bs=512 count=1 conv=notrunc


run:
	qemu-system-x86_64 -drive format=raw,file=bin/GeckOS.img,index=0,if=floppy -m 128M


clean:
	rm -rf $(PROJECT_BIN)/*