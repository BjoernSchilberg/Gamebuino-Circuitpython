#
# This file is part of the MicroPython project, http://micropython.org/
#
# The MIT License (MIT)
#
# Copyright (c) 2019 Dan Halbert for Adafruit Industries
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.


# mpconfigboard.mk files can specify:
# CIRCUITPY_FULL_BUILD = 1 (which is the default)
# or
# CIRCUITPY_SMALL_BUILD = 1
# which is the same as:
# CIRCUITPY_FULL_BUILD = 0

NEW_DEFINES = \

ifndef CIRCUITPY_FULL_BUILD
ifeq ($(CIRCUITPY_SMALL_BUILD),1)
CIRCUITPY_FULL_BUILD = 0
NEW_DEFINES += -DCIRCUITPY_FULL_BUILD=0
else
CIRCUITPY_FULL_BUILD = 1
NEW_DEFINES += -DCIRCUITPY_FULL_BUILD=1
endif
endif

# All builtin modules are listed below, with default values (0 for off, 1 for on)
# Some are always on, some are always off, and some depend on CIRCUITPY_FULL_BUILD.
#
# *** You can override any of the defaults by defining them in your mpconfigboard.mk.

ifndef CIRCUITPY_ANALOGIO
CIRCUITPY_ANALOGIO = 1
endif
NEW_DEFINES += -DCIRCUITPY_ANALOGIO=$(CIRCUITPY_ANALOGIO)

ifndef CIRCUITPY_AUDIOBUSIO
CIRCUITPY_AUDIOBUSIO = $(CIRCUITPY_FULL_BUILD)
endif
NEW_DEFINES += -DCIRCUITPY_AUDIOBUSIO=$(CIRCUITPY_AUDIOBUSIO)

ifndef CIRCUITPY_AUDIOIO
CIRCUITPY_AUDIOIO = $(CIRCUITPY_FULL_BUILD)
endif
NEW_DEFINES += -DCIRCUITPY_AUDIOIO=$(CIRCUITPY_AUDIOIO)

ifndef CIRCUITPY_BITBANGIO
CIRCUITPY_BITBANGIO = $(CIRCUITPY_FULL_BUILD)
endif
NEW_DEFINES += -DCIRCUITPY_BITBANGIO=$(CIRCUITPY_BITBANGIO)

# Explicitly enabled for boards that support bleio.
ifndef CIRCUITPY_BLEIO
CIRCUITPY_BLEIO = 0
endif
NEW_DEFINES += -DCIRCUITPY_BLEIO=$(CIRCUITPY_BLEIO)

ifndef CIRCUITPY_BOARD
CIRCUITPY_BOARD = 1
endif
NEW_DEFINES += -DCIRCUITPY_BOARD=$(CIRCUITPY_BOARD)

ifndef CIRCUITPY_BUSIO
CIRCUITPY_BUSIO = 1
endif
NEW_DEFINES += -DCIRCUITPY_BUSIO=$(CIRCUITPY_BUSIO)

ifndef CIRCUITPY_DIGITALIO
CIRCUITPY_DIGITALIO = 1
endif
NEW_DEFINES += -DCIRCUITPY_DIGITALIO=$(CIRCUITPY_DIGITALIO)

ifndef CIRCUITPY_DISPLAYIO
CIRCUITPY_DISPLAYIO = $(CIRCUITPY_FULL_BUILD)
endif
NEW_DEFINES += -DCIRCUITPY_DISPLAYIO=$(CIRCUITPY_DISPLAYIO)

ifndef CIRCUITPY_FREQUENCYIO
CIRCUITPY_FREQUENCYIO = $(CIRCUITPY_FULL_BUILD)
endif
NEW_DEFINES += -DCIRCUITPY_FREQUENCYIO=$(CIRCUITPY_FREQUENCYIO)

ifndef CIRCUITPY_GAMEPAD
CIRCUITPY_GAMEPAD = $(CIRCUITPY_FULL_BUILD)
endif
NEW_DEFINES += -DCIRCUITPY_GAMEPAD=$(CIRCUITPY_GAMEPAD)

ifndef CIRCUITPY_GAMEPADSHIFT
CIRCUITPY_GAMEPADSHIFT = 0
endif
NEW_DEFINES += -DCIRCUITPY_GAMEPADSHIFT=$(CIRCUITPY_GAMEPADSHIFT)

ifndef CIRCUITPY_I2CSLAVE
CIRCUITPY_I2CSLAVE = $(CIRCUITPY_FULL_BUILD)
endif
NEW_DEFINES += -DCIRCUITPY_I2CSLAVE=$(CIRCUITPY_I2CSLAVE)

ifndef CIRCUITPY_MATH
CIRCUITPY_MATH = 1
endif
NEW_DEFINES += -DCIRCUITPY_MATH=$(CIRCUITPY_MATH)

ifndef CIRCUITPY_MICROCONTROLLER
CIRCUITPY_MICROCONTROLLER = 1
endif
NEW_DEFINES += -DCIRCUITPY_MICROCONTROLLER=$(CIRCUITPY_MICROCONTROLLER)

