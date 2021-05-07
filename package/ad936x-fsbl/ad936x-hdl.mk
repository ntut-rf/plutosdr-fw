################################################################################
#
# ad936x-fsbl
#
################################################################################

AD936X_FSBL_SITE_METHOD = local
AD936X_FSBL_SITE = $(BR2_EXTERNAL)/package/ad936x-fsbl
AD936X_FSBL_DEPENDENCIES = ad936x-hdl

define AD936X_FSBL_BUILD_CMDS
	cp $(O)/images/system_top.xsa $(@D)
	cd $(@D) && source $(VIVADO_SETTINGS) && xsct $(@D)/create_fsbl_project.tcl
endef

define AD936X_FSBL_INSTALL_TARGET_CMDS
	cp {$(@D)/fsbl/Release/fsbl.elf,$(@D)/system_top.bit} $(O)/images/
endef

$(eval $(generic-package))
