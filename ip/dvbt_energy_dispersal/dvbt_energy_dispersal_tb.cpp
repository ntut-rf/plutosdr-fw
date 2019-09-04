#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include "dvbt_energy_dispersal.h"

#define INPUT_SIZE 18800
axis_uint8_t signal_in[INPUT_SIZE];
axis_uint8_t signal_out[INPUT_SIZE];

int parse_output(void)
{
    const char *cmd = "ffmpeg -re -f lavfi -i testsrc=size=1280x720:rate=30 "
	"-preset ultrafast -vcodec libx264 -tune zerolatency -b:v 1200k -f mpegts -";    

    FILE *fp;

    if ((fp = popen(cmd, "r")) == NULL) {
        printf("Error opening pipe!\n");
        return -1;
    }

    for (int i = 0; i < INPUT_SIZE; i++) {
        // printf("%02x ", fgetc(fp));
		signal_in[i].data = fgetc(fp);
		signal_in[i].user = 0x00;
		signal_in[i].last = (i == INPUT_SIZE-1)? 1:0;
    }

    if (pclose(fp)) {
        printf("Command not found or exited with error status\n");
        return -1;
    }

    return 0;
}

int main (void)
{
	parse_output();

	// for (int i=0; i<INPUT_SIZE; i++)
	// {
	// 	signal_in[i].data = i;
	// 	signal_in[i].user = 0x00;
	// 	signal_in[i].last = (i == INPUT_SIZE-1)? 1:0;
	// }

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