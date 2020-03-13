################################################################################
#
# iio-fm-radio
#
################################################################################

IIO_FM_RADIO_VERSION := 6c63519
IIO_FM_RADIO_SITE := https://github.com/analogdevicesinc/iio-fm-radio
IIO_FM_RADIO_SITE_METHOD := git
IIO_FM_RADIO_DEPENDENCIES += libiio
IIO_FM_RADIO_INSTALL_TARGET := YES

define IIO_FM_RADIO_BUILD_CMDS
	$(MAKE) WORKING_DIR=$(@D) CC="$(TARGET_CC)" CXX="$(TARGET_CXX)" LD="$(TARGET_LD)" -C $(@D)
endef

define IIO_FM_RADIO_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/iio_fm_radio $(TARGET_DIR)/usr/bin/
	$(INSTALL) -D -m 0755 $(@D)/iio_fm_radio_play $(TARGET_DIR)/usr/bin/
endef

$(eval $(generic-package))
