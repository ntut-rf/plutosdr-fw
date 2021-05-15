################################################################################
#
# ad936x-uboot-env
#
################################################################################

AD936X_UBOOT_ENV_SITE_METHOD = local
AD936X_UBOOT_ENV_SITE := $(BR2_EXTERNAL)/package/ad936x-uboot-env
AD936X_UBOOT_ENV_DEPENDENCIES = host-uboot-tools

define AD936X_UBOOT_ENV_BUILD_CMDS
	if [ -f $(O)/build/uboot-$(UBOOT_VERSION)/scripts/get_default_envs.sh ]; then \
	PATH=$(O)/../host/bin:$(PATH) CROSS_COMPILE=arm-buildroot-linux-gnueabihf- \
		$(O)/build/uboot-$(UBOOT_VERSION)/scripts/get_default_envs.sh \
		$(O)/build/uboot-$(UBOOT_VERSION) \
		> $(@D)/uboot-env.txt; \
	else \
	PATH=$(O)/../host/bin:$(PATH) CROSS_COMPILE=arm-buildroot-linux-gnueabihf- \
		$(@D)/get_default_envs.sh \
		$(O)/build/uboot-$(UBOOT_VERSION) \
		> $(@D)/uboot-env.txt; \
	fi

	echo attr_name=compatible >> $(@D)/uboot-env.txt
	echo attr_val=ad9364 >> $(@D)/uboot-env.txt
	sed -i 's,^\(maxcpus[ ]*=\).*,\1'2',g' $(@D)/uboot-env.txt
	
	$(UBOOT_DIR)/tools/mkenvimage -s 0x20000 -o $(@D)/uboot-env.bin $(@D)/uboot-env.txt
endef

define AD936X_UBOOT_ENV_INSTALL_TARGET_CMDS
	cp $(@D)/uboot-env.bin $(O)/images/
endef

$(eval $(generic-package))
