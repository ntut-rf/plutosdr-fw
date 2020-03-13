################################################################################
#
# mb_remoteproc
#
################################################################################

MB_REMOTEPROC_SITE := $(BR2_EXTERNAL)/package/mb_remoteproc
MB_REMOTEPROC_SITE_METHOD := local

$(eval $(kernel-module))
$(eval $(generic-package))