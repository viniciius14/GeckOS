include $(CONFIG_PATH)

SRCS := $(wildcard *.S)
OBJS := $(patsubst %.S, $(OBJ)/%.o, $(SRCS))

default: echo extract


echo:
	@echo "\nStage 2 Bootloader\n"


link: $(OBJS) driver
	$(LD) $(LD_FLAGS) -T stage2.ld $(OBJS) $(DRIVER_OBJS) -o $(OBJ)/stage2.elf


extract: link
	$(OBJ_CPY) $(OBJ_FLAGS) $(OBJ)/stage2.elf $(BIN)/stage2.bin


$(OBJ)/%.o: %.S
	$(ASM) $(ASM_FORMAT) $(ASM_FLAGS) -D$(FS) -D$(BITS) $(BOOT_INCLUDES) $< -o $@


driver:
ifeq ($(FS), FAT12)
DRIVER_OBJS=
#$(KERNEL_OBJ)/fdc.o $(KERNEL_OBJ)/io.o $(KERNEL_OBJ)/memory.o
else
	@echo "\nWARNING: Unsupported FS: $(FS).\n"
DRIVER_OBJS=
endif

.PHONY: default
