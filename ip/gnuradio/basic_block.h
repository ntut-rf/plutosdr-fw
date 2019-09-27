/* -*- c++ -*- */
/*
 * Copyright 2006,2008,2009,2011,2013 Free Software Foundation, Inc.
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

#ifndef INCLUDED_GR_BASIC_BLOCK_H
#define INCLUDED_GR_BASIC_BLOCK_H

#include <gnuradio/api.h>
#include <gnuradio/io_signature.h>
#include <gnuradio/runtime_types.h>
#include <gnuradio/sptr_magic.h>
#include <string>

namespace gr {

class GR_RUNTIME_API basic_block 
{
public:
    basic_block(void) {}
    basic_block(const std::string& name,
                gr::io_signature::sptr input_signature,
                gr::io_signature::sptr output_signature);
};

} /* namespace gr */

#endif /* INCLUDED_GR_BASIC_BLOCK_H */
