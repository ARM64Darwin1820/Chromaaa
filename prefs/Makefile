include $(THEOS)/makefiles/common.mk

ARCHS = armv7 arm64 arm64e

BUNDLE_NAME = ChromaaaPrefs
ChromaaaPrefs_FILES = *.m
ChromaaaPrefs_INSTALL_PATH = /Library/PreferenceBundles
ChromaaaPrefs_FRAMEWORKS = UIKit
ChromaaaPrefs_PRIVATE_FRAMEWORKS = Preferences
ChromaaaPrefs_EXTRA_FRAMEWORKS += Cephei CepheiPrefs

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/Prefs.plist$(ECHO_END)
