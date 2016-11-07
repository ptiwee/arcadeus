###############################################################################
#
# libretro-glupen64
#
###############################################################################

LIBRETRO_GLUPEN64_VERSION = master
LIBRETRO_GLUPEN64_SITE = https://github.com/loganmc10/GLupeN64
LIBRETRO_GLUPEN64_SITE_METHOD = git
LIBRETRO_GLUPEN64_DEPENDENCIES = retroarch

LIBRETRO_GLUPEN64_PLATFORM += rpi3

define LIBRETRO_GLUPEN64_BUILD_CMDS
	CFLAGS="$(TARGET_CFLAGS)" CXXFLAGS="$(TARGET_CXXFLAGS)" $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" LD="$(TARGET_LD)" -C $(@D) platform="$(LIBRETRO_GLUPEN64_PLATFORM)"
endef

define LIBRETRO_GLUPEN64_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/glupen64_libretro.so \
		$(TARGET_DIR)/usr/lib/libretro/libretro_glupen64.so
endef
	
$(eval $(generic-package))
