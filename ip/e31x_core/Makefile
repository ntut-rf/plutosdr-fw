
LIBRARY_NAME := e31x_core

LIBRARY_SRC += $(ETTUS_FPGA_DIR)/usrp3/top/e31x/e31x_core.v
LIBRARY_SRC += $(ETTUS_FPGA_DIR)/usrp3/top/e31x/e31x_rfnoc_image_core.v
LIBRARY_SRC += $(ETTUS_FPGA_DIR)/usrp3/lib/control/axil_regport_master.v
LIBRARY_SRC += $(ETTUS_FPGA_DIR)/usrp3/lib/control/db_control.v
LIBRARY_SRC += $(ETTUS_FPGA_DIR)/usrp3/lib/control/synchronizer.v
LIBRARY_SRC += $(ETTUS_FPGA_DIR)/usrp3/lib/control/synchronizer_impl.v
LIBRARY_SRC += $(ETTUS_FPGA_DIR)/usrp3/lib/control/regport_resp_mux.v
LIBRARY_SRC += $(ETTUS_FPGA_DIR)/usrp3/lib/rfnoc/utils/timekeeper.v
LIBRARY_SRC += $(ETTUS_FPGA_DIR)/usrp3/lib/rfnoc/utils/ctrlport_to_settings_bus.v
LIBRARY_SRC += $(ETTUS_FPGA_DIR)/usrp3/lib/rfnoc/xport/liberio_chdr64_adapter.v

TOOLS_DIR = $(ETTUS_FPGA_DIR)/usrp3/tools
GIT_HASH = $(shell $(TOOLS_DIR)/scripts/git-hash.sh --hashfile=$(TOOLS_DIR)/../../project.githash)
GIT_HASH_VERILOG_DEF = $(addprefix GIT_HASH=32'h,$(GIT_HASH))
EDGE_FILE = $(abspath $(ETTUS_FPGA_DIR)/usrp3/top/e31x/e310_static_router.hex)
EDGE_TBL_DEF = "RFNOC_EDGE_TBL_FILE=$(EDGE_FILE)"
VERILOG_DEFS = $(GIT_HASH_VERILOG_DEF) $(EDGE_TBL_DEF)
$(info $(VERILOG_DEFS))

GENERIC_DEPS += $(LIBRARY_SRC)
XILINX_DEPS += $(LIBRARY_NAME)_ip.tcl
export
include library/scripts/library.mk


