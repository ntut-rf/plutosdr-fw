#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include "dvbt_energy_dispersal.h"

#define NOUTPUT_ITEMS 5
#define INPUT_SIZE (D_NPACKS * (D_PSIZE + 1) * D_NBLOCKS * NOUTPUT_ITEMS)
#define OUTPUT_SIZE INPUT_SIZE
axis_uint8_t signal_in[INPUT_SIZE];
axis_uint8_t signal_out[OUTPUT_SIZE];

int forecast()
{
    return (D_NPACKS * (D_PSIZE + 1) * D_NBLOCKS);
}

int main (void)
{
	const char *cmd = "ffmpeg -re -f lavfi -i testsrc=size=1280x720:rate=30 "
	"-preset ultrafast -vcodec libx264 -tune zerolatency -b:v 1200k -f mpegts -";    

    FILE *fp;
    if ((fp = popen(cmd, "r")) == NULL) {
        printf("Error opening pipe!\n");
        return -1;
    }

    printf("Input block size: %d\n", D_NPACKS * D_PSIZE * D_NBLOCKS);
    //printf("Input size: %d\n", INPUT_SIZE);

    while (1)
    {
        //printf("\nIN\n");
        for (int i = 0; i < forecast(); i++) {
            signal_in[i].data = fgetc(fp);
            signal_in[i].user = (i == 0) ? USER_BLOCK_BEGIN : ((i == forecast()-1) ? USER_BLOCK_END : 0);
            signal_in[i].last = 0x00;
            //printf("%02x ", (uint8_t)signal_in[i].data);
        }

        // Perform top function:
        printf("\nWORK\n");
        dvbt_energy_dispersal(signal_in, signal_out);

        // Check results...
        printf("\nOUT:\n");
        //int i = 0;
        for (int i = 0; i < OUTPUT_SIZE; i++)
        {
            if (signal_out[i].user == USER_BLOCK_BEGIN)
                printf("\nBlock begin\n");

            printf("%02x ", (uint8_t)signal_out[i].data);

            if (signal_out[i].user == USER_BLOCK_END) {
                printf("\nBlock end\n");	
                break;
            }

            //i++;
            if (i >= OUTPUT_SIZE) break;
        }
    }

    pclose(fp);

	return 0;
}