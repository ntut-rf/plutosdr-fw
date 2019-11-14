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

#ifndef INCLUDED_DTV_DVBT_INNER_CODER_IMPL_H
#define INCLUDED_DTV_DVBT_INNER_CODER_IMPL_H

#include "dvbt_configure.h"

// io_signature::make(1, 1, sizeof(unsigned char)),
// io_signature::make(1, 1, sizeof(unsigned char) * noutput)),
// config(constellation, hierarchy, coderate, coderate),
// d_ninput(ninput),
// d_noutput(noutput)

const dvbt_configure config;
int d_ninput;
int d_noutput;

int work(int noutput_items, uint8_t* in, uint8_t* out);

#endif /* INCLUDED_DTV_DVBT_INNER_CODER_IMPL_H */
