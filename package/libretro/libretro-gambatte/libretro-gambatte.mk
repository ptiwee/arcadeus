###############################################################################
#
# libretro-gambatte
#
###############################################################################

LIBRETRO_GAMBATTE_VERSION = master
LIBRETRO_GAMBATTE_SITE = https://github.com/libretro/gambatte-libretro
LIBRETRO_GAMBATTE_SITE_METHOD = git
LIBRETRO_GAMBATTE_DEPENDENCIES = retroarch

define LIBRETRO_GAMBATTE_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(TARGET_MAKE_ENV) $(MAKE) \
        -C $(@D) -f Makefile.libretro platform="$(LIBRETRO_PLATFORM)"
endef

define LIBRETRO_GAMBATTE_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/gambatte_libretro.so \
		$(TARGET_DIR)/usr/lib/libretro/libretro_gambatte.so
endef
	
$(eval $(generic-package))
