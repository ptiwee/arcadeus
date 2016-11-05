###############################################################################
#
# libretro-beetle-ngp
#
###############################################################################

LIBRETRO_BEETLE_NGP_VERSION = master
LIBRETRO_BEETLE_NGP_SITE = https://github.com/libretro/beetle-ngp-libretro.git
LIBRETRO_BEETLE_NGP_SITE_METHOD = git
LIBRETRO_BEETLE_NGP_DEPENDENCIES = retroarch

define LIBRETRO_BEETLE_NGP_BUILD_CMDS
	CFLAGS="$(TARGET_CFLAGS)" CXXFLAGS="$(TARGET_CXXFLAGS)" $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" LD="$(TARGET_LD)" -C $(@D)
endef

define LIBRETRO_BEETLE_NGP_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/mednafen_ngp_libretro.so \
		$(TARGET_DIR)/usr/lib/libretro/libretro_beetle_ngp.so
endef
	
$(eval $(generic-package))
