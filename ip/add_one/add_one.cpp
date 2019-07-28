#include <stdio.h>
#include <ap_axi_sdata.h>
#include <hls_stream.h>

typedef ap_axiu<8,1,1,1> data_element;

void add_one (hls::stream<data_element> &A, hls::stream<data_element> &B)
{
#pragma HLS INTERFACE axis port=A
#pragma HLS INTERFACE axis port=B

    while (1)
    {
		data_element d = A.read();
		d.data += 1;
		B.write(d);
		if (d.last) break;
	}
}
