SHELL:=/bin/bash

export VIVADO_VERSION ?= 2019.1
VIVADO_SETTINGS ?= /opt/Xilinx/Vivado/$(VIVADO_VERSION)/settings64.sh

all:
	source $(VIVADO_SETTINGS) && vivado_hls -f dvbt_energy_dispersal_ip.tcl

clean:
	rm -rf *.prj *.log