/* -*- c++ -*- */
/*
 * Copyright 2015,2016 Free Software Foundation, Inc.
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

#include "dvbt_reed_solomon_enc_impl.h"
#include <stdint.h>

static const int rs_init_symsize = 8;
static const int rs_init_fcr = 0;  // first consecutive root
static const int rs_init_prim = 1; // primitive is 1 (alpha)

dvbt_reed_solomon_enc_impl::dvbt_reed_solomon_enc_impl(
    int p, int m, int gfpoly, int n, int k, int t, int s, int blocks)
    : d_n(n),
      d_k(k),
      d_s(s),
      d_blocks(blocks)
{
    d_rs = init_rs_char(rs_init_symsize, gfpoly, rs_init_fcr, rs_init_prim, (n - k));
}

void dvbt_reed_solomon_enc_impl::encode(const uint8_t* in, uint8_t* out)
{
    // Shortened Reed-Solomon: prepend zero bytes to message (discarded after encoding)
    for (int i = 0; i < d_s; i++)
        d_data[i] = 0;

    // This is the number of data bytes we need from the input stream.
    int shortened_k = d_k - d_s;
    for (int i = 0; i < shortened_k; i++)
        d_data[d_s + i] = in[i];

    // Copy input message to output then append Reed-Solomon bits
    for (int i = 0; i < shortened_k; i++)
        out[i] = in[i]; 

    encode_rs_char(d_rs, d_data, &out[shortened_k]);
}

void dvbt_reed_solomon_enc_impl::general_work(uint8_t* in, uint8_t* out)
{
    int j = 0;
    int k = 0;
    for (int i = 0; i < d_blocks; i++) {
        encode(in + j, out + k);
        j += (d_k - d_s);
        k += (d_n - d_s);
    }
}