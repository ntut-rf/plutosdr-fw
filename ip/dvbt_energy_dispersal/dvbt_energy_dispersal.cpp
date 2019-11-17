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
#include "dvbt_energy_dispersal.h"

int d_reg = 0xa9;

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

// signature in:  1
// signature out: nblocks * d_npacks * d_psize

void dvbt_energy_dispersal (axis_uint8_t* IN, axis_uint8_t* OUT)
{
#pragma HLS INTERFACE axis port=IN
#pragma HLS INTERFACE axis port=OUT

    int is_sync = 0;

    // Search for SYNC byte
    for (int i = 0; i < D_PSIZE; i++) {
        axis_uint8_t in = *IN;
        if (in.last) return;
        if (in.data == D_SYNC) {
            printf("SYNC\n");
            is_sync = 1;
            break;
        }
        IN++;
    }

    // If we found a SYNC byte
    if (is_sync) {
        for (int i = 0; i < D_NBLOCKS; i++) {
            init_prbs();
            printf("init_prbs()\n");

            for (int j = 0; j < D_NPACKS; j++) {

                axis_uint8_t in = *IN++;
                if (in.last) return;
                if (in.data != D_SYNC)
                    printf("Malformed MPEG-TS!\n");
                else
                    printf("Sync ok\n");

                axis_uint8_t out;
                out.data = D_NSYNC;
                out.user = (i == 0 && j == 0) ? USER_BLOCK_BEGIN : 0;
                *OUT++ = out;

                for (int k = 1; k < D_PSIZE; k++) {

                    axis_uint8_t in = *IN++;
                    if (in.last) return;

                    axis_uint8_t out;
                    out.data = in.data ^ clock_prbs(D_NPACKS);
                    out.user = (i == D_NBLOCKS-1 && j == D_NPACKS-1 && k == D_PSIZE-1) ? USER_BLOCK_END : 0;
                    *OUT++ = out;
                }

                clock_prbs(D_NPACKS);
            }
        }
    }
}