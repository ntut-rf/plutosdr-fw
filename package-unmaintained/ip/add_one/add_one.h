#ifndef __ADD_ONE_H__
#define __ADD_ONE_H__

#include <ap_int.h>
#include <ap_axi_sdata.h>

typedef ap_axiu<8,1,1,1> axis_uint8_t;

void add_one (axis_uint8_t* A, axis_uint8_t* B);

#endif