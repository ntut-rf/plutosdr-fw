BLOCK := video_src

.PHONY: install
install: plutosdr_video_src.block.yml plutosdr_video_play.block.yml video_src.py video_play.py __init__.py
	mkdir -p /usr/local/share/gnuradio/grc/blocks
	cp plutosdr_video_src.block.yml /usr/local/share/gnuradio/grc/blocks/
	cp plutosdr_video_play.block.yml /usr/local/share/gnuradio/grc/blocks/
	mkdir -p /usr/lib/python3.8/site-packages/plutosdr
	cp __init__.py /usr/lib/python3.8/site-packages/plutosdr/
	cp video_src.py /usr/lib/python3.8/site-packages/plutosdr/
	cp video_play.py /usr/lib/python3.8/site-packages/plutosdr/