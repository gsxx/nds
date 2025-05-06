TARGET = my_nds_game
SOURCES = source/main.c
LIBS = -lnds

# Compiler Flags
ARCH = -mthumb -mthumb-interwork
CFLAGS = -Wall -O2 $(ARCH) -I$(DEVKITPRO)/libnds/include
LDFLAGS = $(ARCH) -specs=ds_arm9.specs -L$(DEVKITPRO)/libnds/lib

# --- Don't edit below ---
DEVKITPRO ?= /opt/devkitpro
DEVKITARM ?= $(DEVKITPRO)/devkitARM
PREFIX = $(DEVKITARM)/bin/arm-none-eabi-

CC = $(PREFIX)gcc
LD = $(PREFIX)gcc
OBJCOPY = $(PREFIX)objcopy

BUILD = build
OFILES = $(addprefix $(BUILD)/,$(notdir $(SOURCES:.c=.o)))

all: $(TARGET).nds

$(TARGET).nds: $(BUILD)/$(TARGET).arm9
	ndstool -c $@ -9 $<

$(BUILD)/$(TARGET).arm9: $(BUILD)/$(TARGET).elf
	$(OBJCOPY) -O binary $< $@

$(BUILD)/$(TARGET).elf: $(OFILES)
	$(LD) $(LDFLAGS) $(OFILES) $(LIBS) -o $@

$(BUILD)/%.o: source/%.c
	@mkdir -p $(BUILD)
	$(CC) $(CFLAGS) -MMD -MP -c $< -o $@

clean:
	rm -rf $(BUILD) $(TARGET).nds

-include $(OFILES:.o=.d)