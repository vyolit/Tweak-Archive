export ARCHS = arm64 arm64e
export TARGET = appletv:clang:13.4:13.0
export SYSROOT = $(THEOS)/sdks/tvOS/13/AppleTVOS13.4.sdk
export PREFIX = $(THEOS)/toolchain/Xcode.xctoolchain/usr/bin/

SUBPROJECTS += Tweak Preferences

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/aggregate.mk
