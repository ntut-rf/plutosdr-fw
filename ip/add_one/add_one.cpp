#include "add_one.h"

void add_one (axis_uint8_t* A, axis_uint8_t* B)
{
#pragma HLS INTERFACE axis port=A
#pragma HLS INTERFACE axis port=B

    while (1)
    {
		axis_uint8_t a = *A; // each A only read once
		a.data += 1;
		*B = a; // each B only written once
		if (a.last) break;
		A++;
		B++;
	}
}
