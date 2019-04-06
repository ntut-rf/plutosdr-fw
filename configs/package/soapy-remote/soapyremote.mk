################################################################################
#
# soapy-remote
#
################################################################################

SOAPY_REMOTE_VERSION = 0.5.1
SOAPY_REMOTE_SOURCE = soapy-remote-$(SOAPYREMOTE_VERSION).tar.gz
SOAPY_REMOTE_SITE = https://github.com/pothosware/SoapyRemote/archive
SOAPY_REMOTE_INSTALL_STAGING = YES
SOAPY_REMOTE_LICENSE = Boost Software License 1.0
SOAPY_REMOTE_LICENSE_FILES = LICENSE_1_0.txt
SOAPY_REMOTE_DEPENDENCIES = soapy-sdr

$(eval $(cmake-package))