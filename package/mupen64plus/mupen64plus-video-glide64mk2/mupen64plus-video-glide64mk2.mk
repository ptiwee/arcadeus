###############################################################################
#
# mupen64plus-video-glide64mk2
#
###############################################################################

MUPEN64PLUS_VIDEO_GLIDE64MK2_VERSION = 2.5
MUPEN64PLUS_VIDEO_GLIDE64MK2_SITE = https://github.com/mupen64plus/mupen64plus-video-glide64mk2.git
MUPEN64PLUS_VIDEO_GLIDE64MK2_SITE_METHOD = git
MUPEN64PLUS_VIDEO_GLIDE64MK2_DEPENDENCIES = mupen64plus-core boost

define MUPEN64PLUS_VIDEO_GLIDE64MK2_BUILD_CMDS
	CROSS_COMPILE="$(STAGING_DIR)/usr/bin/" \
	PKG_CONFIG="$(HOST_DIR)/usr/bin/pkg-config" \
	HOST_CPU="$(MUPEN64PLUS_CPU)" \
	APIDIR="$(STAGING_DIR)/usr/include/mupen64plus" \
	$(MAKE) CC="$(TARGET_CC)" CXX="$(TARGET_CXX)" VC=1 NO_SSE=1 \
	-C $(@D)/projects/unix all $(MUPEN64PLUS_PARAMS)
endef

define MUPEN64PLUS_VIDEO_GLIDE64MK2_INSTALL_TARGET_CMDS
	CROSS_COMPILE="$(STAGING_DIR)/usr/bin/" \
	PKG_CONFIG="$(HOST_DIR)/usr/bin/pkg-config" \
	HOST_CPU="$(MUPEN64PLUS_CPU)" \
	APIDIR="$(STAGING_DIR)/usr/include/mupen64plus" \
	$(MAKE) CC="$(TARGET_CC)" CXX="$(TARGET_CXX)" VC=1 NO_SSE=1 INSTALL_STRIP_FLAG="" \
	LDCONFIG="true" PREFIX="/usr" \
	-C $(@D)/projects/unix DESTDIR=$(TARGET_DIR) install $(MUPEN64PLUS_PARAMS)
endef
	
$(eval $(generic-package))
