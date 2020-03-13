################################################################################
#
# pluto-msd
#
################################################################################

PLUTO_MSD_SITE = $(BR2_EXTERNAL)/package/pluto-msd
PLUTO_MSD_SITE_METHOD = local
PLUTO_MSD_DEPENDENCIES = legal-info

version = git describe --abbrev=4 --dirty --always --tags

define PLUTO_MSD_BUILD_CMDS
	echo device-fw $$($(version)) > $(@D)/VERSIONS
	echo hdl $$(cd $(BR2_EXTERNAL)/hdl && $(version)) >> $(@D)/VERSIONS
	echo linux $(BR2_LINUX_KERNEL_CUSTOM_REPO_VERSION) >> $(@D)/VERSIONS
	echo u-boot-xlnx $(BR2_TARGET_UBOOT_CUSTOM_REPO_VERSION) >> $(@D)/VERSIONS
	$(@D)/legal_info_html.sh "$(COMPLETE_NAME)" $(@D)/VERSIONS $(@D)/msd/LICENSE.html
endef

define PLUTO_MSD_INSTALL_TARGET_CMDS
	cp -r $(@D)/msd/. $(TARGET_DIR)/www/
	$(INSTALL) -D -m 0644 $(@D)/VERSIONS $(TARGET_DIR)/opt/
endef

$(eval $(generic-package))
