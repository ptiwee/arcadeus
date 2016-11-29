###############################################################################
#
# libretro-glupen64
#
###############################################################################

LIBRETRO_GLUPEN64_VERSION = 2f6e51b
LIBRETRO_GLUPEN64_SITE = https://github.com/loganmc10/GLupeN64
LIBRETRO_GLUPEN64_SITE_METHOD = git
LIBRETRO_GLUPEN64_DEPENDENCIES = retroarch

# Raspberry Pi Zero and 1
ifeq ($(BR2_arm1176jzf_s),y)
	LIBRETRO_PLATFORM += rpi1
endif

#Raspberry Pi 2
ifeq ($(BR2_cortex_a7),y)
	LIBRETRO_PLATFORM += rpi2
endif

#Raspberry Pi 3
ifeq ($(BR2_cortex_a8),y)
	LIBRETRO_PLATFORM += rpi3
endif

define LIBRETRO_GLUPEN64_BUILD_CMDS
	CFLAGS="$(TARGET_CFLAGS)" \
	CXXFLAGS="$(TARGET_CXXFLAGS)" \
	$(MAKE) CXX="$(TARGET_CXX)" \
	CC="$(TARGET_CC)" \
	LD="$(TARGET_LD)" \
	-C $(@D) platform="$(LIBRETRO_PLATFORM)"
endef

define LIBRETRO_GLUPEN64_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/glupen64_libretro.so \
		$(TARGET_DIR)/usr/lib/libretro/libretro_glupen64.so
endef
	
$(eval $(generic-package))
