###############################################################################
#
# libretro-pocketsnes
#
###############################################################################

LIBRETRO_POCKETSNES_VERSION = master
LIBRETRO_POCKETSNES_SITE = https://github.com/libretro/snes9x2002
LIBRETRO_POCKETSNES_SITE_METHOD = git
LIBRETRO_POCKETSNES_DEPENDENCIES = retroarch

define LIBRETRO_POCKETSNES_FIXUP
	$(SED) 's/ifeq (\(.*\), \(.*\))/ifneq (,$$(findstring \2,\1))/g' \
		$(LIBRETRO_POCKETSNES_DIR)/Makefile
endef

LIBRETRO_POCKETSNES_PRE_CONFIGURE_HOOKS += LIBRETRO_POCKETSNES_FIXUP

define LIBRETRO_POCKETSNES_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(TARGET_MAKE_ENV) $(MAKE) \
        -C $(@D) platform="$(LIBRETRO_PLATFORM)" ARM_ASM=1
endef

define LIBRETRO_POCKETSNES_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/snes9x2002_libretro.so \
		$(TARGET_DIR)/usr/lib/libretro/libretro_pocketsnes.so
endef
	
$(eval $(generic-package))
