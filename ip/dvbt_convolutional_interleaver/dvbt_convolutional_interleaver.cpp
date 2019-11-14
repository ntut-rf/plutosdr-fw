/* -*- c++ -*- */
/*
 * Copyright 2015 Free Software Foundation, Inc.
 *
 * This is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3, or (at your option)
 * any later version.
 *
 * This software is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this software; see the file COPYING.  If not, write to
 * the Free Software Foundation, Inc., 51 Franklin Street,
 * Boston, MA 02110-1301, USA.
 */

#include <stdio.h>
#include <ap_int.h>
#include <ap_axi_sdata.h>
#include "dvbt_convolutional_interleaver.h"
#include <deque>

/*
 * The private constructor
 */
dvbt_convolutional_interleaver_impl(int blocks,
int I,
sizeof(unsigned char) * I * blocks),
sizeof(unsigned char)),
I * blocks),
      d_I(I),
      d_M(M)
{
    // Positions are shift registers (FIFOs)
    // of length i*M
    for (int i = 0; i < d_I; i++) {
        d_shift.push_back(new std::deque<unsigned char>(d_M * i, 0));
    }
}

void dvbt_convolutional_interleaver (axis_uint8_t* IN, axis_uint8_t* OUT)
{
#pragma HLS INTERFACE axis port=IN
#pragma HLS INTERFACE axis port=OUT

    for (int i = 0; i < (noutput_items / d_I); i++) {
        // Process one block of I symbols
        for (unsigned int j = 0; j < d_shift.size(); j++) {
            d_shift[j]->push_front(in[(d_I * i) + j]);
            out[(d_I * i) + j] = d_shift[j]->back();
            d_shift[j]->pop_back();
        }
    }
}
