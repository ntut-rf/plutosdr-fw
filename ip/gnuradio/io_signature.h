/* -*- c++ -*- */
/*
 * Copyright 2004,2007 Free Software Foundation, Inc.
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

#ifndef INCLUDED_IO_SIGNATURE_H
#define INCLUDED_IO_SIGNATURE_H

#include <gnuradio/api.h>
#include <gnuradio/runtime_types.h>
#include <tuple>

namespace gr {

// template<int min_streams=1, int max_streams=1>
// using io_signature = std::tuple<>

// template <int min_streams, int max_streams, int sizeof_stream_item>
// struct io_signature
// {};

/*!
 * \brief i/o signature for input and output ports.
 * \brief misc
 */
// template<int min_streams=1, int max_streams=1>
// // using io_signature = typename <int min_streams, int max_streams, std::array<int, max_streams>>;
// class GR_RUNTIME_API io_signature
// {
// public:
//     int min_streams = min_streams;
//     int d_max_streams;
//     std::vector<int> d_sizeof_stream_item;

//     io_signature(){}

//     io_signature(int min_streams, int max_streams, const std::vector<int>& sizeof_stream_items) :
//         d_min_streams(min_streams), d_max_streams(max_streams), d_sizeof_stream_item(sizeof_stream_items)
//     {}
// };

} /* namespace gr */

#endif /* INCLUDED_IO_SIGNATURE_H */
