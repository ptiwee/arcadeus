###############################################################################
#
# libretro-nestopia
#
###############################################################################

LIBRETRO_NESTOPIA_VERSION = master
LIBRETRO_NESTOPIA_SITE = https://github.com/libretro/nestopia
LIBRETRO_NESTOPIA_SITE_METHOD = git
LIBRETRO_NESTOPIA_DEPENDENCIES = retroarch

define LIBRETRO_NESTOPIA_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(TARGET_MAKE_ENV) $(MAKE) \
        -C $(@D)/libretro platform="$(LIBRETRO_PLATFORM)"
endef

define LIBRETRO_NESTOPIA_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/libretro/nestopia_libretro.so \
		$(TARGET_DIR)/usr/lib/libretro/libretro_nestopia.so
endef
	
$(eval $(generic-package))
