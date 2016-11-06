################################################################################
#
# sfml-pi
#
################################################################################

SFML_PI_VERSION = master
SFML_PI_SITE = https://github.com/mickelson/sfml-pi.git
SFML_PI_SITE_METHOD = git

SFML_PI_INSTALL_STAGING = YES
SFML_PI_DEPENDENCIES += eudev jpeg openal flac libvorbis freetype rpi-userland
SFML_PI_CONF_OPTS += -DSFML_RPI=1

$(eval $(cmake-package))
