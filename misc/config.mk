# Common configuration file (config.mk)

# Directories
MISC=$(PWD)
BUILD=$(MISC)/build
BIN=$(BUILD)/bin
OBJ=$(BUILD)/obj

# Variables
ASM=nasm
ASM_FLAGS=-f elf32

CC=gcc
CC_FLAGS=-m32 -Wall -Wextra -Werror -nostdlib -fno-builtin -ffreestanding -std=c11

LD=ld
LD_FLAGS=-m elf_i386

OBJ=objcopy
OBJ_FLAGS=elf32-i386
