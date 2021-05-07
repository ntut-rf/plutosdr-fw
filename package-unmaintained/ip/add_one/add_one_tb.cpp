#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include "add_one.h"

#define INPUT_SIZE 100
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
	add_one(signal_in, signal_out);

	//Check results...
	for (int i=0; i<INPUT_SIZE; i++)
	{
		std::cout << std::hex << signal_out[i].data << std::endl;
	}

	return 0;
}