LIBRARY_NAME := e310_io
LIBRARY_SRC := \
	$(ETTUS_FPGA_DIR)/usrp3/top/e31x/e310_io.v \
	$(ETTUS_FPGA_DIR)/usrp3/lib/control/synchronizer.v \
	$(ETTUS_FPGA_DIR)/usrp3/lib/control/synchronizer_impl.v

GENERIC_DEPS += $(LIBRARY_SRC)
XILINX_DEPS += $(LIBRARY_NAME)_ip.tcl
export
include library/scripts/library.mk
