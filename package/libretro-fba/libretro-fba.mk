###############################################################################
#
# libretro-fba
#
###############################################################################

LIBRETRO_FBA_VERSION = 0d122c3
LIBRETRO_FBA_SITE = https://github.com/libretro/fbalpha.git
LIBRETRO_FBA_SITE_METHOD = git
LIBRETRO_FBA_DEPENDENCIES = retroarch

#Raspberry Pi 2
ifeq ($(BR2_cortex_a7),y)
	LIBRETRO_FBA_PLATFORM += rpi2
endif

#Raspberry Pi 3
ifeq ($(BR2_cortex_a8),y)
	LIBRETRO_FBA_PLATFORM += rpi3
endif

define LIBRETRO_FBA_BUILD_CMDS
	CFLAGS="$(TARGET_CFLAGS)" \
	CXXFLAGS="$(TARGET_CXXFLAGS)" \
	$(MAKE) CXX="$(TARGET_CXX)" \
	CC="$(TARGET_CC)" LD="$(TARGET_LD)" \
	-C $(@D) -f makefile.libretro platform="$(LIBRETRO_FBA_PLATFORM)"
endef

define LIBRETRO_FBA_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/fbalpha_libretro.so \
		$(TARGET_DIR)/usr/lib/libretro/libretro_fba.so
endef
	
$(eval $(generic-package))
