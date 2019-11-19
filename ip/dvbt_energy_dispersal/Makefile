SHELL:=/bin/bash

export VIVADO_VERSION ?= 2019.1
VIVADO_SETTINGS ?= /opt/Xilinx/Vivado/$(VIVADO_VERSION)/settings64.sh

all:
	source $(VIVADO_SETTINGS) && vivado_hls -f dvbt_energy_dispersal_ip.tcl

clean:
	rm -rf *.prj *.log

test:
	ffmpeg -re -f lavfi -i testsrc=size=1280x720:rate=30 \
		-preset ultrafast -vcodec libx264 -tune zerolatency -b:v 1200k -f mpegts -

nc:
	nc -lu 127.0.0.1 5000