################################################################################
#
# ad936x-hdl
#
################################################################################

AD936X_HDL_SITE_METHOD = git
AD936X_HDL_SITE = https://github.com/analogdevicesinc/hdl
AD936X_HDL_VERSION = e773b22

HDL_PROJECT_DIR = $(@D)/projects/$(HDL_PROJECT)

export MODE = incr
export ADI_USE_OOC_SYNTHESIS = 1
export ADI_HDL_DIR = $(@D)

define AD936X_HDL_BUILD_CMDS
	cp -v $(BR2_EXTERNAL)/targets/$(TARGET)/hdl/*.tcl $(HDL_PROJECT_DIR)
	source $(VIVADO_SETTINGS) && $(MAKE) -j1 VPATH=$(HDL_PROJECT_DIR) -I $(HDL_PROJECT_DIR) -C $(HDL_PROJECT_DIR)
	source $(VIVADO_SETTINGS) && cd $(HDL_PROJECT_DIR) && HDL_PROJECT=$(subst /,_,$(HDL_PROJECT)) xsdk -batch -source $(BR2_EXTERNAL)/package/ad936x-hdl/create_fsbl_project.tcl
endef

$(eval $(generic-package))
