#include "dvbt_reed_solomon_enc_impl.h"
#include "dvbt_reed_solomon_enc.h"

dvbt_reed_solomon_enc_impl rs_enc(2,8,285,255,239,8,51,8);

void dvbt_reed_solomon_enc (axis_uint8_t* IN, axis_uint8_t* OUT)
{
#pragma HLS INTERFACE axis port=IN
#pragma HLS INTERFACE axis port=OUT
    int input_signature = rs_enc.input_signature()->sizeof_stream_item(0);
    int output_signature = rs_enc.output_signature()->sizeof_stream_item(0);

    //rs_enc.general_work();

    printf("input signature: %d\n", input_signature);
    printf("output signature: %d\n", output_signature);
}