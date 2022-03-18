#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include "add_one.h"

#define INPUT_SIZE 100
_Complex float signal_in[INPUT_SIZE];
_Complex float signal_out[INPUT_SIZE];

int main (void)
{
	for (int i=0; i<INPUT_SIZE; i++)
	{
		signal_in[i] = i;
	}

	//Perform top function:
	add_one(signal_in, signal_out);

	//Check results...
	for (int i=0; i<INPUT_SIZE; i++)
	{
		std::cout << __real__ signal_out[i] << std::endl;
	}

	return 0;
}