################################################################################
#
# itpp
#
################################################################################

ITPP_VERSION := r4.3.0
ITPP_SITE := https://git.code.sf.net/p/itpp/git
ITPP_SITE_METHOD := git
ITPP_INSTALL_STAGING := YES
ITPP_INSTALL_TARGET := YES

$(eval $(cmake-package))