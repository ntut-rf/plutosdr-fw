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
#include <string>

namespace gr {

/*!
 * \brief The abstract base class for all signal processing blocks.
 * \ingroup internal
 *
 * Basic blocks are the bare abstraction of an entity that has a
 * name, a set of inputs and outputs, and a message queue.  These
 * are never instantiated directly; rather, this is the abstract
 * parent class of both gr_hier_block, which is a recursive
 * container, and block, which implements actual signal
 * processing functions.
 */

template <int d_sizeof_input_stream_item, int d_sizeof_output_stream_item>
class GR_RUNTIME_API basic_block
{
public:

    static const int sizeof_input_stream_item = d_sizeof_input_stream_item;
    static const int sizeof_output_stream_item = d_sizeof_output_stream_item;

protected:

    //std::string d_name;
    // gr::io_signature<min_streams,max_streams> d_input_signature;
    // gr::io_signature<min_streams,max_streams> d_output_signature;

    basic_block(void) {} // allows pure virtual interface sub-classes

    //! Protected constructor prevents instantiation by non-derived classes
    // basic_block(//const std::string& name,
    //             io_signature<min_streams,max_streams> input_signature,
    //             io_signature<min_streams,max_streams> output_signature)
    // : //d_name(name),
    //   d_input_signature(input_signature),
    //   d_output_signature(output_signature)
    // {}

    //! may only be called during constructor
    // void set_input_signature(gr::io_signature::sptr iosig)
    // { 
    //     d_input_signature = iosig;
    // }

    // //! may only be called during constructor
    // void set_output_signature(gr::io_signature::sptr iosig)
    // {
    //     d_output_signature = iosig;
    // }

public:
    ~basic_block() {}

    /*! The name of the block */
    //std::string name() const { return d_name; }
    //int min_streams() const { return _min_streams; }
    //int max_streams() const { return _max_streams; }
};

} /* namespace gr */

#endif /* INCLUDED_GR_BASIC_BLOCK_H */
