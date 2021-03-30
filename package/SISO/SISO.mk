################################################################################
#
# SISO
#
################################################################################

SISO_SITE_METHOD := local
SISO_SITE := ~/SISO
SISO_DEPENDENCIES += gnuradio sse2neon libiio xilinx_axidma
SISO_INSTALL_TARGET := YES

define SISO_BUILD_CMDS
	$(MAKE) -C $(@D) clean
	$(MAKE) WORKING_DIR=$(@D) CC="$(TARGET_CC)" CXX="$(TARGET_CXX)" LD="$(TARGET_LD)" -C $(@D) apps
endef

define SISO_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/bin/* $(TARGET_DIR)/usr/bin/
endef

$(eval $(generic-package))
