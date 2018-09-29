################################################################################
#
# fftwf
#
################################################################################

FFTWF_VERSION = $(FFTW_VERSION)
FFTWF_SOURCE = fftw-$(FFTWF_VERSION).tar.gz
FFTWF_SITE = $(FFTW_SITE)
FFTWF_INSTALL_STAGING = $(FFTW_INSTALL_STAGING)
FFTWF_LICENSE = $(FFTW_LICENSE)
FFTWF_LICENSE_FILES = $(FFTW_LICENSE_FILES)

FFTWF_CONF_ENV = $(FFTW_CONF_ENV)

FFTWF_CONF_OPTS = $(FFTW_CONF_OPTS)
FFTWF_CONF_OPTS += --enable-single

FFTWF_CFLAGS = $(FFTW_CFLAGS)

# ARM optimisations
FFTWF_CONF_OPTS += $(if $(BR2_PACKAGE_FFTW_USE_NEON),--enable,--disable)-neon
FFTWF_CFLAGS += $(if $(BR2_PACKAGE_FFTW_USE_NEON),-mfpu=neon)

$(eval $(autotools-package))
