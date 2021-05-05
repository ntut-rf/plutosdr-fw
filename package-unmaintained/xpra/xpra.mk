################################################################################
#
# xpra
#
################################################################################

XPRA_VERSION = 2.5
XPRA_SOURCE = xpra-$(XPRA_VERSION).tar.xz
XPRA_SITE = https://xpra.org/src
XPRA_INSTALL_TARGET = YES
XPRA_DEPENDENCIES = host-python host-python-cython xlib_libXtst xlib_libXcomposite python-gobject

define XPRA_BUILD_CMDS
	cd $(@D) && \
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) python setup.py build
endef

define XPRA_INSTALL_TARGET_CMDS
	#$(INSTALL) -D -m 755 $(@D)/ad936x_ref_cal $(TARGET_DIR)/usr/sbin/ad936x_ref_cal
endef

$(eval $(generic-package))
