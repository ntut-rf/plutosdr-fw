#include <stdio.h>
#include "axis_uint8_t.h"
#include "dvbt_energy_dispersal_impl.h"

gr::dtv::dvbt_energy_dispersal_impl impl(1);

void dvbt_energy_dispersal (axis_uint8_t* IN, axis_uint8_t* OUT)
{
#pragma HLS INTERFACE axis port=IN
#pragma HLS INTERFACE axis port=OUT

    // Get I/O signature
    int input_signature = impl.input_signature()->sizeof_stream_item(0);
    int output_signature = impl.output_signature()->sizeof_stream_item(0);
    printf("input signature: %d\n", input_signature);
    printf("output signature: %d\n", output_signature);

    // Forecast number of input items required
    int noutput_items = 1;
    gr_vector_int ninput_items = {0};
    impl.forecast(noutput_items, ninput_items);
    printf("number of input items: %d\n", ninput_items[0]);
    printf("number of output items: %d\n", noutput_items);

    // Allocate I/O buffer
    // unsigned char in[input_signature*ninput_items[0]] = {0};
    // unsigned char out[output_signature*noutput_items] = {0};
    // gr_vector_const_void_star   input_items     {in};
    // gr_vector_void_star         output_items    {out};
}