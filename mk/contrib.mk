#
# contrib.mk
#
# Copyright (C) 2010 - 2012 Creytiv.com
#

DEPLOYMENT_TARGET_VERSION=5.1

#
# path to external source code
#

SOURCE_PATH	:= $(shell pwd)

LIBRE_PATH	:= $(SOURCE_PATH)/re
LIBREM_PATH	:= $(SOURCE_PATH)/rem
BARESIP_PATH	:= $(SOURCE_PATH)/baresip


#
# tools and SDK
#

# Auto-detect the latest SDK
ifeq ($(SDK_VER),)
SDK_VER   := $(shell xcrun -find -sdk iphoneos --show-sdk-version)
endif
ifeq ($(SDK_VER),)
$(warning no iPhone SDK detected)
endif

SDK_MAJOR	:= $(shell echo $(SDK_VER) | cut -d'.' -f 1)
SDK_MINOR	:= $(shell echo $(SDK_VER) | cut -d'.' -f 2)
SDK_ARM		:= $(shell xcrun -find -sdk iphoneos --show-sdk-path)
SDK_SIM		:= $(shell xcrun -find -sdk iphonesimulator --show-sdk-path)
CC_ARM		:= $(shell xcrun -find -sdk iphoneos gcc)
CC_SIM		:= $(shell xcrun -find -sdk iphonesimulator gcc)

CONTRIB_DIR	:= $(PWD)/contrib
CONTRIB_AARCH64	:= $(CONTRIB_DIR)/aarch64
CONTRIB_ARMV7	:= $(CONTRIB_DIR)/armv7
CONTRIB_ARMV7S	:= $(CONTRIB_DIR)/armv7s
CONTRIB_I386	:= $(CONTRIB_DIR)/i386
CONTRIB_X86_64	:= $(CONTRIB_DIR)/x86_64
CONTRIB_FAT	:= $(CONTRIB_DIR)/fat

BUILD_DIR	:= $(PWD)/build
BUILD_AARCH64	:= $(BUILD_DIR)/aarch64
BUILD_ARMV7	:= $(BUILD_DIR)/armv7
BUILD_ARMV7S	:= $(BUILD_DIR)/armv7s
BUILD_I386	:= $(BUILD_DIR)/i386
BUILD_X86_64	:= $(BUILD_DIR)/x86_64
BUILD_FAT	:= $(BUILD_DIR)/fat

ARMROOT		:= $(SDK_ARM)/usr
ARMROOT_ALT	:= $(CONTRIB_FAT)
SIMROOT		:= $(SDK_SIM)/usr
SIMROOT_ALT	:= $(CONTRIB_FAT)

EXTRA_CFLAGS       := -DIPHONE -pipe -no-cpp-precomp -isysroot $(SDK_ARM)
EXTRA_CFLAGS_SIM   := -DIPHONE -pipe -no-cpp-precomp -isysroot $(SDK_SIM)
EXTRA_CFLAGS_AARCH64 := -arch aarch64 -I$(CONTRIB_AARCH64)/include $(EXTRA_CFLAGS)
EXTRA_CFLAGS_ARMV7 := -arch armv7 -I$(CONTRIB_ARMV7)/include $(EXTRA_CFLAGS)
EXTRA_CFLAGS_ARMV7S := -arch armv7s -I$(CONTRIB_ARMV7S)/include $(EXTRA_CFLAGS)
EXTRA_CFLAGS_I386  := -arch i386 -I$(CONTRIB_I386)/include $(EXTRA_CFLAGS_SIM)
EXTRA_CFLAGS_X86_64  := -arch x86_64 -I$(CONTRIB_X86_64)/include $(EXTRA_CFLAGS_SIM)

EXTRA_LFLAGS       := -L$(CONTRIB_FAT)/lib -isysroot $(SDK_ARM)
EXTRA_LFLAGS_SIM   := -L$(CONTRIB_FAT)/lib -isysroot $(SDK_SIM)
EXTRA_LFLAGS_AARCH64 := -arch aarch64 -L$(CONTRIB_AARCH64)/lib $(EXTRA_LFLAGS)
EXTRA_LFLAGS_ARMV7 := -arch armv7 -L$(CONTRIB_ARMV7)/lib $(EXTRA_LFLAGS)
EXTRA_LFLAGS_ARMV7S := -arch armv7s -L$(CONTRIB_ARMV7S)/lib $(EXTRA_LFLAGS)
EXTRA_LFLAGS_I386  := -arch i386 -L$(CONTRIB_I386)/lib $(EXTRA_LFLAGS_SIM)
EXTRA_LFLAGS_X86_64  := -arch x86_64 -L$(CONTRIB_X86_64)/lib $(EXTRA_LFLAGS_SIM)


