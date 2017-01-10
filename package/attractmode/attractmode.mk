###############################################################################
#
# attractmode
#
###############################################################################

ATTRACTMODE_VERSION = v2.2.1
ATTRACTMODE_SITE = https://github.com/mickelson/attract.git
ATTRACTMODE_SITE_METHOD = git
ATTRACTMODE_DEPENDENCIES = sfml-pi ffmpeg

define ATTRACTMODE_BUILD_CMDS
	CFLAGS="$(TARGET_CFLAGS)" \
	CXXFLAGS="$(TARGET_CXXFLAGS)" \
	$(MAKE) PKG_CONFIG="$(PKG_CONFIG_HOST_BINARY)" \
	STRIP="$(TARGET_STRIP)" \
	CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" \
	LD="$(TARGET_LD)" \
	USE_GLES=1 -C $(@D) prefix=/usr
endef

define ATTRACTMODE_INSTALL_TARGET_CMDS
	$(MAKE) PKG_CONFIG="$(PKG_CONFIG_HOST_BINARY)" LD="$(TARGET_LD)" USE_GLES=1 -C $(@D) prefix=$(TARGET_DIR)/usr install
	cp -r package/attractmode/Flat $(TARGET_DIR)/usr/share/attract/layouts/
endef
	
$(eval $(generic-package))
