/* -*- c++ -*- */
/*
 * Copyright 2004,2007,2009,2010,2013,2017 Free Software Foundation, Inc.
 *
 * This file is part of GNU Radio
 *
 * GNU Radio is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3, or (at your option)
 * any later version.
 *
 * GNU Radio is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with GNU Radio; see the file COPYING.  If not, write to
 * the Free Software Foundation, Inc., 51 Franklin Street,
 * Boston, MA 02110-1301, USA.
 */

#ifndef INCLUDED_GR_RUNTIME_BLOCK_H
#define INCLUDED_GR_RUNTIME_BLOCK_H

#include <gnuradio/api.h>
#include <gnuradio/basic_block.h>
#include <gnuradio/logger.h>

namespace gr {

class GR_RUNTIME_API block : public basic_block
{
public:
    // void set_processor_affinity(const std::vector<int>& mask) {}
    // void unset_processor_affinity() {}
    // std::vector<int> processor_affinity() { return std::vector<int>(); }
    
    // void set_log_level(std::string level) {}
    // std::string log_level() { return NULL; }

    block(void) {}
    block(const std::string& name,
          gr::io_signature::sptr input_signature,
          gr::io_signature::sptr output_signature) {}

    void consume_each(int how_many_items) {}
};

typedef std::vector<block_sptr> block_vector_t;
typedef std::vector<block_sptr>::iterator block_viter_t;

} /* namespace gr */

#endif /* INCLUDED_GR_RUNTIME_BLOCK_H */
