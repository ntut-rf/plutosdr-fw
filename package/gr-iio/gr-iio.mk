################################################################################
#
# gr-iio
#
################################################################################

GR_IIO_VERSION := b3bd9ed
GR_IIO_SITE := https://github.com/analogdevicesinc/gr-iio.git
GR_IIO_SITE_METHOD := git
GR_IIO_DEPENDENCIES += libad9361-iio libiio boost gnuradio
GR_IIO_INSTALL_TARGET := YES

$(eval $(cmake-package))
