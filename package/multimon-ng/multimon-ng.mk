################################################################################
#
# multimon-ng
#
################################################################################

MULTIMON_NG_VERSION := 84947ce
MULTIMON_NG_SITE := https://github.com/EliasOenal/multimon-ng.git
MULTIMON_NG_SITE_METHOD := git
MULTIMON_NG_DEPENDENCIES += 
MULTIMON_NG_INSTALL_TARGET := YES

$(eval $(cmake-package))
