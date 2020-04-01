################################################################################
#
# gr-iio
#
################################################################################

GR_IIO_VERSION := d6d1f6a
GR_IIO_SITE := https://github.com/analogdevicesinc/gr-iio.git
GR_IIO_SITE_METHOD := git
GR_IIO_DEPENDENCIES += libad9361-iio libiio boost gnuradio
GR_IIO_INSTALL_TARGET := YES

$(eval $(cmake-package))