EXTRA_I386      := \
	EXTRA_CFLAGS='-D__DARWIN_ONLY_UNIX_CONFORMANCE \
		-mios-simulator-version-min=$(DEPLOYMENT_TARGET_VERSION) \
		-Wno-cast-align -Wno-shorten-64-to-32 \
		-Wno-aggregate-return \
		-arch i386 \
		-isysroot $(SDK_SIM) \
		-I$(CONTRIB_I386)/include \
		-I$(CONTRIB_I386)/include/rem' \
	OBJCFLAGS='-fobjc-abi-version=2 -fobjc-legacy-dispatch' \
	EXTRA_LFLAGS='-mios-simulator-version-min=$(DEPLOYMENT_TARGET_VERSION) -arch i386 -L$(CONTRIB_FAT)/lib \
		-isysroot $(SDK_SIM)'

EXTRA_X86_64      := \
	EXTRA_CFLAGS='-D__DARWIN_ONLY_UNIX_CONFORMANCE \
		-mios-simulator-version-min=$(DEPLOYMENT_TARGET_VERSION) \
		-Wno-cast-align -Wno-shorten-64-to-32 \
		-Wno-aggregate-return \
		-arch x86_64 \
		-isysroot $(SDK_SIM) \
		-I$(CONTRIB_X86_64)/include \
		-I$(CONTRIB_X86_64)/include/rem' \
	OBJCFLAGS='-fobjc-abi-version=2 -fobjc-legacy-dispatch' \
	EXTRA_LFLAGS='-mios-simulator-version-min=$(DEPLOYMENT_TARGET_VERSION) -arch x86_64 -L$(CONTRIB_FAT)/lib \
		-isysroot $(SDK_SIM)'

EXTRA_AARCH64       := \
	EXTRA_CFLAGS='-arch arm64 \
		-I$(CONTRIB_AARCH64)/include \
		-I$(CONTRIB_AARCH64)/include/rem \
		-Wno-cast-align -Wno-shorten-64-to-32 \
		-Wno-aggregate-return \
		-miphoneos-version-min=$(DEPLOYMENT_TARGET_VERSION) \
		-isysroot $(SDK_ARM) -DHAVE_AARCH64' \
	EXTRA_LFLAGS='-arch arm64 -mcpu=generic -marm \
		-L$(CONTRIB_FAT)/lib -isysroot $(SDK_ARM)' \
	OS=darwin ARCH=arm64 CROSS_COMPILE=$(ARM_MACHINE) \
	HAVE_ARM64=1

EXTRA_ARMV7       := \
	EXTRA_CFLAGS='-arch armv7 \
		-I$(CONTRIB_ARMV7)/include \
		-I$(CONTRIB_ARMV7)/include/rem \
		-Wno-cast-align -Wno-shorten-64-to-32 \
		-Wno-aggregate-return \
		-miphoneos-version-min=$(DEPLOYMENT_TARGET_VERSION) \
		-isysroot $(SDK_ARM) -DHAVE_NEON' \
	EXTRA_LFLAGS='-arch armv7 -mcpu=cortex-a8 -mfpu=neon -marm \
		-L$(CONTRIB_FAT)/lib -isysroot $(SDK_ARM)' \
	OS=darwin ARCH=armv7 CROSS_COMPILE=$(ARM_MACHINE) \
	HAVE_NEON=1

EXTRA_ARMV7S       := \
	EXTRA_CFLAGS='-arch armv7s \
		-I$(CONTRIB_ARMV7S)/include \
		-I$(CONTRIB_ARMV7S)/include/rem \
		-Wno-cast-align -Wno-shorten-64-to-32 \
		-Wno-aggregate-return \
		-miphoneos-version-min=$(DEPLOYMENT_TARGET_VERSION) \
		-isysroot $(SDK_ARM) -DHAVE_NEON' \
	EXTRA_LFLAGS='-arch armv7s -mcpu=cortex-a8 -mfpu=neon -marm \
		-L$(CONTRIB_FAT)/lib -isysroot $(SDK_ARM)' \
	OS=darwin ARCH=armv7s CROSS_COMPILE=$(ARM_MACHINE) \
	HAVE_NEON=1


#
# common targets
#

.PHONY: contrib
contrib:	baresip


$(BUILD_AARCH64) $(BUILD_ARMV7) $(BUILD_ARMV7S) $(BUILD_I386) $(BUILD_X86_64) $(BUILD_FAT):
	@mkdir -p $@

$(CONTRIB_FAT) $(CONTRIB_FAT)/lib:
	@mkdir -p $@


#
# libre
#

LIBRE_BUILD_FLAGS := \
	USE_OPENSSL= USE_ZLIB= OPT_SPEED=1 USE_APPLE_COMMONCRYPTO=1

