
THEOS_DEVICE_IP = 172.20.10.1
#THEOS_DEVICE_IP = 192.168.11.214
ARCHS = arm64 armv7
TARGET = iphone:clang:8.1
include theos/makefiles/common.mk

TWEAK_NAME = weixinPhoneBookAssist
weixinPhoneBookAssist_FILES = weixinPhoneBookAssist.xm 
weixinPhoneBookAssist_FRAMEWORKS = UIKit Foundation
weixinPhoneBookAssist_PRIVATE_FRAMEWORKS = AppSupport CoreTelephony

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
