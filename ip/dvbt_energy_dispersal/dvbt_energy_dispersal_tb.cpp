#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include "dvbt_energy_dispersal.h"

#define INPUT_SIZE 1880
axis_uint8_t signal_in[INPUT_SIZE];
axis_uint8_t signal_out[INPUT_SIZE];

int main (void)
{
	for (int i=0; i<INPUT_SIZE; i++)
	{
		signal_in[i].data = i;
		signal_in[i].user = 0x00;
		signal_in[i].last = (i == INPUT_SIZE-1)? 1:0;
	}

	//Perform top function:
	dvbt_energy_dispersal(signal_in, signal_out);

	//Check results...
	for (int i=0; i<INPUT_SIZE; i++)
	{
		//printf("user: %x\n", signal_out[i].user);
		//std::cout << std::hex << signal_out[i].data << std::endl;
	}

	return 0;
}