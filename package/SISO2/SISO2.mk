################################################################################
#
# SISO2
#
################################################################################

SISO2_SITE_METHOD := local
SISO2_SITE := $(BR2_EXTERNAL)/../../SISO2
SISO2_DEPENDENCIES += gnuradio sse2neon libiio xilinx_axidma
SISO2_INSTALL_TARGET := YES

export GNURADIO_VERSION

$(eval $(cmake-package))