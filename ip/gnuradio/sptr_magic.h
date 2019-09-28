/* -*- c++ -*- */
/*
 * Copyright 2008,2013 Free Software Foundation, Inc.
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
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#ifndef INCLUDED_GR_RUNTIME_SPTR_MAGIC_H
#define INCLUDED_GR_RUNTIME_SPTR_MAGIC_H

#include <gnuradio/api.h>
#include <memory>

namespace gnuradio {
template <class T>
std::shared_ptr<T> get_initial_sptr(T* p)
{
    return std::shared_ptr<T>(p);
}
} // namespace gnuradio

#endif /* INCLUDED_GR_RUNTIME_SPTR_MAGIC_H */
