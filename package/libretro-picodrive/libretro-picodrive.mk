###############################################################################
#
# libretro-picodrive
#
###############################################################################

LIBRETRO_PICODRIVE_VERSION = 0d87bd6
LIBRETRO_PICODRIVE_SITE = https://github.com/libretro/picodrive.git
LIBRETRO_PICODRIVE_SITE_METHOD = git
LIBRETRO_PICODRIVE_DEPENDENCIES = retroarch

define LIBRETRO_PICODRIVE_BUILD_CMDS
	CFLAGS="$(TARGET_CFLAGS)" \
	CXXFLAGS="$(TARGET_CXXFLAGS)" \
	$(MAKE) CXX="$(TARGET_CXX)" \
	CC="$(TARGET_CC)" \
	LD="$(TARGET_LD)" \
	-C $(@D) -f Makefile.libretro
endef

define LIBRETRO_PICODRIVE_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/picodrive_libretro.so \
		$(TARGET_DIR)/usr/lib/libretro/libretro_picodrive.so
endef
	
$(eval $(generic-package))
