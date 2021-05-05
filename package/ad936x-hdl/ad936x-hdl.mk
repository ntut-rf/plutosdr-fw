################################################################################
#
# ad936x-hdl
#
################################################################################

AD936X_HDL_SITE_METHOD = local
AD936X_HDL_SITE = $(BR2_EXTERNAL)/hdl

export HDL_PROJECT
export HDL_PROJECT_DIR = $(@D)/projects/$(HDL_PROJECT)
export ADI_HDL_DIR = $(@D)

export MODE = incr
export ADI_USE_OOC_SYNTHESIS = 1

define AD936X_HDL_BUILD_CMDS
	cp -v $(BR2_EXTERNAL)/targets/$(TARGET)/hdl/*.tcl $(HDL_PROJECT_DIR)
	source $(VIVADO_SETTINGS) && $(MAKE) -j1 VPATH=$(HDL_PROJECT_DIR) -I $(HDL_PROJECT_DIR) -C $(HDL_PROJECT_DIR)
endef

$(eval $(generic-package))
