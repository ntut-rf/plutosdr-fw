GR_IIO_VERSION := 5a21c05
GR_IIO_SITE := https://github.com/analogdevicesinc/gr-iio.git
GR_IIO_SITE_METHOD := git
GR_IIO_DEPENDENCIES += libad9361-iio
GR_IIO_INSTALL_TARGET := YES

$(eval $(cmake-package))
