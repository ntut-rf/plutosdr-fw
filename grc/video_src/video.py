#!/usr/bin/python3

import subprocess
import sys

p = subprocess.Popen([
    "ffmpeg", "-re", "-f", "lavfi",
    "-i", "testsrc=size=800x600:rate=24",
    "-video_size", "800x600", 
    "-pixel_format", "yuv420p",
    "-framerate", "24",
    "-preset", "ultrafast",
    "-tune", "zerolatency",
    "-vcodec", "libx264", 
    "-x264-params", "keyint=24:scenecut=0",
    "-tune", "zerolatency",
    "-b:v", "1000k",
    "-f", "mpegts",
    "-"
    ], stdout = subprocess.PIPE)

while True:
    b = p.stdout.read(1) 
    sys.stdout.buffer.write(b)