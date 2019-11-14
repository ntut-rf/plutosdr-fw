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

#include <stdint.h>
#include "dvbt_convolutional_interleaver.h"

// Number of shift registers
const int d_I = 12;
// Depth of shift registers
const int d_M = 12;

// shift registers
static uint8_t d_shift[d_I][d_M * d_I + 1] = {0};
// length of shift register i
static int len(int i) { return d_M * i; }
// index of shift register i
static int idx[d_I] = {0};

int dvbt_convolutional_interleaver(int noutput_items, uint8_t* out, uint8_t* in)
{
    for (int i = 0; i < (noutput_items / d_I); i++) {
            for (int j = 0; j < d_I; j++) {
                if (len(j) == 0) out[(d_I * i) + j] = in[(d_I * i) + j];
                else {
                    out[(d_I * i) + j] = d_shift[j][idx[j]];
                    d_shift[j][idx[j]] = in[(d_I * i) + j];
                    idx[j] = (idx[j]+1) % len(j);
                }
            }
        }

    // Tell runtime system how many output items we produced.
    return noutput_items;
}