import numpy
from gnuradio import gr
import subprocess

class video_src(gr.basic_block):
    """
    """
    def __init__(self):
        self.video = subprocess.Popen([
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
        gr.basic_block.__init__(self,
            name="video_src",
            in_sig=[],
            out_sig=[numpy.byte])
        #self.set_auto_consume(False)

    def forecast (self,noutput_items,ninput_items_required):
        ninput_items_required[0] = 0

    def general_work(self, input_items, output_items):
        out = output_items[0]
        b = int.from_bytes(self.video.stdout.read(1), byteorder='big')
        #print(b)
        out[:] = b
        return len(out)

