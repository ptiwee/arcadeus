###############################################################################
#
# libretro-genesisplusgx
#
###############################################################################

LIBRETRO_GENESISPLUSGX_VERSION = master
LIBRETRO_GENESISPLUSGX_SITE = https://github.com/libretro/Genesis-Plus-GX
LIBRETRO_GENESISPLUSGX_SITE_METHOD = git
LIBRETRO_GENESISPLUSGX_DEPENDENCIES = retroarch

define LIBRETRO_GENESISPLUSGX_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(TARGET_MAKE_ENV) $(MAKE) \
        -C $(@D) -f Makefile.libretro platform="$(LIBRETRO_PLATFORM)"
endef

define LIBRETRO_GENESISPLUSGX_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/genesis_plus_gx_libretro.so \
		$(TARGET_DIR)/usr/lib/libretro/libretro_genesisplusgx.so
endef
	
$(eval $(generic-package))
