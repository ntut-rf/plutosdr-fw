################################################################################
#
# fftw
#
################################################################################

FFTW_VERSION = 3.3.8
FFTW_SITE = http://www.fftw.org
FFTW_INSTALL_STAGING = YES
FFTW_LICENSE = GPL-2.0+
FFTW_LICENSE_FILES = COPYING

# fortran support only enables generation and installation of fortran sources
ifeq ($(BR2_TOOLCHAIN_HAS_FORTRAN),y)
FFTW_CONF_OPTS += --enable-fortran
FFTW_CONF_ENV += FLIBS="-lgfortran -lm"
else
FFTW_CONF_OPTS += --disable-fortran
endif

FFTW_CFLAGS = $(TARGET_CFLAGS)
ifeq ($(BR2_PACKAGE_FFTW_FAST),y)
FFTW_CFLAGS += -O3 -ffast-math
endif

# x86 optimisations
FFTW_CONF_OPTS += $(if $(BR2_PACKAGE_FFTW_USE_SSE),--enable,--disable)-sse
FFTW_CONF_OPTS += $(if $(BR2_PACKAGE_FFTW_USE_SSE2),--enable,--disable)-sse2

# Generic optimisations
ifeq ($(BR2_TOOLCHAIN_HAS_THREADS),y)
FFTW_CONF_OPTS += --enable-threads
FFTW_CONF_OPTS += $(if $(BR2_GCC_ENABLE_OPENMP),--without,--with)-combined-threads
else
FFTW_CONF_OPTS += --disable-threads
endif
FFTW_CONF_OPTS += $(if $(BR2_GCC_ENABLE_OPENMP),--enable,--disable)-openmp

FFTW_CONF_OPTS += CFLAGS="$(FFTW_CFLAGS)"

include package/fftw/fftw/fftw.mk
include package/fftw/fftwf/fftwf.mk
include package/fftw/fftwl/fftwl.mk
include package/fftw/fftwq/fftwq.mk
