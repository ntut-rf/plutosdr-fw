GR_IIO_VERSION := 7a5046f
GR_IIO_SITE := https://github.com/seanstone/gr-iio.git
GR_IIO_SITE_METHOD := git
GR_IIO_DEPENDENCIES += libad9361-iio libiio boost gnuradio
GR_IIO_INSTALL_TARGET := YES

$(eval $(cmake-package))
