SHELL:=/bin/bash

export VIVADO_VERSION ?= 2019.1
VIVADO_SETTINGS ?= /opt/Xilinx/Vivado/$(VIVADO_VERSION)/settings64.sh

all: axi-lite axi-stream

axi-lite:
	source $(VIVADO_SETTINGS) && vivado_hls -f axi_lite.tcl

axi-stream:
	source $(VIVADO_SETTINGS) && vivado_hls -f axi_stream.tcl

clean:
	rm -rf *.prj *.log
