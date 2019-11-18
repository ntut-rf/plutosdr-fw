#include "dvbt_reed_solomon_enc_impl.h"
#include "dvbt_reed_solomon_enc.h"
#include <stdint.h>

dvbt_reed_solomon_enc_impl rs_enc(2,8,285,255,239,8,51,8);

void dvbt_reed_solomon_enc (axis_uint8_t* IN, axis_uint8_t* OUT)
{
#pragma HLS INTERFACE axis port=IN
#pragma HLS INTERFACE axis port=OUT
    
    unsigned char buf_in[(239-51)*8] = {0};
    unsigned char buf_out[(255-51)*8] = {0};

    axis_uint8_t in;
    for (int i=0; i<sizeof(buf_in); i++) {
        in = *IN++;
        buf_in[i] = in.data;
    }
    rs_enc.general_work(buf_in, buf_out);

    for (int i=0; i<sizeof(buf_out); i++) {
        axis_uint8_t out = in;
        out.data = buf_out[i];
        switch (i)
        {
            case 0:             out.user = USER_BLOCK_BEGIN; break;
            case sizeof(buf_out)-1: out.user = USER_BLOCK_END; break;
            default:            out.user = 0;
        }
        *OUT++ = out;
    }
}
