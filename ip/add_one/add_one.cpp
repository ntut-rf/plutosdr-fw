#include "add_one.h"

void add_one (_Complex float* A, _Complex float* B)
{
#pragma HLS INTERFACE axis port=A
#pragma HLS INTERFACE axis port=B
	for (int i = 0; i < 10; i++) {
		_Complex float a = *A++; // each A only read once
		a += 1;
		*B++= a;
		*B++= a;
	}
}
