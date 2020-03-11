SISO_SITE_METHOD := local
SISO_SITE := ~/SISO
SISO_DEPENDENCIES += gnuradio sse2neon libiio xilinx_axidma
SISO_INSTALL_TARGET := YES

define SISO_BUILD_CMDS
	$(MAKE) -C $(@D)/app clean
	$(MAKE) WORKING_DIR=$(@D) CC="$(TARGET_CC)" CXX="$(TARGET_CXX)" LD="$(TARGET_LD)" -C $(@D)/app
	$(MAKE) WORKING_DIR=$(@D) CC="$(TARGET_CC)" CXX="$(TARGET_CXX)" LD="$(TARGET_LD)" -C $(@D) top_block.py
endef

define SISO_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/app/bin/* $(TARGET_DIR)/usr/bin/
	$(INSTALL) -D -m 0755 $(@D)/top_block.py $(TARGET_DIR)/usr/bin/
endef

$(eval $(generic-package))
