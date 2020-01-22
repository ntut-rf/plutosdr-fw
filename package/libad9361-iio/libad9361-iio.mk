################################################################################
#
# libad9361-iio
#
################################################################################
LIBAD9361_IIO_VERSION = 11293f8
LIBAD9361_IIO_SITE = https://github.com/analogdevicesinc/libad9361-iio.git
LIBAD9361_IIO_SITE_METHOD = git

LIBAD9361_IIO_INSTALL_STAGING = YES
LIBAD9361_IIO_LICENSE = LGPL-2.1+
LIBAD9361_IIO_LICENSE_FILES = LICENSE
LIBAD9361_IIO_DEPENDENCIES = libiio

$(eval $(cmake-package))
