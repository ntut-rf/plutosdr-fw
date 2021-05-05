################################################################################
#
# ad936x-fsbl
#
################################################################################

AD936X_FSBL_SITE_METHOD = local
AD936X_FSBL_SITE = $(BR2_EXTERNAL)/package/ad936x-fsbl
AD936X_FSBL_DEPENDENCIES = ad936x-hdl

export WS_DIR = $(@D)
export HW_DESIGN = $(O)/images/system_top.hdf

define AD936X_FSBL_BUILD_CMDS
	source $(VIVADO_SETTINGS) && xsdk -batch -source $(@D)/create_fsbl_project.tcl
endef

define AD936X_FSBL_INSTALL_TARGET_CMDS
	cp $(@D)/fsbl/Release/fsbl.elf $(O)/images/
endef

$(eval $(generic-package))
