###############################################################################
#
# libretro-fba
#
###############################################################################

LIBRETRO_FBA_VERSION = v0.2.97.38
LIBRETRO_FBA_SITE = https://github.com/libretro/fbalpha
LIBRETRO_FBA_SITE_METHOD = git
LIBRETRO_FBA_DEPENDENCIES = retroarch

define LIBRETRO_FBA_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(TARGET_MAKE_ENV) $(MAKE) \
        -C $(@D) -f makefile.libretro platform="$(LIBRETRO_PLATFORM)"
endef

define LIBRETRO_FBA_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/fbalpha_libretro.so \
		$(TARGET_DIR)/usr/lib/libretro/libretro_fba.so
endef
	
$(eval $(generic-package))
