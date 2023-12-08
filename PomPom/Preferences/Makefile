BUNDLE_NAME = PomPomPreferences
PomPomPreferences_FILES = $(wildcard *.m)
PomPomPreferences_CFLAGS = -fobjc-arc -DTHEOS_LEAN_AND_MEAN
PomPomPreferences_INSTALL_PATH = /Library/PreferenceBundles
PomPomPreferences_FRAMEWORKS = UIKit
PomPomPreferences_PRIVATE_FRAMEWORKS = Preferences
PomPomPreferences_EXTRA_FRAMEWORKS = Cephei CepheiPrefs

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/PomPomPreferences.plist$(ECHO_END)
