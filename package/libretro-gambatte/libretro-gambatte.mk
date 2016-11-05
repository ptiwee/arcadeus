###############################################################################
#
# libretro-gambatte
#
###############################################################################

LIBRETRO_GAMBATTE_VERSION = master
LIBRETRO_GAMBATTE_SITE = https://github.com/libretro/gambatte-libretro.git
LIBRETRO_GAMBATTE_SITE_METHOD = git
LIBRETRO_GAMBATTE_DEPENDENCIES = retroarch

# Raspberry Pi Zero and 1
ifeq ($(BR2_arm1176jzf_s),y)
	LIBRETRO_GAMBATTE_PLATFORM += rpi1
endif

#Raspberry Pi 2
ifeq ($(BR2_cortex_a7),y)
	LIBRETRO_GAMBATTE_PLATFORM += rpi2
endif

#Raspberry Pi 3
ifeq ($(BR2_cortex_a8),y)
	LIBRETRO_GAMBATTE_PLATFORM += rpi3
endif

define LIBRETRO_GAMBATTE_BUILD_CMDS
	CFLAGS="$(TARGET_CFLAGS)" CXXFLAGS="$(TARGET_CXXFLAGS)" $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" LD="$(TARGET_LD)" -C $(@D) -f Makefile.libretro platform="$(LIBRETRO_GAMBATTE_PLATFORM)"
endef

define LIBRETRO_GAMBATTE_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/gambatte_libretro.so \
		$(TARGET_DIR)/usr/lib/libretro/libretro_gambatte.so
endef
	
$(eval $(generic-package))
