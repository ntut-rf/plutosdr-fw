################################################################################
#
# device-tree-xlnx
#
################################################################################

DEVICE_TREE_XLNX_VERSION = a8b39cf
DEVICE_TREE_XLNX_SITE = https://github.com/Xilinx/device-tree-xlnx.git
DEVICE_TREE_XLNX_SITE_METHOD := git

define HOST_DEVICE_TREE_XLNX_INSTALL_CMDS
	mkdir -p $(HOST_DIR)/share/device-tree-xlnx
	cp -dpfr $(@D)/* $(HOST_DIR)/share/device-tree-xlnx
endef

$(eval $(host-generic-package))