ifndef CIRCUITPY_NEOPIXEL_WRITE
CIRCUITPY_NEOPIXEL_WRITE = 1
endif
NEW_DEFINES += -DCIRCUITPY_NEOPIXEL_WRITE=$(CIRCUITPY_NEOPIXEL_WRITE)

# Only certain boards support NETWORK (Ethernet)
ifndef CIRCUITPY_NETWORK
CIRCUITPY_NETWORK = 0
endif
NEW_DEFINES += -DCIRCUITPY_NETWORK=$(CIRCUITPY_NETWORK)

ifndef CIRCUITPY_NVM
CIRCUITPY_NVM = 1
endif
NEW_DEFINES += -DCIRCUITPY_NVM=$(CIRCUITPY_NVM)

ifndef CIRCUITPY_OS
CIRCUITPY_OS = 1
endif
NEW_DEFINES += -DCIRCUITPY_OS=$(CIRCUITPY_OS)

ifndef CIRCUITPY_PIXELBUF
CIRCUITPY_PIXELBUF = $(CIRCUITPY_FULL_BUILD)
endif
NEW_DEFINES += -DCIRCUITPY_PIXELBUF=$(CIRCUITPY_PIXELBUF)

ifndef CIRCUITPY_PULSEIO
CIRCUITPY_PULSEIO = 1
endif
NEW_DEFINES += -DCIRCUITPY_PULSEIO=$(CIRCUITPY_PULSEIO)

ifndef CIRCUITPY_RANDOM
CIRCUITPY_RANDOM = 1
endif
NEW_DEFINES += -DCIRCUITPY_RANDOM=$(CIRCUITPY_RANDOM)

ifndef CIRCUITPY_ROTARYIO
CIRCUITPY_ROTARYIO = 1
endif
NEW_DEFINES += -DCIRCUITPY_ROTARYIO=$(CIRCUITPY_ROTARYIO)

ifndef CIRCUITPY_RTC
CIRCUITPY_RTC = 1
endif
NEW_DEFINES += -DCIRCUITPY_RTC=$(CIRCUITPY_RTC)

# CIRCUITPY_SAMD is handled in the atmel-samd tree.
# Only for SAMD chips.
# Assume not a SAMD build.
ifndef CIRCUITPY_SAMD
CIRCUITPY_SAMD = 0
endif
NEW_DEFINES += -DCIRCUITPY_SAMD=$(CIRCUITPY_SAMD)

# Currently always off.
ifndef CIRCUITPY_STAGE
CIRCUITPY_STAGE = 0
endif
NEW_DEFINES += -DCIRCUITPY_STAGE=$(CIRCUITPY_STAGE)

ifndef CIRCUITPY_STORAGE
CIRCUITPY_STORAGE = 1
endif
NEW_DEFINES += -DCIRCUITPY_STORAGE=$(CIRCUITPY_STORAGE)

ifndef CIRCUITPY_STRUCT
CIRCUITPY_STRUCT = 1
endif
NEW_DEFINES += -DCIRCUITPY_STRUCT=$(CIRCUITPY_STRUCT)

ifndef CIRCUITPY_SUPERVISOR
CIRCUITPY_SUPERVISOR = 1
endif
NEW_DEFINES += -DCIRCUITPY_SUPERVISOR=$(CIRCUITPY_SUPERVISOR)

ifndef CIRCUITPY_TIME
CIRCUITPY_TIME = 1
endif
NEW_DEFINES += -DCIRCUITPY_TIME=$(CIRCUITPY_TIME)

ifndef CIRCUITPY_TOUCHIO
CIRCUITPY_TOUCHIO = 1
endif
NEW_DEFINES += -DCIRCUITPY_TOUCHIO=$(CIRCUITPY_TOUCHIO)

# For debugging.
ifndef CIRCUITPY_UHEAP
CIRCUITPY_UHEAP = 0
endif
NEW_DEFINES += -DCIRCUITPY_UHEAP=$(CIRCUITPY_UHEAP)

ifndef CIRCUITPY_USB_HID
CIRCUITPY_USB_HID = 1
endif
NEW_DEFINES += -DCIRCUITPY_USB_HID=$(CIRCUITPY_USB_HID)

ifndef CIRCUITPY_USB_MIDI
CIRCUITPY_USB_MIDI = 1
endif
NEW_DEFINES += -DCIRCUITPY_USB_MIDI=$(CIRCUITPY_USB_MIDI)

ifndef CIRCUITPY_PEW
CIRCUITPY_PEW = 0
endif
NEW_DEFINES += -DCIRCUITPY_PEW=$(CIRCUITPY_PEW)

# For debugging.
ifndef CIRCUITPY_USTACK
CIRCUITPY_USTACK = 0
endif
NEW_DEFINES += -DCIRCUITPY_USTACK=$(CIRCUITPY_USTACK)

CFLAGS += $(NEW_DEFINES)
CPPFLAGS += $(NEW_DEFINES)
