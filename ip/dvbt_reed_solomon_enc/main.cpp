#include <stdio.h>
#include <gnuradio/types.h>

#include "dvbt_reed_solomon_enc_impl.h"

int main (void)
{
    gr::dtv::dvbt_reed_solomon_enc_impl rs_enc(2,8,285,255,239,8,51,8);
    
    int noutput_items = 10;
    unsigned char in[20480] = {0};
    for (int i=0; i<20480; i++)
        in[i] = i;

    unsigned char out[20480] = {0};

    int _ninput_items[] = {noutput_items};
    int* ninput_items = _ninput_items;

    const void* _input_items[] = {in};
    const void** input_items = _input_items;

    void* _output_items[] = {out};
    void** output_items = _output_items;
    
    rs_enc.general_work(noutput_items, ninput_items, input_items, output_items);
    
    for (int i=0; i<1000; i++)
        printf("%02x ", out[i]);
    printf("\n");

    printf("Done\n");
    return 0;
}