LIBTUNTAP_VERSION := 943259e
LIBTUNTAP_SITE := https://github.com/LaKabane/libtuntap
LIBTUNTAP_SITE_METHOD := git
LIBTUNTAP_INSTALL_TARGET := YES

$(eval $(cmake-package))
