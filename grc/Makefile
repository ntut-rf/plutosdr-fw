tx:
	$(MAKE) -j2 vid uav

rx:
	$(MAKE) -j2 gcs play

lb:
	$(MAKE) -j2 vid play_lb

vid:
	ffmpeg -re -f lavfi -i testsrc=size=800x600:rate=24 -video_size 800x600 -pixel_format yuv420p -framerate 24 \
		-preset ultrafast -tune zerolatency -vcodec libx264 -x264-params keyint=24:scenecut=0 -tune zerolatency -b:v 1000k -f mpegts udp://127.0.0.1:5000

uav:
	./dvbt_2k_trx_demo_uav_qpsk.py

gcs:
	./dvbt_2k_trx_demo_gcs_qpsk.py

play:
	ffplay udp://127.0.0.1:6000

.PHONY: clean
clean:
	rm -f *.bin

play_lb:
	ffplay udp://127.0.0.1:5000
