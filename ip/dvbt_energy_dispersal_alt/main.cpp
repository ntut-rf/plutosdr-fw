#include <stdio.h>

#include "dvbt_energy_dispersal_impl.h"

gr::dtv::dvbt_energy_dispersal_impl impl(1);

int main (void)
{
    int input_signature = impl.input_signature()->sizeof_stream_item(0);
    int output_signature = impl.output_signature()->sizeof_stream_item(0);
    printf("input signature: %d\n", input_signature);
    printf("output signature: %d\n", output_signature);
    
    int noutput_items = 5;
    gr_vector_int ninput_items{noutput_items};
    unsigned char in[input_signature*ninput_items[0]] = {0};
    for (int i=0; i<input_signature*ninput_items[0]; i++)
        in[i] = i;
    unsigned char out[output_signature*noutput_items] = {0};
    
    gr_vector_const_void_star   input_items     {in};
    gr_vector_void_star         output_items    {out};
    impl.general_work(noutput_items, ninput_items, input_items, output_items);
    
    for (int i=0; i<output_signature*noutput_items; i++)
        printf("%02x ", out[i]);
    printf("\n");

    printf("Done\n");
    return 0;
}