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

typedef ap_axiu<8,1,1,1> axis_uint8_t;

const int D_NPACKS = 8;
const int D_PSIZE = 188;
const int D_SYNC = 0x47;
const int D_NSYNC = 0xB8;

int d_reg = 0xa9;
int d_nblocks = 1;

void init_prbs()
{
    d_reg = 0xa9;
}

int clock_prbs(int clocks)
{
    int res = 0;
    int feedback = 0;

    for (int i = 0; i < clocks; i++) {
        feedback = ((d_reg >> (14 - 1)) ^ (d_reg >> (15 - 1))) & 0x1;
        d_reg = ((d_reg << 1) | feedback) & 0x7fff;
        res = (res << 1) | feedback;
    }
    return res;
}

void dvbt_energy_dispersal (axis_uint8_t* IN, axis_uint8_t* OUT)
{
#pragma HLS INTERFACE axis port=IN
#pragma HLS INTERFACE axis port=OUT

    int is_sync = 0;

    // Search for SYNC byte
    for (int i = 0; i < D_PSIZE; i++) {
        axis_uint8_t in = *IN++;
        if (in.data == D_SYNC) {
            is_sync = 1;
            break;
        }
    }

    // If we found a SYNC byte
    if (is_sync) {
        for (int i = 0; i < d_nblocks; i++) {
            init_prbs();

            for (int j = 0; j < D_NPACKS; j++) {

                axis_uint8_t in = *IN++;
                if (in.data != D_SYNC) {
                    printf("Malformed MPEG-TS!");
                }

                axis_uint8_t out = in;
                out.data = D_NSYNC;
                *OUT++ = out;

                for (int k = 1; k < D_PSIZE; k++) {
                    axis_uint8_t in = *IN++;
                    axis_uint8_t out = in;
                    out.data = in.data ^ clock_prbs(D_NPACKS);
                    *OUT++ = out;
                }

                clock_prbs(D_NPACKS);
            }
        }
    }
}