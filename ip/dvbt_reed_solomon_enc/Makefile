bin/test: main.cpp dvbt_reed_solomon_enc_impl.cc encode_rs.c init_rs.c
	mkdir -p $(@D)
	$(CXX) -I. $^ -o $@

.PHONY: clean
clean:
	rm -rf bin *.prj

SHELL:=/bin/bash

export VIVADO_VERSION ?= 2019.1
VIVADO_SETTINGS ?= /opt/Xilinx/Vivado/$(VIVADO_VERSION)/settings64.sh

ip:
	source $(VIVADO_SETTINGS) && vivado_hls -f dvbt_reed_solomon_enc_ip.tcl
