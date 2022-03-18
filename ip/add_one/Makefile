SHELL:=/bin/bash

export VIVADO_VERSION ?= 2021.2
VIVADO_SETTINGS ?= /tools/Xilinx/Vivado/$(VIVADO_VERSION)/settings64.sh

all: axi-stream

# axi-lite:
# 	source $(VIVADO_SETTINGS) && vitis_hls -f axi_lite.tcl

axi-stream:
	source $(VIVADO_SETTINGS) && vitis_hls -f axi_stream.tcl

clean:
	rm -rf *.prj *.log
