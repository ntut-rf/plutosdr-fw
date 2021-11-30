################################################################################
#
# SISO
#
################################################################################

SISO_SITE_METHOD := local
SISO_SITE := $(BR2_EXTERNAL)/../SISO
SISO_DEPENDENCIES += sse2neon libiio xilinx_axidma
SISO_INSTALL_TARGET := YES

export GNURADIO_VERSION

define SISO_BUILD_CMDS
	$(MAKE) -C $(@D) clean
	$(MAKE) WORKING_DIR=$(@D) CC="$(TARGET_CC)" CXX="$(TARGET_CXX)" LD="$(TARGET_LD)" -C $(@D) iq-apps iio-apps
endef

define SISO_INSTALL_TARGET_CMDS
	rm -f $(@D)/bin/*.d
	$(INSTALL) -D -m 0755 $(@D)/bin/* $(TARGET_DIR)/usr/bin/
endef

$(eval $(generic-package))