libre: $(CONTRIB_FAT)/lib
	@rm -f $(LIBRE_PATH)/libre.*
	@make -sC $(LIBRE_PATH) CC='$(CC_ARM)' \
		BUILD=$(BUILD_AARCH64)/libre \
		SYSROOT=$(ARMROOT) SYSROOT_ALT=$(ARMROOT_ALT) \
		$(LIBRE_BUILD_FLAGS) $(EXTRA_AARCH64) \
		PREFIX= DESTDIR=$(CONTRIB_AARCH64) \
		all install

	@rm -f $(LIBRE_PATH)/libre.*
	@make -sC $(LIBRE_PATH) CC='$(CC_ARM)' \
		BUILD=$(BUILD_ARMV7S)/libre \
		SYSROOT=$(ARMROOT) SYSROOT_ALT=$(ARMROOT_ALT) \
		$(LIBRE_BUILD_FLAGS) $(EXTRA_ARMV7S) \
		PREFIX= DESTDIR=$(CONTRIB_ARMV7S) \
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
	@make -sC $(LIBRE_PATH) CC='$(CC_SIM)' \
		BUILD=$(BUILD_X86_64)/libre \
		SYSROOT=$(SIMROOT) SYSROOT_ALT=$(SIMROOT_ALT) \
		$(LIBRE_BUILD_FLAGS) $(EXTRA_X86_64) \
		PREFIX= DESTDIR=$(CONTRIB_X86_64) \
		all install

	@rm -f $(LIBRE_PATH)/libre.*

	@lipo \
		-arch i386 $(CONTRIB_I386)/lib/libre.a \
		-arch x86_64 $(CONTRIB_X86_64)/lib/libre.a \
		-arch arm64 $(CONTRIB_AARCH64)/lib/libre.a \
		-arch armv7 $(CONTRIB_ARMV7)/lib/libre.a \
		-arch armv7s $(CONTRIB_ARMV7S)/lib/libre.a \
		-create -output $(CONTRIB_FAT)/lib/libre.a


#
# librem
#

LIBREM_BUILD_FLAGS := \
	OPT_SPEED=1

librem: libre
	@rm -f $(LIBREM_PATH)/librem.*
	@make -sC $(LIBREM_PATH) CC='$(CC_ARM)' \
		BUILD=$(BUILD_AARCH64)/librem \
		SYSROOT=$(ARMROOT) SYSROOT_ALT=$(ARMROOT_ALT) \
		$(LIBREM_BUILD_FLAGS) $(EXTRA_AARCH64) \
		PREFIX= DESTDIR=$(CONTRIB_AARCH64) \
		all install

	@rm -f $(LIBREM_PATH)/librem.*
	@make -sC $(LIBREM_PATH) CC='$(CC_ARM)' \
		BUILD=$(BUILD_ARMV7)/librem \
		SYSROOT=$(ARMROOT) SYSROOT_ALT=$(ARMROOT_ALT) \
		$(LIBREM_BUILD_FLAGS) $(EXTRA_ARMV7) \
		PREFIX= DESTDIR=$(CONTRIB_ARMV7) \
		all install

	@rm -f $(LIBREM_PATH)/librem.*
	@make -sC $(LIBREM_PATH) CC='$(CC_ARM)' \
		BUILD=$(BUILD_ARMV7S)/librem \
		SYSROOT=$(ARMROOT) SYSROOT_ALT=$(ARMROOT_ALT) \
		$(LIBREM_BUILD_FLAGS) $(EXTRA_ARMV7S) \
		PREFIX= DESTDIR=$(CONTRIB_ARMV7S) \
		all install

	@rm -f $(LIBREM_PATH)/librem.*
	@make -sC $(LIBREM_PATH) CC='$(CC_SIM)' \
		BUILD=$(BUILD_I386)/librem \
		SYSROOT=$(SIMROOT) SYSROOT_ALT=$(SIMROOT_ALT) \
		$(LIBREM_BUILD_FLAGS) $(EXTRA_I386) \
		PREFIX= DESTDIR=$(CONTRIB_I386) \
		all install

	@rm -f $(LIBREM_PATH)/librem.*
	@make -sC $(LIBREM_PATH) CC='$(CC_SIM)' \
		BUILD=$(BUILD_X86_64)/librem \
		SYSROOT=$(SIMROOT) SYSROOT_ALT=$(SIMROOT_ALT) \
		$(LIBREM_BUILD_FLAGS) $(EXTRA_X86_64) \
		PREFIX= DESTDIR=$(CONTRIB_X86_64) \
		all install

	@rm -f $(LIBREM_PATH)/librem.*

	@lipo \
		-arch i386 $(CONTRIB_I386)/lib/librem.a \
		-arch x86_64 $(CONTRIB_X86_64)/lib/librem.a \
		-arch arm64 $(CONTRIB_AARCH64)/lib/librem.a \
		-arch armv7 $(CONTRIB_ARMV7)/lib/librem.a \
		-arch armv7s $(CONTRIB_ARMV7S)/lib/librem.a \
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
	EXTRA_MODULES='g711 audiounit avcapture opengles'

