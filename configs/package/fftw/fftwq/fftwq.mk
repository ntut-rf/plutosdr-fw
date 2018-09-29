################################################################################
#
# fftwq
#
################################################################################

FFTQ_VERSION = $(FFTW_VERSION)
FFTQ_SOURCE = fftw-$(FFTWQ_VERSION).tar.gz
FFTQ_SITE = $(FFTW_SITE)
FFTQ_INSTALL_STAGING = $(FFTW_INSTALL_STAGING)
FFTQ_LICENSE = $(FFTW_LICENSE)
FFTQ_LICENSE_FILES = $(FFTW_LICENSE_FILES)

FFTQ_CONF_ENV = $(FFTW_CONF_ENV)

FFTQ_CONF_OPTS = $(FFTW_CONF_OPTS)
FFTQ_CONF_OPTS += --enable-quad-precision

FFTQ_CFLAGS = $(FFTW_CFLAGS)

$(eval $(autotools-package))


