# Common configuration file (config.mk)

PROJECT=$(PWD)

# Directories
MISC=$(PROJECT)/misc
BUILD=$(PROJECT)/build
BIN=$(BUILD)/bin
OBJ=$(BUILD)/obj
SRC_DIR=$(PROJECT)/src
BOOT_DIR=$(SRC_DIR)/bootloader
KERNEL_DIR=$(PROJECT)/kernel
OS_FILES=$(MISC)/osfiles

# Variables
ASM=nasm
ASM_FLAGS=-f elf32

CC=gcc
CC_FLAGS=-m32 -Wall -Wextra -Werror -nostdlib -fno-builtin -ffreestanding -std=c11

LD=ld
LD_FLAGS=-m elf_i386

OBJ_CPY=objcopy
OBJ_FLAGS=elf32-i386
