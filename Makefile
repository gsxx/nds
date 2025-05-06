# Project Name (Output ROM will be this name)
TARGET      = my_nds_game

# Source Files
SOURCES     = source/main.c
# Add more .c files as needed:
# SOURCES += source/graphics.c source/input.c

# Asset Directories (optional)
# DATA       = data

# Libraries (libnds is required)
LIBS        = -lnds

# Compiler Flags
ARCH        = -mthumb -mthumb-interwork
CFLAGS      = -Wall -O2 $(ARCH)
CXXFLAGS    = $(CFLAGS) -fno-rtti -fno-exceptions
ASFLAGS     = $(ARCH)
LDFLAGS     = $(ARCH) -specs=ds_arm9.specs

# --- You shouldn't need to edit below this line ---
BUILD       = build
EXEFS       = $(BUILD)/$(TARGET).elf
ROM         = $(TARGET).nds
ARM9BIN     = $(BUILD)/$(TARGET).arm9

# devkitPro Paths
DEVKITPRO   ?= /opt/devkitpro
DEVKITARM   ?= $(DEVKITPRO)/devkitARM
PREFIX      = $(DEVKITARM)/bin/arm-none-eabi-

CC          = $(PREFIX)gcc
CXX         = $(PREFIX)g++
AS          = $(PREFIX)as
LD          = $(PREFIX)gcc
OBJCOPY     = $(PREFIX)objcopy

# File Lists
OFILES      = $(addprefix $(BUILD)/,$(notdir $(SOURCES:.c=.o)))
DEPS        = $(OFILES:.o=.d)

# Rules
all: $(ROM)

$(ROM): $(ARM9BIN)
	ndstool -c $@ -9 $<

$(ARM9BIN): $(EXEFS)
	$(OBJCOPY) -O binary $< $@

$(EXEFS): $(OFILES)
	$(LD) $(LDFLAGS) $(OFILES) $(LIBS) -o $@

$(BUILD)/%.o: source/%.c
	@mkdir -p $(BUILD)
	$(CC) $(CFLAGS) -MMD -MP -c $< -o $@

clean:
	rm -rf $(BUILD) $(ROM)

# Include dependency files
-include $(DEPS)

.PHONY: all clean