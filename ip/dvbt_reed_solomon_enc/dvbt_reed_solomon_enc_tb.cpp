#include <stdio.h>
#include <stdlib.h>
#include <iostream>

#include "dvbt_reed_solomon_enc.h"

#define INPUT_SIZE ((239-51)*8)
#define OUTPUT_SIZE ((155-51)*8)
axis_uint8_t signal_in[INPUT_SIZE];
axis_uint8_t signal_out[OUTPUT_SIZE];

int main (void)
{
    for (int i=0; i<INPUT_SIZE; i++)
	{
        signal_in[i].data = i;
		signal_in[i].user = 0x00;
		signal_in[i].last = (i == INPUT_SIZE-1)? 1:0;
    }

	dvbt_reed_solomon_enc(signal_in, signal_out);

    for (int i=0; i<OUTPUT_SIZE; i++)
	{
        if (signal_out[i].user == USER_BLOCK_BEGIN)
            printf("\nBlock begin\n");

        printf("%02x ", (uint8_t)signal_out[i].data);

        if (signal_out[i].user == USER_BLOCK_END)
            printf("\nBlock end\n");		
	}

	return 0;
}