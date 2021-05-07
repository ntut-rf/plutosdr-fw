################################################################################
#
# ad936x-hdl
#
################################################################################

AD936X_HDL_SITE_METHOD = git
AD936X_HDL_SITE = https://github.com/analogdevicesinc/hdl
AD936X_HDL_VERSION = 1db04a4

HDL_PROJECT_DIR = $(@D)/projects/$(HDL_PROJECT)

export MODE = incr
export ADI_USE_OOC_SYNTHESIS = 1
export ADI_HDL_DIR = $(@D)

export ADI_IGNORE_VERSION_CHECK = 1

define AD936X_HDL_BUILD_CMDS
	cp -v $(BR2_EXTERNAL)/targets/$(TARGET)/hdl/*.tcl $(HDL_PROJECT_DIR)
	source $(VIVADO_SETTINGS) && $(MAKE) -j1 VPATH=$(HDL_PROJECT_DIR) -I $(HDL_PROJECT_DIR) -C $(HDL_PROJECT_DIR)
endef

define AD936X_HDL_INSTALL_TARGET_CMDS
	mkdir -p $(O)/images
	cp $(HDL_PROJECT_DIR)/$(subst /,_,$(HDL_PROJECT)).sdk/system_top.xsa $(O)/images/
endef

$(eval $(generic-package))