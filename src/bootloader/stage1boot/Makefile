include $(CONFIG_PATH)

SRCS := $(wildcard *.S)
OBJS := $(patsubst %.S, $(BIN)/%_$(FS).bin, $(SRCS))

ASM_FORMAT=-f bin

default: echo assemble


echo:
	@echo "\nStage 1 Bootloader\n"


assemble: $(OBJS)


$(BIN)/%_$(FS).bin: %.S
	$(ASM) $(ASM_FORMAT) $(ASM_FLAGS) -D$(FS) -D$(BITS) $(BOOT_INCLUDES) $< -o $@


.PHONY: default
