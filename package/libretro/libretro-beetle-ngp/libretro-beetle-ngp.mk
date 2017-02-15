###############################################################################
#
# libretro-beetle-ngp
#
###############################################################################

LIBRETRO_BEETLE_NGP_VERSION = master
LIBRETRO_BEETLE_NGP_SITE = https://github.com/libretro/beetle-ngp-libretro
LIBRETRO_BEETLE_NGP_SITE_METHOD = git
LIBRETRO_BEETLE_NGP_DEPENDENCIES = retroarch

define LIBRETRO_BEETLE_NGP_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(TARGET_MAKE_ENV) $(MAKE) \
        -C $(@D) platform="$(LIBRETRO_PLATFORM)"
endef

define LIBRETRO_BEETLE_NGP_FIXUP
	$(SED) 's/ifeq (\(.*\), \(.*\))/ifneq (,$$(findstring \2,\1))/g' \
		$(LIBRETRO_BEETLE_NGP_DIR)/Makefile
endef

LIBRETRO_BEETLE_NGP_PRE_CONFIGURE_HOOKS += LIBRETRO_BEETLE_NGP_FIXUP

define LIBRETRO_BEETLE_NGP_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/mednafen_ngp_libretro.so \
		$(TARGET_DIR)/usr/lib/libretro/libretro_beetle_ngp.so
endef
	
$(eval $(generic-package))
