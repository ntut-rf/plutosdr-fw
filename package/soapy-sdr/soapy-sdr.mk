################################################################################
#
# soapy-sdr
#
################################################################################

SOAPY_SDR_VERSION = 0.7.1
SOAPY_SDR_SOURCE = soapy-sdr-$(SOAPY_SDR_VERSION).tar.gz
SOAPY_SDR_SITE = https://github.com/pothosware/SoapySDR/archive
SOAPY_SDR_INSTALL_STAGING = YES
SOAPY_SDR_LICENSE = Boost Software License 1.0
SOAPY_SDR_LICENSE_FILES = LICENSE_1_0.txt
SOAPY_SDR_CONF_OPTS = -DENABLE_PYTHON=OFF

$(eval $(cmake-package))
