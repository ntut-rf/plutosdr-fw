################################################################################
#
# soapy-plutosdr
#
################################################################################

SOAPY_PLUTOSDR_VERSION = 0.1.0
SOAPY_PLUTOSDR_SOURCE = soapy-plutosdr-$(SOAPY_REMOTE_VERSION).tar.gz
SOAPY_PLUTOSDR_SITE = https://github.com/pothosware/SoapyPlutoSDR/archive
SOAPY_PLUTOSDR_INSTALL_STAGING = YES
SOAPY_PLUTOSDR_LICENSE = LGPL-2.1+
SOAPY_PLUTOSDR_LICENSE_FILE = LICENSE
SOAPY_PLUTOSDR_DEPENDENCIES = libiio libad9361-iio soapy-sdr

$(eval $(cmake-package))