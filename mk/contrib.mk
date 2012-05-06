#
# contrib.mk
#
# Copyright (C) 2010 - 2012 Creytiv.com
#


#
# path to external source code
#

LIBRE_PATH	:= ../re
LIBREM_PATH	:= ../rem
BARESIP_PATH	:= ../baresip


#
# tools and SDK
#

ROOT_ARM	:= /Developer/Platforms/iPhoneOS.platform/Developer
ROOT_SIM	:= /Developer/Platforms/iPhoneSimulator.platform/Developer

# Auto-detect the latest SDK
ifeq ($(SDK_VER),)
SDK_VER   := $(shell [ -d $(ROOT_ARM)/SDKs/iPhoneOS5.1.sdk ] && echo "5.1")
endif
ifeq ($(SDK_VER),)
SDK_VER   := $(shell [ -d $(ROOT_ARM)/SDKs/iPhoneOS4.3.sdk ] && echo "4.3")
endif
ifeq ($(SDK_VER),)
SDK_VER   := $(shell [ -d $(ROOT_ARM)/SDKs/iPhoneOS4.2.sdk ] && echo "4.2")
endif
ifeq ($(SDK_VER),)
SDK_VER   := $(shell [ -d $(ROOT_ARM)/SDKs/iPhoneOS4.1.sdk ] && echo "4.1")
endif
ifeq ($(SDK_VER),)
SDK_VER   := $(shell [ -d $(ROOT_ARM)/SDKs/iPhoneOS4.0.sdk ] && echo "4.0")
endif
ifeq ($(SDK_VER),)
$(warning no iPhone SDK detected)
endif

ifeq ($(SDK_VER),4.1)
ARM_MACHINE := arm-apple-darwin10
SIM_MACHINE := i686-apple-darwin10
endif
ifeq ($(SDK_VER),4.0)
ARM_MACHINE := arm-apple-darwin10
SIM_MACHINE := i686-apple-darwin10
endif

SDK_MAJOR	:= $(shell echo $(SDK_VER) | cut -d'.' -f 1)
SDK_MINOR	:= $(shell echo $(SDK_VER) | cut -d'.' -f 2)
SDK_ARM		:= $(ROOT_ARM)/SDKs/iPhoneOS$(SDK_VER).sdk
SDK_SIM		:= $(ROOT_SIM)/SDKs/iPhoneSimulator$(SDK_VER).sdk
CC_ARM		:= $(ROOT_ARM)/usr/bin/gcc
CC_SIM		:= $(ROOT_SIM)/usr/bin/gcc

CONTRIB_DIR	:= $(PWD)/contrib
CONTRIB_ARMV6	:= $(CONTRIB_DIR)/armv6
CONTRIB_ARMV7	:= $(CONTRIB_DIR)/armv7
CONTRIB_I386	:= $(CONTRIB_DIR)/i386
CONTRIB_FAT	:= $(CONTRIB_DIR)/fat

BUILD_DIR	:= $(PWD)/build
BUILD_ARMV6	:= $(BUILD_DIR)/armv6
BUILD_ARMV7	:= $(BUILD_DIR)/armv7
BUILD_I386	:= $(BUILD_DIR)/i386
BUILD_FAT	:= $(BUILD_DIR)/fat

ARMROOT		:= $(SDK_ARM)/usr
ARMROOT_ALT	:= $(CONTRIB_FAT)
SIMROOT		:= $(SDK_SIM)/usr
SIMROOT_ALT	:= $(CONTRIB_FAT)

EXTRA_CFLAGS       := -DIPHONE -pipe -no-cpp-precomp -isysroot $(SDK_ARM)
EXTRA_CFLAGS_SIM   := -DIPHONE -pipe -no-cpp-precomp -isysroot $(SDK_SIM)
EXTRA_CFLAGS_ARMV6 := -arch armv6 -I$(CONTRIB_ARMV6)/include $(EXTRA_CFLAGS)
EXTRA_CFLAGS_ARMV7 := -arch armv7 -I$(CONTRIB_ARMV7)/include $(EXTRA_CFLAGS)
EXTRA_CFLAGS_I386  := -arch i386 -I$(CONTRIB_I386)/include $(EXTRA_CFLAGS_SIM)

EXTRA_LFLAGS       := -L$(CONTRIB_FAT)/lib -isysroot $(SDK_ARM)
EXTRA_LFLAGS_SIM   := -L$(CONTRIB_FAT)/lib -isysroot $(SDK_SIM)
EXTRA_LFLAGS_ARMV6 := -arch armv6 -L$(CONTRIB_ARMV6)/lib $(EXTRA_LFLAGS)
EXTRA_LFLAGS_ARMV7 := -arch armv7 -L$(CONTRIB_ARMV7)/lib $(EXTRA_LFLAGS)
EXTRA_LFLAGS_I386  := -arch i386 -L$(CONTRIB_I386)/lib $(EXTRA_LFLAGS_SIM)