BARESIP_BUILD_FLAGS_X86_64 := \
	$(BARESIP_BUILD_FLAGS) \
	EXTRA_MODULES='g711 audiounit avcapture opengles'

BARESIP_BUILD_FLAGS_AARCH64 := \
	$(BARESIP_BUILD_FLAGS) \
	EXTRA_MODULES='g711 audiounit avcapture opengles'

BARESIP_BUILD_FLAGS_ARMV7 := \
	$(BARESIP_BUILD_FLAGS) \
	EXTRA_MODULES='g711 audiounit avcapture opengles'

BARESIP_BUILD_FLAGS_ARMV7S := \
	$(BARESIP_BUILD_FLAGS) \
	EXTRA_MODULES='g711 audiounit avcapture opengles'


baresip: librem libre
	@rm -f $(BARESIP_PATH)/src/static.c ../baresip/libbaresip.*
	@make -sC $(BARESIP_PATH) CC='$(CC_ARM)' \
		BUILD=$(BUILD_AARCH64)/baresip \
		SYSROOT=$(ARMROOT) SYSROOT_ALT=$(ARMROOT_ALT) \
		$(BARESIP_BUILD_FLAGS_AARCH64) $(EXTRA_AARCH64) \
		PREFIX= DESTDIR=$(CONTRIB_AARCH64) \
		install-static

	@rm -f $(BARESIP_PATH)/src/static.c ../baresip/libbaresip.*
	@make -sC $(BARESIP_PATH) CC='$(CC_ARM)' \
		BUILD=$(BUILD_ARMV7)/baresip \
		SYSROOT=$(ARMROOT) SYSROOT_ALT=$(ARMROOT_ALT) \
		$(BARESIP_BUILD_FLAGS_ARMV7) $(EXTRA_ARMV7) \
		PREFIX= DESTDIR=$(CONTRIB_ARMV7) \
		install-static

	@rm -f $(BARESIP_PATH)/src/static.c ../baresip/libbaresip.*
	@make -sC $(BARESIP_PATH) CC='$(CC_ARM)' \
		BUILD=$(BUILD_ARMV7S)/baresip \
		SYSROOT=$(ARMROOT) SYSROOT_ALT=$(ARMROOT_ALT) \
		$(BARESIP_BUILD_FLAGS_ARMV7S) $(EXTRA_ARMV7S) \
		PREFIX= DESTDIR=$(CONTRIB_ARMV7S) \
		install-static

	@rm -f $(BARESIP_PATH)/src/static.c ../baresip/libbaresip.*
	@make -sC $(BARESIP_PATH) CC='$(CC_SIM)' \
		BUILD=$(BUILD_I386)/baresip \
		SYSROOT=$(SIMROOT) SYSROOT_ALT=$(SIMROOT_ALT) \
		$(BARESIP_BUILD_FLAGS_I386) $(EXTRA_I386) \
		PREFIX= DESTDIR=$(CONTRIB_I386) \
		install-static

	@rm -f $(BARESIP_PATH)/src/static.c ../baresip/libbaresip.*
	@make -sC $(BARESIP_PATH) CC='$(CC_SIM)' \
		BUILD=$(BUILD_X86_64)/baresip \
		SYSROOT=$(SIMROOT) SYSROOT_ALT=$(SIMROOT_ALT) \
		$(BARESIP_BUILD_FLAGS_X86_64) $(EXTRA_X86_64) \
		PREFIX= DESTDIR=$(CONTRIB_X86_64) \
		install-static

	@lipo \
		-arch i386 $(CONTRIB_I386)/lib/libbaresip.a \
		-arch x86_64 $(CONTRIB_X86_64)/lib/libbaresip.a \
		-arch arm64 $(CONTRIB_AARCH64)/lib/libbaresip.a \
		-arch armv7 $(CONTRIB_ARMV7)/lib/libbaresip.a \
		-arch armv7s $(CONTRIB_ARMV7S)/lib/libbaresip.a \
		-create -output $(CONTRIB_FAT)/lib/libbaresip.a


info:
	@echo "SDK_VER:    $(SDK_VER)"
	@echo "SDK_ARM:    $(SDK_ARM)"
	@echo "SDK_SIM:    $(SDK_SIM)"
	@echo "CC_ARM:     $(CC_ARM)"
	@echo "CC_SIM:     $(CC_SIM)"
