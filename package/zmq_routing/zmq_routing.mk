################################################################################
#
# zmq_routing
#
################################################################################

ZMQ_ROUTING_SITE_METHOD := git
ZMQ_ROUTING_SITE := git@arrcrocket.org:ttc/EGSE.git
ZMQ_ROUTING_VERSION := bd87789bace6cabef07819a030062feeaeadbc41
ZMQ_ROUTING_DEPENDENCIES += python-pyzmq
ZMQ_ROUTING_INSTALL_TARGET := YES

define ZMQ_ROUTING_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/tools/zmq/{tx2_zmq_recv.py,tx2_zmq_routing.py} $(TARGET_DIR)/usr/bin/
	$(INSTALL) -D -m 0755 $(BR2_EXTERNAL)/package/zmq_routing/{S51zmq_routing,S52zmq_recv} $(TARGET_DIR)/etc/init.d/
endef

$(eval $(generic-package))
