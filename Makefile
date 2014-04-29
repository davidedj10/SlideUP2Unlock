export THEOS_DEVICE_IP=127.0.0.1 
export THEOS_DEVICE_PORT=2222
include theos/makefiles/common.mk

TWEAK_NAME = SlideUP2Unlock
SlideUP2Unlock_FILES = Tweak.xm
SlideUP2Unlock_FRAMEWORKS = UIKit QuartzCore
export SDKVERSION_armv6 = 5.1
export TARGET_IPHONEOS_DEPLOYMENT_VERSION = 3.0
export TARGET_IPHONEOS_DEPLOYMENT_VERSION_armv7s = 6.0
export TARGET_IPHONEOS_DEPLOYMENT_VERSION_arm64 = 7.0
export ARCHS = armv7 armv7s arm64
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
