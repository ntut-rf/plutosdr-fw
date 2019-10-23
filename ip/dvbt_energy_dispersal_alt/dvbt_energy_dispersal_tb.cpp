#include <stdio.h>

#include "axis_uint8_t.h"

// Number of output blocks to test
#define NOUTPUT_ITEMS 5

#include "dvbt_energy_dispersal_impl.h"

int prepare_test_data (axis_uint8_t* signal, size_t size)
{
    const char *cmd = "ffmpeg -re -f lavfi -i testsrc=size=1280x720:rate=30 "
	"-preset ultrafast -vcodec libx264 -tune zerolatency -b:v 1200k -f mpegts -";    

    FILE *fp;
    if ((fp = popen(cmd, "r")) == NULL) {
        printf("Error opening pipe!\n");
        return -1;
    }

    for (int i = 0; i < size; i++) {
		signal[i].data = fgetc(fp);
		signal[i].user = 0x00;
		signal[i].last = (i == INPUT_SIZE-1)? 1:0;
    }

    pclose(fp);
    return 0;
}

int main (void)
{
	// Perform top function:
	// dvbt_energy_dispersal(signal_in, signal_out);

	// // Check results...
	// for (int i=0; i<INPUT_SIZE; i++)
	// {
	// 	//printf("user: %x\n", signal_out[i].user);
	// 	printf("%02x ", (uint8_t)signal_out[i].data);
	// }

	return 0;
}