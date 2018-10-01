CHARON_VERSION := f1ff805
CHARON_SITE := https://github.com/seanstone/charon.git
CHARON_SITE_METHOD := git
CHARON_DEPENDENCIES += batctl bridge-utils fftwf iperf3 iproute2 liquid-dsp tunctl util-linux libfec libtuntap
CHARON_INSTALL_TARGET := YES

define CHARON_BUILD_CMDS
	$(MAKE) WORKING_DIR=$(@D) CC="$(TARGET_CC)" CXX="$(TARGET_CXX)" LD="$(TARGET_LD)" -C $(@D)
endef

define CHARON_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/bin/* $(TARGET_DIR)/usr/bin/
endef

$(eval $(generic-package))
