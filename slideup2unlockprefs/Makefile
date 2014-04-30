include theos/makefiles/common.mk

BUNDLE_NAME = SlideUP2UnlockPrefs
SlideUP2UnlockPrefs_FILES = SlideUP2UnlockPrefs.mm
SlideUP2UnlockPrefs_INSTALL_PATH = /Library/PreferenceBundles
SlideUP2UnlockPrefs_FRAMEWORKS = UIKit
SlideUP2UnlockPrefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/SlideUP2UnlockPrefs.plist$(ECHO_END)
