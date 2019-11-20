BLOCK := dvbt_energy_dispersal

.PHONY: install
install: plutosdr_$(BLOCK).block.yml __init__.py $(BLOCK).py
	mkdir -p /usr/local/share/gnuradio/grc/blocks
	cp plutosdr_$(BLOCK).block.yml /usr/local/share/gnuradio/grc/blocks/
	mkdir -p /usr/lib/python3.8/site-packages/plutosdr
	cp __init__.py $(BLOCK).py /usr/lib/python3.8/site-packages/plutosdr/