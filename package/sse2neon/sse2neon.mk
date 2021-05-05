################################################################################
#
# sse2neon
#
################################################################################

SSE2NEON_VERSION := bac3692
SSE2NEON_SITE := https://github.com/DLTcollab/sse2neon.git
SSE2NEON_SITE_METHOD := git
SSE2NEON_DEPENDENCIES +=
SSE2NEON_INSTALL_STAGING := YES

define SSE2NEON_INSTALL_STAGING_CMDS
	$(INSTALL) -D $(@D)/*.h $(STAGING_DIR)/usr/include/
endef

$(eval $(generic-package))
