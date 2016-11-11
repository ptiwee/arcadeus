###############################################################################
#
# libretro-pocketsnes
#
###############################################################################

LIBRETRO_POCKETSNES_VERSION = 3c15d69
LIBRETRO_POCKETSNES_SITE = https://github.com/libretro/snes9x2002.git
LIBRETRO_POCKETSNES_SITE_METHOD = git
LIBRETRO_POCKETSNES_DEPENDENCIES = retroarch

define LIBRETRO_POCKETSNES_BUILD_CMDS
	CFLAGS="$(TARGET_CFLAGS)" \
	CXXFLAGS="$(TARGET_CXXFLAGS)" \
	$(MAKE) CXX="$(TARGET_CXX)" \
	CC="$(TARGET_CC)" \
	LD="$(TARGET_LD)" \
	-C $(@D) ARM_ASM=1
endef

define LIBRETRO_POCKETSNES_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/snes9x2002_libretro.so \
		$(TARGET_DIR)/usr/lib/libretro/libretro_pocketsnes.so
endef
	
$(eval $(generic-package))
