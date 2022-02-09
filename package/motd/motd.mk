################################################################################
#
# motd
#
################################################################################

MOTD_SITE = $(BR2_EXTERNAL)/package/motd
MOTD_SITE_METHOD = local

ifdef BR2_PACKAGE_MOTD_PLUTOSDR
define MOTD_INSTALL_TARGET_CMDS
cp $(@D)/pluto.motd $(TARGET_DIR)/etc/motd
endef
endif

ifdef BR2_PACKAGE_MOTD_ADRV9364
define MOTD_INSTALL_TARGET_CMDS
cp $(@D)/adrv9364.motd $(TARGET_DIR)/etc/motd
endef
endif

$(eval $(generic-package))
