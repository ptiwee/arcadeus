################################################################################
#
## sfml
#
#################################################################################

SFML_VERSION = master
SFML_SITE = https://github.com/mickelson/sfml-pi.git
SFML_SITE_METHOD = git

SFML_INSTALL_STAGING = YES
SFML_DEPENDENCIES += eudev jpeg openal flac libvorbis freetype

ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
SFML_DEPENDENCIES += rpi-userland
SFML_CONF_OPTS += -DSFML_RPI=1
endif

$(eval $(cmake-package))