EXTRA_I386      := \
	EXTRA_CFLAGS='-D__DARWIN_ONLY_UNIX_CONFORMANCE \
		-D__IPHONE_OS_VERSION_MIN_REQUIRED=30000 \
		-mmacosx-version-min=10.5 \
		-Wno-cast-align -Wno-shorten-64-to-32 \
		-Wno-aggregate-return \
		-arch i386 \
		-isysroot $(SDK_SIM) \
		-I$(CONTRIB_I386)/include' \
	OBJCFLAGS='-fobjc-abi-version=2 -fobjc-legacy-dispatch' \
	EXTRA_LFLAGS='-arch i386 -L$(CONTRIB_FAT)/lib \
		-isysroot $(SDK_SIM)'

EXTRA_ARMV6       := \
	EXTRA_CFLAGS='-arch armv6 \
		-I$(CONTRIB_ARMV6)/include \
		-Wno-cast-align -Wno-shorten-64-to-32 \
		-Wno-aggregate-return \
		-isysroot $(SDK_ARM) -DHAVE_ARMV6' \
	EXTRA_LFLAGS='-arch armv6 -mcpu=arm1176jzf-s -marm \
		-L$(CONTRIB_FAT)/lib -isysroot $(SDK_ARM)' \
	OS=darwin ARCH=armv6 CROSS_COMPILE=$(ARM_MACHINE) \
	HAVE_ARMV6=1

EXTRA_ARMV7       := \
	EXTRA_CFLAGS='-arch armv7 \
		-I$(CONTRIB_ARMV7)/include \
		-Wno-cast-align -Wno-shorten-64-to-32 \
		-Wno-aggregate-return \
		-isysroot $(SDK_ARM) -DHAVE_NEON' \
	EXTRA_LFLAGS='-arch armv7 -mcpu=cortex-a8 -mfpu=neon -marm \
		-L$(CONTRIB_FAT)/lib -isysroot $(SDK_ARM)' \
	OS=darwin ARCH=armv7 CROSS_COMPILE=$(ARM_MACHINE) \
	HAVE_NEON=1


#
# common targets
#

.PHONY: contrib
contrib:	baresip


$(BUILD_ARMV6) $(BUILD_ARMV7) $(BUILD_I386) $(BUILD_FAT):
	@mkdir -p $@

$(CONTRIB_FAT) $(CONTRIB_FAT)/lib:
	@mkdir -p $@


#
# libre
#

LIBRE_BUILD_FLAGS := \
	USE_OPENSSL= USE_ZLIB= OPT_SPEED=1

libre: $(CONTRIB_FAT)/lib
	@rm -f $(LIBRE_PATH)/libre.*
	@make -sC $(LIBRE_PATH) CC='$(CC_ARM)' \
		BUILD=$(BUILD_ARMV6)/libre \
		SYSROOT=$(ARMROOT) SYSROOT_ALT=$(ARMROOT_ALT) \
		$(LIBRE_BUILD_FLAGS) $(EXTRA_ARMV6) \
		PREFIX= DESTDIR=$(CONTRIB_ARMV6) \
		all install

	@rm -f $(LIBRE_PATH)/libre.*
	@make -sC $(LIBRE_PATH) CC='$(CC_ARM)' \
		BUILD=$(BUILD_ARMV7)/libre \
		SYSROOT=$(ARMROOT) SYSROOT_ALT=$(ARMROOT_ALT) \
		$(LIBRE_BUILD_FLAGS) $(EXTRA_ARMV7) \
		PREFIX= DESTDIR=$(CONTRIB_ARMV7) \
		all install

	@rm -f $(LIBRE_PATH)/libre.*
	@make -sC $(LIBRE_PATH) CC='$(CC_SIM)' \
		BUILD=$(BUILD_I386)/libre \
		SYSROOT=$(SIMROOT) SYSROOT_ALT=$(SIMROOT_ALT) \
		$(LIBRE_BUILD_FLAGS) $(EXTRA_I386) \
		PREFIX= DESTDIR=$(CONTRIB_I386) \
		all install

	@rm -f $(LIBRE_PATH)/libre.*

	@lipo \
		-arch i386 $(CONTRIB_I386)/lib/libre.a \
		-arch armv6 $(CONTRIB_ARMV6)/lib/libre.a \
		-arch armv7 $(CONTRIB_ARMV7)/lib/libre.a \
		-create -output $(CONTRIB_FAT)/lib/libre.a


