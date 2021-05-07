################################################################################
#
# ad936x-uboot-env
#
################################################################################

AD936X_UBOOT_ENV_SITE_METHOD = local
AD936X_UBOOT_ENV_SITE := $(BR2_EXTERNAL)/package/ad936x-uboot-env
AD936X_UBOOT_ENV_DEPENDENCIES = uboot

define AD936X_UBOOT_ENV_BUILD_CMDS
	cd $(@D) && ./get_default_envs.sh > uboot-env.txt

	echo attr_name=compatible >> $(@D)/uboot-env.txt
	echo attr_val=ad9364 >> $(@D)/uboot-env.txt
	sed -i 's,^\(maxcpus[ ]*=\).*,\1'2',g' $(@D)/uboot-env.txt
	
	$(UBOOT_DIR)/tools/mkenvimage -s 0x20000 -o $(@D)/uboot-env.bin $(@D)/uboot-env.txt
endef

define AD936X_UBOOT_ENV_INSTALL_TARGET_CMDS
	cp $(@D)/uboot-env.bin $(O)/images/
endef

$(eval $(generic-package))
