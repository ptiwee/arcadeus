###############################################################################
#
# libretro-gpsp
#
###############################################################################

LIBRETRO_GPSP_VERSION = master
LIBRETRO_GPSP_SITE = https://github.com/libretro/gpsp
LIBRETRO_GPSP_SITE_METHOD = git
LIBRETRO_GPSP_DEPENDENCIES = retroarch

define LIBRETRO_GPSP_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(TARGET_MAKE_ENV) $(MAKE) \
        -C $(@D) platform="$(LIBRETRO_PLATFORM)"
endef

define LIBRETRO_GPSP_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/gpsp_libretro.so \
		$(TARGET_DIR)/usr/lib/libretro/libretro_gpsp.so
endef
	
$(eval $(generic-package))
