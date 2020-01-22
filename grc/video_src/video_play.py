import numpy
from gnuradio import gr
import subprocess

class video_play(gr.sink):
    """
    """
    def __init__(self):
        self.video = subprocess.Popen([
            "ffplay", "-"
            ], stdin = subprocess.PIPE)
        gr.sink.__init__(self,
            name="video_play",
            in_sig=[numpy.byte])
        #self.set_auto_consume(False)

    def forecast (self,noutput_items,ninput_items_required):
        ninput_items_required[0] = 1024

    def general_work(self, input_items, output_items):
        in0 = input_items[0]
        self.video.stdin.write(in0)
        self.consume(0,len(in0))
        print(len(in0))
        return 0

