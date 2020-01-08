#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <iostream>
//#include "dvbt_convolutional_interleaver.h"

#define INPUT_SIZE 120000
uint8_t signal_in[INPUT_SIZE];
uint8_t signal_out[INPUT_SIZE];

// Number of shift registers
static const int d_I = 12;
// Depth of shift registers
static const int d_M = 12;

// shift registers
static uint8_t d_shift[d_I][d_M * d_I + 1] = {0};
// length of shift register i
static int len(int i) { return d_M * i; }
// index of shift register i
static int idx[d_I] = {0};

void dvbt_convolutional_interleaver (uint8_t* in, uint8_t* out, int noutput_items)
{
    for (int i = 0; i < (noutput_items / d_I); i++) {
        for (int j = 0; j < d_I; j++) {
            //printf("idx[i]: %d \n", idx[i]);
            if (len(j) == 0) out[(d_I * i) + j] = in[(d_I * i) + j];
            else {
                out[(d_I * i) + j] = d_shift[j][idx[j]];
                d_shift[j][idx[j]] = in[(d_I * i) + j];
                idx[j] = (idx[j]+1) % len(j);
            }
            printf("i, idx[i]: %d %d %d\n", j, idx[j], len(j));
        }
    }
}

int main (void)
{
    for (int i = 0; i < INPUT_SIZE; i++) {
		//signal_in[i].data = fgetc(fp);
		//signal_in[i].user = 0x00;
		//signal_in[i].last = (i == INPUT_SIZE-1)? 1:0;
        signal_in[i] = i;
    }

    for (int i=0; i<INPUT_SIZE; i++)
	{
		//printf("user: %x\n", signal_out[i].user);
		printf("%02x ", (uint8_t)signal_in[i]);
	}

	// Perform top function:
    //for (int i = 0; i < INPUT_SIZE/12; i++)
	dvbt_convolutional_interleaver(signal_in, signal_out, INPUT_SIZE);

	// Check results...
	for (int i=0; i<INPUT_SIZE; i++)
	{
		//printf("user: %x\n", signal_out[i].user);
		printf("%02x ", (uint8_t)signal_out[i]);
	}

	return 0;
}