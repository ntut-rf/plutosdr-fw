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

#ifndef INCLUDED_DTV_DVBT_ENERGY_DISPERSAL_IMPL_H
#define INCLUDED_DTV_DVBT_ENERGY_DISPERSAL_IMPL_H

#include <gnuradio/block.h>

namespace gr {
namespace dtv {

/*!
 * \brief Energy dispersal.
 * \ingroup dtv
 *
 * ETSI EN 300 744 - Clause 4.3.1 \n
 * Input - MPEG-2 transport packets (including sync - 0x47). \n
 * Output - Randomized MPEG-2 transport packets. \n
 * If first byte is not a SYNC then look for it. \n
 * First sync in a row of 8 packets is reversed - 0xB8. \n
 * Block size is 188 bytes.
 */
template<int d_nblocks = 1,int d_npacks = 8,int d_psize = 188>
class dvbt_energy_dispersal_impl :
public gr::block<sizeof(unsigned char),sizeof(unsigned char) * d_nblocks * d_npacks * d_psize>
{
private:
    // Number of blocks
    static const int nblocks = d_nblocks;
    // Packet size
    static const int psize = d_psize;
    // Number of packets after which PRBS is reset
    static const int npacks = d_npacks;
    // SYNC value
    static const int d_SYNC = 0x47;
    // Negative SYNC value
    static const int d_NSYNC = 0xB8;

    // Register for PRBS
    int d_reg = 0xa9;

    void init_prbs();
    int clock_prbs(int clocks);

public:

    void forecast(int noutput_items, gr_vector_int& ninput_items_required);

    int general_work(int noutput_items,
                     gr_vector_int& ninput_items,
                     gr_vector_const_void_star& input_items,
                     gr_vector_void_star& output_items);

    using gr::block<sizeof(unsigned char),sizeof(unsigned char) * d_nblocks * d_npacks * d_psize>::consume_each;
};

} // namespace dtv
} // namespace gr

#endif /* INCLUDED_DTV_DVBT_ENERGY_DISPERSAL_IMPL_H */
