################################################################################
#
# zmq_routing
#
################################################################################

ZMQ_ROUTING_SITE_METHOD := git
ZMQ_ROUTING_SITE := git@arrcrocket.org:ttc/EGSE.git
ZMQ_ROUTING_VERSION := c02681791a852415ee8e2359af2f336ee8f91da2
ZMQ_ROUTING_DEPENDENCIES += python-pyzmq
ZMQ_ROUTING_INSTALL_TARGET := YES

define ZMQ_ROUTING_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/tools/zmq/{tx2_zmq_recv.py,tx2_zmq_routing.py} $(TARGET_DIR)/usr/bin/
endef

$(eval $(generic-package))
