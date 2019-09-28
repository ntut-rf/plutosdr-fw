#ifndef __DVBT_REED_SOLOMON_ENC_H__
#define __DVBT_REED_SOLOMON_ENC_H__

#include <ap_int.h>
#include <ap_axi_sdata.h>

typedef ap_axiu<8,1,1,1> axis_uint8_t;

void dvbt_reed_solomon_enc (axis_uint8_t* IN, axis_uint8_t* OUT);

#endif