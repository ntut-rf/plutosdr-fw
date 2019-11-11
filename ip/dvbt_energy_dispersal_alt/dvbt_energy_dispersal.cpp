#include <stdio.h>
#include "axis_uint8_t.h"
#include "dvbt_energy_dispersal_impl.h"

gr::dtv::dvbt_energy_dispersal_impl<> impl;

void dvbt_energy_dispersal (axis_uint8_t* IN, axis_uint8_t* OUT)
{
#pragma HLS INTERFACE axis port=IN
#pragma HLS INTERFACE axis port=OUT

    // Get I/O signature
    int input_signature = impl.sizeof_input_stream_item;
    int output_signature = impl.sizeof_input_stream_item;
    printf("input signature: %d\n", input_signature);
    printf("output signature: %d\n", output_signature);

    // // Forecast number of input items required
    // int noutput_items = 1;
    // gr_vector_int ninput_items = {0};
    // impl.forecast(noutput_items, ninput_items);
    // printf("number of input items: %d\n", ninput_items[0]);
    // printf("number of output items: %d\n", noutput_items);

    // Allocate I/O buffer
    unsigned char in[input_signature];//[input_signature*ninput_items[0]];
    unsigned char out[output_signature];//[output_signature*noutput_items];
    // gr_vector_const_void_star   input_items     {in};
    // gr_vector_void_star         output_items    {out};

    axis_uint8_t axis_in;

    for (int i = 0; i < sizeof(in); i++)
    {
        axis_in = *IN++;
        in[i] = axis_in.data;
    }

    //impl.general_work(noutput_items, ninput_items, input_items, output_items);

    for (int i = 0; i < sizeof(out); i++)
    {
        axis_uint8_t axis_out = axis_in;
        axis_out.data = out[i];
        axis_out.user = 0;
        axis_out.last = 0;
        // axis_out.keep = 0;
        // axis_out.strb = 0;
        // axis_out.dest = 0;
        *OUT++ = axis_out;
    }
}