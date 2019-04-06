################################################################################
#
# retrogram-plutosdr
#
################################################################################

RETROGRAM_PLUTOSDR_VERSION := 25b4fcf
RETROGRAM_PLUTOSDR_SITE := https://github.com/r4d10n/retrogram-plutosdr.git
RETROGRAM_PLUTOSDR_SITE_METHOD := git
RETROGRAM_PLUTOSDR_DEPENDENCIES += libad9361-iio boost ncurses
RETROGRAM_PLUTOSDR_INSTALL_TARGET := YES

define RETROGRAM_PLUTOSDR_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define RETROGRAM_PLUTOSDR_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/retrogram-plutosdr $(TARGET_DIR)/usr/bin/retrogram-plutosdr
endef

$(eval $(generic-package))