#
# librem
#

LIBREM_BUILD_FLAGS := \
	OPT_SPEED=1

librem: libre
	@rm -f $(LIBREM_PATH)/librem.*
	@make -sC $(LIBREM_PATH) CC='$(CC_ARM)' \
		BUILD=$(BUILD_ARMV6)/librem \
		SYSROOT=$(ARMROOT) SYSROOT_ALT=$(ARMROOT_ALT) \
		$(LIBREM_BUILD_FLAGS) $(EXTRA_ARMV6) \
		PREFIX= DESTDIR=$(CONTRIB_ARMV6) \
		all install

	@rm -f $(LIBREM_PATH)/librem.*
	@make -sC $(LIBREM_PATH) CC='$(CC_ARM)' \
		BUILD=$(BUILD_ARMV7)/librem \
		SYSROOT=$(ARMROOT) SYSROOT_ALT=$(ARMROOT_ALT) \
		$(LIBREM_BUILD_FLAGS) $(EXTRA_ARMV7) \
		PREFIX= DESTDIR=$(CONTRIB_ARMV7) \
		all install

	@rm -f $(LIBREM_PATH)/librem.*
	@make -sC $(LIBREM_PATH) CC='$(CC_SIM)' \
		BUILD=$(BUILD_I386)/librem \
		SYSROOT=$(SIMROOT) SYSROOT_ALT=$(SIMROOT_ALT) \
		$(LIBREM_BUILD_FLAGS) $(EXTRA_I386) \
		PREFIX= DESTDIR=$(CONTRIB_I386) \
		all install

	@rm -f $(LIBREM_PATH)/librem.*

	@lipo \
		-arch i386 $(CONTRIB_I386)/lib/librem.a \
		-arch armv6 $(CONTRIB_ARMV6)/lib/librem.a \
		-arch armv7 $(CONTRIB_ARMV7)/lib/librem.a \
		-create -output $(CONTRIB_FAT)/lib/librem.a


#
# baresip
#

BARESIP_BUILD_FLAGS := \
	STATIC=1 OPT_SPEED=1 \
	USE_OPENSSL= USE_ZLIB= \
	MOD_AUTODETECT= \
	USE_FFMPEG=

BARESIP_BUILD_FLAGS_I386 := \
	$(BARESIP_BUILD_FLAGS) \
	EXTRA_MODULES='g711 audiounit'

BARESIP_BUILD_FLAGS_ARMV6 := \
	$(BARESIP_BUILD_FLAGS) \
	EXTRA_MODULES='g711 audiounit'

BARESIP_BUILD_FLAGS_ARMV7 := \
	$(BARESIP_BUILD_FLAGS) \
	EXTRA_MODULES='g711 audiounit'


baresip: librem libre
	@rm -f $(BARESIP_PATH)/src/static.c ../baresip/libbaresip.*
	@make -sC $(BARESIP_PATH) CC='$(CC_ARM)' \
		BUILD=$(BUILD_ARMV6)/baresip \
		SYSROOT=$(ARMROOT) SYSROOT_ALT=$(ARMROOT_ALT) \
		$(BARESIP_BUILD_FLAGS_ARMV6) $(EXTRA_ARMV6) \
		PREFIX= DESTDIR=$(CONTRIB_ARMV6) \
		install-static

	@rm -f $(BARESIP_PATH)/src/static.c ../baresip/libbaresip.*
	@make -sC $(BARESIP_PATH) CC='$(CC_ARM)' \
		BUILD=$(BUILD_ARMV7)/baresip \
		SYSROOT=$(ARMROOT) SYSROOT_ALT=$(ARMROOT_ALT) \
		$(BARESIP_BUILD_FLAGS_ARMV7) $(EXTRA_ARMV7) \
		PREFIX= DESTDIR=$(CONTRIB_ARMV7) \
		install-static

	@rm -f $(BARESIP_PATH)/src/static.c ../baresip/libbaresip.*
	@make -sC $(BARESIP_PATH) CC='$(CC_SIM)' \
		BUILD=$(BUILD_I386)/baresip \
		SYSROOT=$(SIMROOT) SYSROOT_ALT=$(SIMROOT_ALT) \
		$(BARESIP_BUILD_FLAGS_I386) $(EXTRA_I386) \
		PREFIX= DESTDIR=$(CONTRIB_I386) \
		install-static

	@lipo \
		-arch i386 $(CONTRIB_I386)/lib/libbaresip.a \
		-arch armv6 $(CONTRIB_ARMV6)/lib/libbaresip.a \
		-arch armv7 $(CONTRIB_ARMV7)/lib/libbaresip.a \
		-create -output $(CONTRIB_FAT)/lib/libbaresip.a
