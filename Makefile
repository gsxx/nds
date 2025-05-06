TARGET = hello_nds
BUILD = build
SOURCES = source/main.c
DATA = graphics

ARCH = -mthumb -mthumb-interwork
CFLAGS = -Wall -O2 -fno-strict-aliasing $(ARCH)
LDFLAGS = $(ARCH) -specs=ds_arm9.specs

LIBS = -lnds

include $(DEVKITPRO)/libnds/nds_rules

.PHONY: all clean

all: $(TARGET).nds

clean:
	rm -rf $(BUILD) $(TARGET).nds