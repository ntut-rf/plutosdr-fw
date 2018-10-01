LIBFEC_VERSION := 9750ca0
LIBFEC_SITE := https://github.com/quiet/libfec
LIBFEC_SITE_METHOD := git
LIBFEC_DEPENDENCIES += host-libfec
LIBFEC_INSTALL_TARGET := YES

define HOST_LIBFEC_INSTALL_CMDS
	$(INSTALL) -D -m 0755 $(@D)/{gen_ccsds,gen_ccsds_tal} $(HOST_DIR)/bin/
endef

$(eval $(cmake-package))
$(eval $(host-cmake-package))
