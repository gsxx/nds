TARGET = hello_nds
BUILD = build
SOURCES = source/main.c
ASOURCES = source/arm9/crt0.s

# Flags clave añadidos
ARCH = -mthumb -mthumb-interwork
CFLAGS = -Wall -O2 $(ARCH) -I$(DEVKITPRO)/libnds/include -DARM9
LDFLAGS = $(ARCH) -specs=ds_arm9.specs -L$(DEVKITPRO)/libnds/lib
LIBS = -lnds9 -lcalico -lfat -lmm9

include $(DEVKITPRO)/libnds/nds_rules

all: $(TARGET).nds

$(TARGET).nds: $(BUILD)/$(TARGET).arm9
	ndstool -c $@ -9 $<

$(BUILD)/$(TARGET).arm9: $(BUILD)/$(TARGET).elf
	$(OBJCOPY) -O binary $< $@

$(BUILD)/$(TARGET).elf: $(OFILES) $(AFILES)
	$(LD) $(LDFLAGS) $(OFILES) $(AFILES) $(LIBS) -o $@

clean:
	rm -rf $(BUILD) $(TARGET).nds

-include $(OFILES:.o=.d)