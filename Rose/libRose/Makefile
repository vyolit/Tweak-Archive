LIBRARY_NAME = libRose
$(LIBRARY_NAME)_OBJC_FILES = libRose.m
$(LIBRARY_NAME)_FRAMEWORKS = UIKit AudioToolbox
$(LIBRARY_NAME)_CFLAGS = -I./ -Ipublic -Ioverlayheaders -I. -fobjc-arc -DTHEOS_LEAN_AND_MEAN
$(LIBRARY_NAME)_USE_MODULES = 0

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/library.mk

stage::
	mkdir -p $(THEOS_STAGING_DIR)/usr/include/libRose
	$(ECHO_NOTHING)rsync -a ./public/* $(THEOS_STAGING_DIR)/usr/include/Rose $(FW_RSYNC_EXCLUDES)$(ECHO_END)
	mkdir -p $(THEOS)/include/Rose
	cp -r ./public/* $(THEOS)/include/Rose
	cp $(THEOS_STAGING_DIR)/usr/lib/libRose.dylib $(THEOS)/lib/libRose.dylib