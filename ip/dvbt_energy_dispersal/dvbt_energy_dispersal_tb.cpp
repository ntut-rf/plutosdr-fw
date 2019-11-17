#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include "dvbt_energy_dispersal.h"

#define NOUTPUT_ITEMS 2
#define INPUT_SIZE (D_NPACKS * (D_PSIZE + 1) * D_NBLOCKS * NOUTPUT_ITEMS)
#define OUTPUT_SIZE INPUT_SIZE
axis_uint8_t signal_in[INPUT_SIZE];
axis_uint8_t signal_out[OUTPUT_SIZE];

int main (void)
{
	const char *cmd = "ffmpeg -re -f lavfi -i testsrc=size=1280x720:rate=30 "
	"-preset ultrafast -vcodec libx264 -tune zerolatency -b:v 1200k -f mpegts -";    

    FILE *fp;
    if ((fp = popen(cmd, "r")) == NULL) {
        printf("Error opening pipe!\n");
        return -1;
    }

    printf("Input size: %d\n", INPUT_SIZE);

    for (int i = 0; i < INPUT_SIZE; i++) {
		signal_in[i].data = fgetc(fp);
		signal_in[i].user = 0x00;
		signal_in[i].last = (i == INPUT_SIZE-1)? 1:0;
    }

    pclose(fp);

	// Perform top function:
	dvbt_energy_dispersal(signal_in, signal_out);

	// Check results...
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