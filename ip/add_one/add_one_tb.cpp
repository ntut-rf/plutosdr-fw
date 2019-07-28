#include <stdio.h>
#include <stdlib.h>
#include <ap_axi_sdata.h>
#include <hls_stream.h>

typedef ap_axiu<8,1,1,1> data_element;

hls::stream<data_element> signal_in;  //Passed by reference to TOP function
hls::stream<data_element> signal_out; //Passed by reference to TOP function

void add_one (hls::stream<data_element> &A, hls::stream<data_element> &B);

#define INPUT_SIZE 100

int main (void)
{
	for (int i=0; i<INPUT_SIZE; i++)
	{
		data_element data;
		data.data = i;
		data.user = 0x00;
		data.last = (i == INPUT_SIZE-1)? 1:0;
		signal_in << data;
	}

	//Perform top function:
	while (!signal_in.empty())
		add_one(signal_in, signal_out);

	//Check results...
	while (!signal_out.empty())
	{
		data_element tmp;
		signal_out >> tmp;

		//Print or write to a file...
		std::cout << std::hex << tmp.data << std::endl;
	}

	return 0;
}