#include <stdint.h>
#include <stdio.h>

#include "dvbt_inner_coder.h"

#define INPUT_SIZE 1200
uint8_t signal_in[INPUT_SIZE];
uint8_t signal_out[INPUT_SIZE];

// dvbt_configure conf(MOD_QPSK, NH, C1_2, C1_2);

int main()
{
    for (int i=0; i<INPUT_SIZE; i++) {
        signal_in[i] = i;
    }		
	
    work(INPUT_SIZE, signal_out, signal_in);

    for (int i=0; i<INPUT_SIZE; i++) {
        printf("%02x ", (uint8_t)signal_out[i]);
    }
    printf("done\n");
}