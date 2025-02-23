# Root Makefile
include misc/config.mk

# Define the path to config.mk
export CONFIG_PATH := $(PWD)/misc/config.mk

# Define the source directory
SRC_DIR := src

# Find all subdirectories in src/ that contain a Makefile
SUBDIRS := $(shell find $(SRC_DIR) -type f -name Makefile -exec dirname {} \;)

# Default target
all: $(SUBDIRS)
	@echo $(SUBDIRS)

# Rule to iterate through each subdirectory and call its Makefile
$(SUBDIRS):
	mkdir -p $(BIN)
	mkdir -p $(OBJ)
	$(MAKE) -C $@

# Clean target to clean all subdirectories
clean:
	rm -rf  build/

.PHONY: all $(SUBDIRS)
