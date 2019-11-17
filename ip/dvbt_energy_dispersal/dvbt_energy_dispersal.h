#ifndef __DVBT_ENERGY_DISPERSAL_H__
#define __DVBT_ENERGY_DISPERSAL_H__

#include <ap_int.h>
#include <ap_axi_sdata.h>

typedef ap_axiu<8,2,1,1> axis_uint8_t; // data,user,id,last
#define USER_BLOCK_BEGIN 1
#define USER_BLOCK_END   2

#define D_NPACKS 8
#define D_PSIZE 188
#define D_SYNC 0x47
#define D_NSYNC 0xB8
#define D_NBLOCKS 1

int dvbt_energy_dispersal (axis_uint8_t* IN, axis_uint8_t* OUT);

#endif