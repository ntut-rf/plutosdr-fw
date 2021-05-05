################################################################################
#
# leansdr
#
################################################################################

LEANSDR_VERSION = 30c6b10
LEANSDR_SITE = https://github.com/pabr/leansdr.git
LEANSDR_SITE_METHOD = git
LEANSDR_LICENSE = GPLv3
LEANSDR_LICENSE_FILES = LICENSE.txt
LEANSDR_DEPENDENCIES += libiio fftw-single

define LEANSDR_BUILD_CMDS
	$(MAKE) WORKING_DIR=$(@D) CC="$(TARGET_CC)" CXX="$(TARGET_CXX)" LD="$(TARGET_LD)" -C $(@D)/src/apps
endef

define LEANSDR_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/src/apps/{leandvbtx,leandvb,leansdrscan,leansdrserv,leantsgen,leansdrcat,leanchansim,leanmlmrx,leaniiorx,leaniiotx} $(TARGET_DIR)/usr/bin/
endef

$(eval $(generic-package))
