# THEOS_DEVICE_IP = 192.168.68.80

ARCHS = arm64
DEBUG = 0
FINALPACKAGE = 1
FOR_RELEASE = 1

# THEOS_PACKAGE_SCHEME = rootless

TARGET := iphone:clang:latest:13.0
@@KILL_RULE@@

include @@THEOS@@/makefiles/common.mk

TWEAK_NAME = @@PROJECTNAME@@

$(TWEAK_NAME)_FILES += Tweak.xm
$(TWEAK_NAME)_CFLAGS += -fobjc-arc -std=c++17 -O3 -W -Wno-deprecated-declarations -Wno-error=unused-variable -Wno-unused-parameter -Wno-error=unused-function -Wno-error=unguarded-availability-new -nostdlib -static -fvisibility=hidden -fvisibility-inlines-hidden
$(TWEAK_NAME)_CCFLAGS += -fobjc-arc -std=c++17 -O3 -W -Wno-deprecated-declarations -Wno-error=unused-variable -Wno-unused-parameter -Wno-error=unused-function -Wno-error=unguarded-availability-new -nostdlib -static -fvisibility=hidden -fvisibility-inlines-hidden
$(TWEAK_NAME)_LIBRARIES += substrate
$(TWEAK_NAME)_FRAMEWORKS += UIKit Foundation Security QuartzCore CoreGraphics CoreText

include $(THEOS_MAKE_PATH)/tweak.mk
