###############################################################################
#
# libretro-genesisplusgx
#
###############################################################################

LIBRETRO_GENESISPLUSGX_VERSION = master
LIBRETRO_GENESISPLUSGX_SITE = https://github.com/libretro/Genesis-Plus-GX.git
LIBRETRO_GENESISPLUSGX_SITE_METHOD = git
LIBRETRO_GENESISPLUSGX_DEPENDENCIES = retroarch

# Raspberry Pi Zero and 1
ifeq ($(BR2_arm1176jzf_s),y)
	LIBRETRO_GENESISPLUSGX_PLATFORM += rpi1
endif

#Raspberry Pi 2
ifeq ($(BR2_cortex_a7),y)
	LIBRETRO_GENESISPLUSGX_PLATFORM += rpi2
endif

#Raspberry Pi 3
ifeq ($(BR2_cortex_a8),y)
	LIBRETRO_GENESISPLUSGX_PLATFORM += rpi3
endif

define LIBRETRO_GENESISPLUSGX_BUILD_CMDS
	CFLAGS="$(TARGET_CFLAGS)" CXXFLAGS="$(TARGET_CXXFLAGS)" $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" LD="$(TARGET_LD)" -C $(@D) -f Makefile.libretro platform="$(LIBRETRO_GENESISPLUSGX_PLATFORM)"
endef

define LIBRETRO_GENESISPLUSGX_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/genesis_plus_gx_libretro.so \
		$(TARGET_DIR)/usr/lib/libretro/libretro_genesisplusgx.so
endef
	
$(eval $(generic-package))
