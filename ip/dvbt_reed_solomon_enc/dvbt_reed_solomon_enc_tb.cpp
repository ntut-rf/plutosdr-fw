#include <stdio.h>
#include <stdlib.h>
#include <iostream>

#include "dvbt_reed_solomon_enc.h"

#define INPUT_SIZE 1880
axis_uint8_t signal_in[INPUT_SIZE];
axis_uint8_t signal_out[INPUT_SIZE];

int main (void)
{
	dvbt_reed_solomon_enc(signal_in, signal_out);
	return 0;
}