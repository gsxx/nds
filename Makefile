# Project Name
TARGET = hello_nds

# Source Files
SOURCES = source/main.c
ASOURCES = source/arm9/crt0.s

# Directories
BUILD = build

# Toolchain
PREFIX = arm-none-eabi-
CC = $(PREFIX)gcc
AS = $(PREFIX)as
LD = $(PREFIX)gcc
OBJCOPY = $(PREFIX)objcopy

# Flags
ARCH = -mthumb -mthumb-interwork
CFLAGS = -Wall -O2 -fno-strict-aliasing $(ARCH) \
         -I/opt/devkitpro/libnds/include
LDFLAGS = $(ARCH) -specs=ds_arm9.specs \
          -L/opt/devkitpro/libnds/lib \
          -L/opt/devkitpro/devkitARM/lib
LIBS = -lnds -lfat -lmm9 -lnds9

# File Lists
OFILES = $(addprefix $(BUILD)/,$(notdir $(SOURCES:.c=.o)))
AFILES = $(addprefix $(BUILD)/,$(notdir $(ASOURCES:.s=.o)))

# Rules
all: $(TARGET).nds

$(TARGET).nds: $(BUILD)/$(TARGET).arm9
	ndstool -c $@ -9 $<

$(BUILD)/$(TARGET).arm9: $(BUILD)/$(TARGET).elf
	$(OBJCOPY) -O binary $< $@

$(BUILD)/$(TARGET).elf: $(OFILES) $(AFILES)
	$(LD) $(LDFLAGS) $(OFILES) $(AFILES) $(LIBS) -o $@

$(BUILD)/%.o: source/%.c
	@mkdir -p $(BUILD)
	$(CC) $(CFLAGS) -MMD -MP -c $< -o $@

$(BUILD)/%.o: source/arm9/%.s
	@mkdir -p $(BUILD)
	$(AS) $(ARCH) -c $< -o $@

clean:
	rm -rf $(BUILD) $(TARGET).nds

-include $(OFILES:.o=.d)