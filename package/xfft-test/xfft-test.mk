################################################################################
#
# xfft-test
#
################################################################################

XFFT_TEST_SITE_METHOD := local
XFFT_TEST_SITE := $(BR2_EXTERNAL)/package/xfft-test
XILINX_AXIDMA_DEPENDENCIES += xilinx_axidma gnuradio

define XFFT_TEST_BUILD_CMDS
	$(TARGET_CC) $(TARGET_CFLAGS) -std=gnu11 $(TARGET_LDFLAGS) -laxidma \
		$(@D)/xfft-test.c -o $(@D)/xfft-test
	$(TARGET_CXX) $(TARGET_CXXFLAGS) $(TARGET_LDFLAGS) -lgnuradio-fft \
		$(@D)/fft-test.cc -o $(@D)/fft-test
endef

define XFFT_TEST_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/xfft-test $(TARGET_DIR)/bin/
	$(INSTALL) -D -m 755 $(@D)/fft-test $(TARGET_DIR)/bin/
endef

$(eval $(generic-package))
