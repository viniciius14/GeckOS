# Compilers and flags for C
CC = gcc
C_FLAGS = -Wall -Wextra -g

# Compilers and flags for Assembly
ASM_C = nasm
ASM_FLAGS = -f bin

# Linker and flags
LINKER = ld
LINKER_FLAGS = -m elf_i386 -Ttext 0x1000  --oformat binary

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
SRCS := $(shell find $(SRC) -name '*.c')
ASM_SRCS := $(shell find $(SRC) -name '*.s')


# List all directories and subdirectories inside the include folder
INCLUDE_DIRS := $(shell find include -type d)
# Add the -I prefix to each include directory
INCLUDE_SRCS := $(foreach i, $(INCLUDE_DIRS), -I $i)


# Object files
C_OBJS := $(patsubst $(SRC)/%.c, $(PROJECT_BIN)/%.o, $(SRCS))
ASM_OBJS := $(patsubst $(SRC)/%.s, $(PROJECT_BIN)/%.o, $(ASM_SRCS))

# Define the rule for compiling C objects
$(PROJECT_BIN)/%.o: $(PROJECT_SRC)/%.c
	@echo "Compiling $(notdir $<)"
	@$(CC) $(C_FLAGS) -c $< $(INCLUDE_SRCS) -o $(PROJECT_BIN)/$(basename $(notdir $<)).o

# Define the rule for compiling Assembly objects
# WIP
$(PROJECT_BIN)/%.o: $(PROJECT_SRC)/%.s
	@$(ASM_C) $(ASM_FLAGS) $< -o $(PROJECT_BIN)/$(basename $(notdir $<)).bin
	@echo "Compiling $(notdir $<)"

# Recipes
.PHONY: default

default: compile link_boot #clean


# Define the compile target to compile both C and Assembly files
compile: $(C_OBJS) $(ASM_OBJS)


# Define the link target
#WIP
link:
	$(LINKER) $(LINKER_FLAGS) $(PROJECT_MSC)/linker.ld $(shell find -name '*.o') -o $(PROJECT_BIN)/MyOS.bin


# Define the rule for cleaning generated files
clean:
	rm -rf $(PROJECT_BIN)/*
