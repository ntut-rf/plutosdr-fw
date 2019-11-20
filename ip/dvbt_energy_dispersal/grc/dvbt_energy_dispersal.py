#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# Copyright 2019 gr-howto author.
#
# This is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3, or (at your option)
# any later version.
#
# This software is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this software; see the file COPYING.  If not, write to
# the Free Software Foundation, Inc., 51 Franklin Street,
# Boston, MA 02110-1301, USA.
#


import numpy
from gnuradio import gr

class dvbt_energy_dispersal(gr.basic_block):
    """
    """
    def __init__(self):
        gr.basic_block.__init__(self,
            name="dvbt_energy_dispersal",
            in_sig=[numpy.byte],
            out_sig=[(numpy.byte,1504)])
        #self.set_auto_consume(False)

    def forecast (self,noutput_items,ninput_items_required):
        ninput_items_required[0] = noutput_items * 1504

    def general_work(self, input_items, output_items):
        in0 = input_items[0][:1504]
        out = output_items[0]
        for i in range(0,1504):
            out[::,i] = in0[i]
        self.consume(0,len(in0))
        return len(out)

