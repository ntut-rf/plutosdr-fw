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

#ifndef INCLUDED_DTV_DVBT_CONFIGURE_H
#define INCLUDED_DTV_DVBT_CONFIGURE_H

#include <gnuradio/dtv/dvb_config.h>
#include <gnuradio/dtv/dvbt_config.h>

class dvbt_configure
{
public:
    int d_symbols_per_frame;
    int d_frames_per_superframe;

    int d_symbol_index;
    int d_frame_index;
    int d_superframe_index;

    // Constelaltion parameters
    dvb_constellation_t d_constellation;
    int d_constellation_size;
    int d_step;
    int d_m;
    float d_norm;

    // Hierarchy information
    dvbt_hierarchy_t d_hierarchy;
    int d_alpha;

    // Inner Coding parameters
    dvb_code_rate_t d_code_rate_HP;
    dvb_code_rate_t d_code_rate_LP;

    // Guard interval length
    dvb_guardinterval_t d_guard_interval;

    // Transmission type parameters
    dvbt_transmission_mode_t d_transmission_mode;

    // Include cell id + cell id parameters
    int d_include_cell_id;
    int d_cell_id;

    // Puncturer parameters
    int d_cr_k;
    int d_cr_n;
    int d_cr_p;

    // Other DVB-T parameters
    int d_Kmin;
    int d_Kmax;
    int d_fft_length;
    int d_payload_length;
    int d_zeros_on_left;
    int d_zeros_on_right;
    int d_cp_length;

    dvbt_configure(dvb_constellation_t constellation = MOD_16QAM,
                   dvbt_hierarchy_t hierarchy = NH,
                   dvb_code_rate_t code_rate_HP = C1_2,
                   dvb_code_rate_t code_rate_LP = C1_2,
                   dvb_guardinterval_t guard_interval = GI_1_32,
                   dvbt_transmission_mode_t transmission_mode = T2k,
                   int include_cell_id = 0,
                   int cell_id = 0);
};

#endif /* INCLUDED_DTV_DVBT_CONFIGURE_H */
