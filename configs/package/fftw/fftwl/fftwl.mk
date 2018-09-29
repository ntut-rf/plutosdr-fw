################################################################################
#
# fftwl
#
################################################################################

FFTWL_VERSION = $(FFTW_VERSION)
FFTWL_SOURCE = fftw-$(FFTWL_VERSION).tar.gz
FFTWL_SITE = $(FFTW_SITE)
FFTWL_INSTALL_STAGING = $(FFTW_INSTALL_STAGING)
FFTWL_LICENSE = $(FFTW_LICENSE)
FFTWL_LICENSE_FILES = $(FFTW_LICENSE_FILES)

FFTWL_CONF_ENV = $(FFTW_CONF_ENV)

FFTWL_CONF_OPTS = $(FFTW_CONF_OPTS)
FFTWL_CONF_OPTS += --enable-long-double

FFTWL_CFLAGS = $(FFTW_CFLAGS)

$(eval $(autotools-package))
