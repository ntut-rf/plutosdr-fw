################################################################################
#
# ad936x-boot-img
#
################################################################################

AD936X_BOOT_IMG_SITE_METHOD = local
AD936X_BOOT_IMG_SITE = $(BR2_EXTERNAL)/package/ad936x-boot-img
AD936X_BOOT_IMG_DEPENDENCIES = ad936x-fsbl uboot

define AD936X_BOOT_IMG_BUILD_CMDS
	echo img:{[bootloader] $(O)/images/system_top.bit $(O)/images/u-boot } > $(@D)/boot.bif
	source $(VIVADO_SETTINGS) && bootgen -image $(@D)/boot.bif -w -o $(@D)/boot.bin
endef

define AD936X_BOOT_IMG_INSTALL_TARGET_CMDS
	cp $(@D)/boot.bin $(O)/images/
endef

$(eval $(generic-package))