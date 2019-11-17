#ifndef __DVBT_ENERGY_DISPERSAL_H__
#define __DVBT_ENERGY_DISPERSAL_H__

#include <ap_int.h>
#include <ap_axi_sdata.h>

typedef ap_axiu<8,2,1,1> axis_uint8_t; // data,user,id,last
#define USER_BLOCK_BEGIN 1
#define USER_BLOCK_END   2

void dvbt_energy_dispersal (axis_uint8_t* IN, axis_uint8_t* OUT);

#endif