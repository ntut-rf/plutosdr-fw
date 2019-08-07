obj-m += mb_remoteproc.o

EXTRA_CFLAGS += -I$(LINUX_DIR)/drivers/remoteproc/

default:
	$(MAKE) -C $(LINUX_DIR) SUBDIRS=$(PWD) modules

clean:
	$(MAKE) -C $(LINUX_DIR) SUBDIRS=$(PWD) clean