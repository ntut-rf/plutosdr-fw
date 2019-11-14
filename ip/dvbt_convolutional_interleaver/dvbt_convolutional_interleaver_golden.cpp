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

#include <stdint.h>
#include <stdio.h>
#include <vector>
#include <deque>

#define INPUT_SIZE 12000
uint8_t signal_in[INPUT_SIZE];
uint8_t signal_out[INPUT_SIZE];

const int d_M = 12;
const int d_I = 12;
std::vector<std::deque<unsigned char>*> d_shift;

void init()
{
    // Positions are shift registers (FIFOs)
    // of length i*M
    for (int i = 0; i < d_I; i++) {
        d_shift.push_back(new std::deque<unsigned char>(d_M * i, 0));
    }
}

int work(int noutput_items, uint8_t* out, uint8_t* in)
{
    for (int i = 0; i < (noutput_items / d_I); i++) {
        // Process one block of I symbols
        for (unsigned int j = 0; j < d_shift.size(); j++) {
            d_shift[j]->push_front(in[(d_I * i) + j]);
            out[(d_I * i) + j] = d_shift[j]->back();
            d_shift[j]->pop_back();
        }
    }

    // Tell runtime system how many output items we produced.
    return noutput_items;
}

int main()
{
    for (int i=0; i<INPUT_SIZE; i++) {
        signal_in[i] = i;
        printf("%02x ", (uint8_t)signal_in[i]);
    }		
    printf("\n\n");
	
    init();
    int o = work(INPUT_SIZE, signal_out, signal_in);

    for (int i=0; i<INPUT_SIZE; i++)
		printf("%02x ", (uint8_t)signal_out[i]);
    printf("\n\n");

    printf("o: %d\n", o);
}
