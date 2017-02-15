###############################################################################
#
# retroarch
#
###############################################################################

RETROARCH_VERSION = v1.3.6
RETROARCH_SITE = https://github.com/libretro/RetroArch.git
RETROARCH_SITE_METHOD = git
RETROARCH_CONFIGURE_OPTS = --enable-udev

ifeq ($(BR2_PACKAGE_LIBRETRO_PLATFORM),"rpi3")
RETROARCH_CONFIGURE_OPTS += --enable-neon --enable-floathard --enable-dispmanx
LIBRETRO_PLATFORM += armv8,unix,rpi3,neon,hardfloat,gles
else ifeq ($(BR2_PACKAGE_LIBRETRO_PLATFORM),"odroidc1")
RETROARCH_DEPENDENCIES += opengl
RETROARCH_CONFIGURE_OPTS += --enable-neon --enable-floathard --enable-mali_fbdev 
LIBRETRO_PLATFORM += armv7,cortexa5,unix,odroic1,neon,hardfloat,gles
endif

ifeq ($(BR2_PACKAGE_SDL2),y)
RETROARCH_CONFIGURE_OPTS += --enable-sdl2
RETROARCH_DEPENDENCIES += sdl2
else
RETROARCH_CONFIGURE_OPTS += --disable-sdl2
endif

ifeq ($(BR2_PACKAGE_HAS_LIBGLES),y)
RETROARCH_CONFIGURE_OPTS += --enable-gles
RETROARCH_DEPENDENCIES += libgles
else
RETROARCH_CONFIGURE_OPTS += --disable-gles
endif

ifeq ($(BR2_PACKAGE_HAS_LIBEGL),y)
RETROARCH_CONFIGURE_OPTS += --enable-egl
RETROARCH_DEPENDENCIES += libegl
else
RETROARCH_CONFIGURE_OPTS += --disable-egl
endif

ifeq ($(BR2_PACKAGE_HAS_LIBOPENVG),y)
RETROARCH_DEPENDENCIES += libopenvg
endif

define RETROARCH_CONFIGURE_CMDS
	cd $(@D); \
    $(TARGET_CONFIGURE_ARGS) \
    $(TARGET_CONFIGURE_OPTS) \
	CROSS_COMPILE="$(HOST_DIR)/usr/bin/" \
    ./configure \
        --prefix=/usr \
        $(RETROARCH_CONFIGURE_OPTS)
endef

define RETROARCH_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) all
endef

define RETROARCH_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
endef
	
$(eval $(generic-package))
