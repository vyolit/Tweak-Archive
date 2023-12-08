BUNDLE_NAME = BalletPreferences
$(BUNDLE_NAME)_FILES = $(wildcard *.m)
$(BUNDLE_NAME)_INSTALL_PATH = /Library/PreferenceBundles
$(BUNDLE_NAME)_FRAMEWORKS = UIKit TVSettingKit 
$(BUNDLE_NAME)_PRIVATE_FRAMEWORKS = TVSettingKit
$(BUNDLE_NAME)_CFLAGS+= -I. -ITVSettings -ITVSettingsKit
$(BUNDLE_NAME)_LDFLAGS = -undefined dynamic_lookup
ADDITIONAL_CFLAGS += -DTHEOS_LEAN_AND_MEAN

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/BalletPreferences.plist$(ECHO_END)
