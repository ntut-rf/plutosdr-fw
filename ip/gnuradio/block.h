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

/*!
 * \brief The abstract base class for all 'terminal' processing blocks.
 * \ingroup base_blk
 *
 * A signal processing flow is constructed by creating a tree of
 * hierarchical blocks, which at any level may also contain terminal
 * nodes that actually implement signal processing functions. This
 * is the base class for all such leaf nodes.
 *
 * Blocks have a set of input streams and output streams.  The
 * input_signature and output_signature define the number of input
 * streams and output streams respectively, and the type of the data
 * items in each stream.
 *
 * Blocks report the number of items consumed on each input in
 * general_work(), using consume() or consume_each().
 *
 * If the same number of items is produced on each output, the block
 * returns that number from general_work(). Otherwise, the block
 * calls produce() for each output, then returns
 * WORK_CALLED_PRODUCE. The input and output rates are not required
 * to be related.
 *
 * User derived blocks override two methods, forecast and
 * general_work, to implement their signal processing
 * behavior. forecast is called by the system scheduler to determine
 * how many items are required on each input stream in order to
 * produce a given number of output items.
 *
 * general_work is called to perform the signal processing in the
 * block.  It reads the input items and writes the output items.
 */
class GR_RUNTIME_API block : public basic_block
{
public:
    //! Magic return values from general_work
    enum { WORK_CALLED_PRODUCE = -2, WORK_DONE = -1 };

    virtual ~block() {}

    // ----------------------------------------------------------------
    //		override these to define your behavior
    // ----------------------------------------------------------------

    /*!
     * \brief  Estimate input requirements given output request
     *
     * \param noutput_items           number of output items to produce
     * \param ninput_items_required   number of input items required on each input stream
     *
     * Given a request to product \p noutput_items, estimate the
     * number of data items required on each input stream.  The
     * estimate doesn't have to be exact, but should be close.
     */
    virtual void forecast(int noutput_items, gr_vector_int& ninput_items_required) {}

    /*!
     * \brief compute output items from input items
     *
     * \param noutput_items	number of output items to write on each output stream
     * \param ninput_items	number of input items available on each input stream
     * \param input_items	vector of pointers to the input items, one entry per input
     * stream
     * \param output_items	vector of pointers to the output items, one entry per
     * output stream
     *
     * \returns number of items actually written to each output stream
     * or WORK_CALLED_PRODUCE or WORK_DONE.  It is OK to return a
     * value less than noutput_items.
     *
     * WORK_CALLED_PRODUCE is used where not all outputs produce the
     * same number of items. general_work must call produce() for each
     * output to indicate the number of items actually produced.
     *
     * WORK_DONE indicates that no more data will be produced by this block.
     *
     * general_work must call consume or consume_each to indicate how
     * many items were consumed on each input stream.
     */
    virtual int general_work(int noutput_items,
                             gr_vector_int& ninput_items,
                             gr_vector_const_void_star& input_items,
                             gr_vector_void_star& output_items)
    {
        return 0;
    }

    /*!
     * \brief Set the approximate output rate / input rate
     *
     * Provide a hint to the buffer allocator and scheduler.
     * The default relative_rate is 1.0
     *
     * decimators have relative_rates < 1.0
     * interpolators have relative_rates > 1.0
     */
    void set_relative_rate(double relative_rate)
    {}

    /*!
     * \brief Set the approximate output rate / input rate as an integer ratio
     *
     * Provide a hint to the buffer allocator and scheduler.
     * The default relative_rate is interpolation / decimation = 1 / 1
     *
     * decimators have relative_rates < 1.0
     * interpolators have relative_rates > 1.0
     */
    void set_relative_rate(uint64_t interpolation, uint64_t decimation)
    {}

    /*!
     * \brief Tell the scheduler \p how_many_items were consumed on
     * each input stream.
     *
     * Also see notes on consume().
     */
    void consume_each(int how_many_items)
    {
        printf("consume_each: %d\n", how_many_items);
    }

protected:
    block(void) {} // allows pure virtual interface sub-classes
    block(const std::string& name,
          gr::io_signature::sptr input_signature,
          gr::io_signature::sptr output_signature)
          : basic_block(name, input_signature, output_signature) {}
};

} /* namespace gr */

#endif /* INCLUDED_GR_RUNTIME_BLOCK_H */
