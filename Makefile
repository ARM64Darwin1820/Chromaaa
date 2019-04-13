include $(THEOS)/makefiles/common.mk

ARCHS = armv7 arm64 arm64e

GO_EASY_ON_ME=1

TWEAK_NAME = Chromaaa
Chromaaa_FILES = Tweak.xm
Chromaaa_EXTRA_FRAMEWORKS += Cephei CepheiPrefs

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += prefs
include $(THEOS_MAKE_PATH)/aggregate.mk
