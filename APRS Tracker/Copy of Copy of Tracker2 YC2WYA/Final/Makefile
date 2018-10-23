###############################################################################
# Makefile for the project APRS_AVR_Tracker
###############################################################################

## General Flags
PROJECT = APRS_AVR_Tracker
MCU = atmega8
TARGET = APRS_AVR_Tracker.elf
CC = avr-gcc.exe

## Options common to compile, link and assembly rules
COMMON = -mmcu=$(MCU)

## Compile options common for all C compilation units.
CFLAGS = $(COMMON)
CFLAGS += -Wall -gdwarf-2                                                     -DF_CPU=14745600UL -Os -fsigned-char
CFLAGS += -MD -MP -MT $(*F).o -MF dep/$(@F).d 

## Assembly specific flags
ASMFLAGS = $(COMMON)
ASMFLAGS += $(CFLAGS)
ASMFLAGS += -x assembler-with-cpp -Wa,-gdwarf2

## Linker flags
LDFLAGS = $(COMMON)
LDFLAGS +=  -Wl,-Map=APRS_AVR_Tracker.map


## Intel Hex file production flags
HEX_FLASH_FLAGS = -R .eeprom

HEX_EEPROM_FLAGS = -j .eeprom
HEX_EEPROM_FLAGS += --set-section-flags=.eeprom="alloc,load"
HEX_EEPROM_FLAGS += --change-section-lma .eeprom=0 --no-change-warnings


## Objects that must be built in order to link
OBJECTS = Serial.o ADC.o ax25.o Main.o Messaging.o tmp275.o i2c_by_hand.o 

## Objects explicitly added by the user
LINKONLYOBJECTS = 

## Build
all: $(TARGET) APRS_AVR_Tracker.hex APRS_AVR_Tracker.eep APRS_AVR_Tracker.lss size

## Compile
Serial.o: ../Serial.c
	$(CC) $(INCLUDES) $(CFLAGS) -c  $<

ADC.o: ../ADC.c
	$(CC) $(INCLUDES) $(CFLAGS) -c  $<

ax25.o: ../ax25.c
	$(CC) $(INCLUDES) $(CFLAGS) -c  $<

Main.o: ../Main.c
	$(CC) $(INCLUDES) $(CFLAGS) -c  $<

Messaging.o: ../Messaging.c
	$(CC) $(INCLUDES) $(CFLAGS) -c  $<

tmp275.o: ../tmp275.c
	$(CC) $(INCLUDES) $(CFLAGS) -c  $<

i2c_by_hand.o: ../i2c_by_hand.c
	$(CC) $(INCLUDES) $(CFLAGS) -c  $<

##Link
$(TARGET): $(OBJECTS)
	 $(CC) $(LDFLAGS) $(OBJECTS) $(LINKONLYOBJECTS) $(LIBDIRS) $(LIBS) -o $(TARGET)

%.hex: $(TARGET)
	avr-objcopy -O ihex $(HEX_FLASH_FLAGS)  $< $@

%.eep: $(TARGET)
	-avr-objcopy $(HEX_EEPROM_FLAGS) -O ihex $< $@ || exit 0

%.lss: $(TARGET)
	avr-objdump -h -S $< > $@

size: ${TARGET}
	@echo
	@avr-size -C --mcu=${MCU} ${TARGET}

## Clean target
.PHONY: clean
clean:
	-rm -rf $(OBJECTS) APRS_AVR_Tracker.elf dep/* APRS_AVR_Tracker.hex APRS_AVR_Tracker.eep APRS_AVR_Tracker.lss APRS_AVR_Tracker.map


## Other dependencies
-include $(shell mkdir dep 2>/dev/null) $(wildcard dep/*)

