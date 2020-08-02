################################################################################
#
# pluto-overlay
#
################################################################################

PLUTO_OVERLAY_SITE = $(BR2_EXTERNAL)/package/pluto-overlay
PLUTO_OVERLAY_SITE_METHOD = local
PLUTO_OVERLAY_DEPENDENCIES = 

define PLUTO_OVERLAY_INSTALL_TARGET_CMDS
	cp -r $(@D)/init $(TARGET_DIR)/
	cp -r $(@D)/S01rm-overlay $(TARGET_DIR)/etc/init.d/
endef

$(eval $(generic-package))
