###############################################################################
#
# mupen64plus-core
#
###############################################################################

MUPEN64PLUS_CORE_VERSION = 2.5
MUPEN64PLUS_CORE_SITE = https://github.com/mupen64plus/mupen64plus-core.git
MUPEN64PLUS_CORE_SITE_METHOD = git
MUPEN64PLUS_CORE_INSTALL_STAGING = YES
MUPEN64PLUS_CORE_DEPENDENCIES = zlib libpng sdl2

ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
MUPEN64PLUS_PARAMS += USE_GLES=1
MUPEN64PLUS_PARAMS += VC=1
endif

ifeq ($(BR2_ARM_CPU_HAS_NEON),y)
MUPEN64PLUS_PARAMS += NEON=1
endif

ifeq ($(BR2_ARM_FPU_NEON_VFPV4),y)
MUPEN64PLUS_PARAMS += VFP_HARD=1
endif

ifeq ($(BR2_ARM_CPU_ARMV7A),y)
MUPEN64PLUS_CPU = armv7
endif

define MUPEN64PLUS_CORE_BUILD_CMDS
	CROSS_COMPILE="$(STAGING_DIR)/usr/bin/" \
	PKG_CONFIG="$(HOST_DIR)/usr/bin/pkg-config" \
	HOST_CPU="$(MUPEN64PLUS_CPU)" \
	$(MAKE) CC="$(TARGET_CC)" CXX="$(TARGET_CXX)" \
	-C $(@D)/projects/unix all $(MUPEN64PLUS_PARAMS)
endef

define MUPEN64PLUS_CORE_INSTALL_STAGING_CMDS
	CROSS_COMPILE="$(STAGING_DIR)/usr/bin/" \
	PKG_CONFIG="$(HOST_DIR)/usr/bin/pkg-config" \
	PREFIX="$(STAGING_DIR)/usr" \
	HOST_CPU="$(MUPEN64PLUS_CPU)" \
	$(MAKE) CC="$(TARGET_CC)" CXX="$(TARGET_CXX)" INSTALL_STRIP_FLAG="" LDCONFIG="true" \
	-C $(@D)/projects/unix install $(MUPEN64PLUS_PARAMS)
endef

define MUPEN64PLUS_CORE_INSTALL_TARGET_CMDS
	CROSS_COMPILE="$(STAGING_DIR)/usr/bin/" \
	PKG_CONFIG="$(HOST_DIR)/usr/bin/pkg-config" \
	HOST_CPU="$(MUPEN64PLUS_CPU)" \
	$(MAKE) CC="$(TARGET_CC)" CXX="$(TARGET_CXX)" INSTALL_STRIP_FLAG="" LDCONFIG="true" \
	PREFIX="$(TARGET_DIR)/usr" \
	-C $(@D)/projects/unix install $(MUPEN64PLUS_PARAMS)
endef
	
$(eval $(generic-package))
