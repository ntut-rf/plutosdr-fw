vid:
	ffmpeg -re -f lavfi -i testsrc=size=1280x720:rate=30 -video_size 1280x720 -pixel_format yuv420p -framerate 30 \
		-preset ultrafast -vcodec libx264 -tune zerolatency -b:v 1200k -f mpegts udp://127.0.0.1:5000

play:
	ffplay udp://127.0.0.1:6000

LDLIBS += -lgnuradio-dtv -lgnuradio-blocks -lgnuradio-runtime -lgnuradio-pmt -lboost_system
CPATH += gnuradio/gr-dtv/lib/dvbt
export CPATH

bin/test: main.cpp
	mkdir -p $(@D)
	$(CXX) $^ $(LDLIBS) $(CPPFLAGS) -o $@

.PHONY: clean
clean:
	rm -rf bin
