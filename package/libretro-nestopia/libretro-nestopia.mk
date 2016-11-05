###############################################################################
#
# libretro-nestopia
#
###############################################################################

LIBRETRO_NESTOPIA_VERSION = master
LIBRETRO_NESTOPIA_SITE = https://github.com/libretro/nestopia.git
LIBRETRO_NESTOPIA_SITE_METHOD = git
LIBRETRO_NESTOPIA_DEPENDENCIES = retroarch

#Raspberry Pi 2
ifeq ($(BR2_cortex_a7),y)
	LIBRETRO_NESTOPIA_PLATFORM += rpi2
endif

#Raspberry Pi 3
ifeq ($(BR2_cortex_a8),y)
	LIBRETRO_NESTOPIA_PLATFORM += rpi3
endif

define LIBRETRO_NESTOPIA_BUILD_CMDS
	CFLAGS="$(TARGET_CFLAGS)" CXXFLAGS="$(TARGET_CXXFLAGS)" $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" LD="$(TARGET_LD)" -C $(@D)/libretro platform="$(LIBRETRO_NESTOPIA_PLATFORM)"
endef

define LIBRETRO_NESTOPIA_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/libretro/nestopia_libretro.so \
		$(TARGET_DIR)/usr/lib/libretro/libretro_nestopia.so
endef
	
$(eval $(generic-package))
