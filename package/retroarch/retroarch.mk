###############################################################################
#
# retroarch
#
###############################################################################

RETROARCH_VERSION = v1.3.6
RETROARCH_SITE = https://github.com/libretro/RetroArch.git
RETROARCH_SITE_METHOD = git
RETROARCH_DEPENDENCIES = host-pkgconf zlib

RETROARCH_CONF_OPTS += --disable-sdl
RETROARCH_CONF_OPTS += --disable-oss
RETROARCH_CONF_OPTS += --disable-python
RETROARCH_CONF_OPTS += --disable-x11
RETROARCH_CONF_OPTS += --disable-networking
RETROARCH_CONF_OPTS += --disable-netplay
RETROARCH_CONF_OPTS += --disable-pulse
RETROARCH_CONF_OPTS += --disable-libxml2
RETROARCH_CONF_OPTS += --disable-freetype
RETROARCH_CONF_OPTS += --disable-sdl
RETROARCH_CONF_OPTS += --disable-cheevos
RETROARCH_CONF_OPTS += --enable-zlib

ifeq ($(BR2_PACKAGE_ALSA_LIB),y)
	RETROARCH_CONF_OPTS += --enable-alsa
	RETROARCH_DEPENDENCIES += alsa-lib
else
	RETROARCH_CONF_OPTS += --disable-alsa
endif

ifeq ($(BR2_PACKAGE_SDL2),y)
	RETROARCH_CONF_OPTS += --enable-sdl2
	RETROARCH_DEPENDENCIES += sdl2
else
	RETROARCH_CONF_OPTS += --disable-sdl2
endif

ifeq ($(BR2_PACKAGE_HAS_LIBGLES),y)
	RETROARCH_CONF_OPTS += --enable-gles
	RETROARCH_DEPENDENCIES += libgles
else
	RETROARCH_CONF_OPTS += --disable-gles
endif

ifeq ($(BR2_PACKAGE_HAS_LIBEGL),y)
	RETROARCH_CONF_OPTS += --enable-egl
	RETROARCH_DEPENDENCIES += libegl
else
	RETROARCH_CONF_OPTS += --disable-egl
endif

ifeq ($(BR2_PACKAGE_HAS_LIBOPENVG),y)
	RETROARCH_DEPENDENCIES += libopenvg
endif

# Raspberry Pi Zero and 1
ifeq ($(BR2_arm1176jzf_s),y)
	RETROARCH_CONF_OPTS += --enable-floathard
endif

#Raspberry Pi 2
ifeq ($(BR2_cortex_a7),y)
	RETROARCH_CONF_OPTS += --enable-neon --enable-floathard
endif

#Raspberry Pi 3
ifeq ($(BR2_cortex_a8),y)
	RETROARCH_CONF_OPTS += --enable-neon --enable-floathard
endif

define RETROARCH_CONFIGURE_CMDS
	(cd $(@D); rm -rf config.cache; \
		$(TARGET_CONFIGURE_ARGS) \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS)" \
		LDFLAGS="$(TARGET_LDFLAGS) -lc" \
		CROSS_COMPILE="$(HOST_DIR)/usr/bin/" \
		./configure \
		--prefix=/usr \
		$(RETROARCH_CONF_OPTS) \
	)
endef

define RETROARCH_BUILD_CMDS
	$(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" LD="$(TARGET_LD)" -C $(@D) all
endef

define RETROARCH_INSTALL_TARGET_CMDS
	$(MAKE) CXX="$(TARGET_CXX)" -C $(@D) DESTDIR=$(TARGET_DIR) install
endef
	
$(eval $(generic-package))
