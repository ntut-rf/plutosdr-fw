#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>             // Memory setting and copying
#include <errno.h>              // Error codes
#include <complex.h>
#include "libaxidma.h"

#define FFT_SIZE 2048

axidma_dev_t dev;
int output_channel = 0;
int input_channel = 1;
_Complex short* input;        
_Complex short* output;

void cleanup()
{
    if (input) axidma_free(dev, input, FFT_SIZE*sizeof(_Complex short));
    if (output) axidma_free(dev, output, FFT_SIZE*sizeof(_Complex short));
    axidma_destroy(dev);
}

int main(int argc, char **argv)
{
    // Initialize the AXIDMA device
    dev = axidma_init();
    if (dev == NULL) {
        fprintf(stderr, "Error: Failed to initialize the AXI DMA device.\n");
        cleanup();
        return -1;
    }

    // Allocate the input buffer
    input = axidma_malloc(dev, FFT_SIZE*sizeof(_Complex short));
    if (input == NULL) {
        fprintf(stderr, "Failed to allocate the input buffer.\n");
        cleanup();
        return -ENOMEM;
    }

    // Allocate the output buffer
    output = axidma_malloc(dev, FFT_SIZE*sizeof(_Complex short));
    if (output == NULL) {
        fprintf(stderr, "Failed to allocate the output buffer.\n");
        cleanup();
        return -ENOMEM;
    }

    for (int i = 0; i < FFT_SIZE; i++)
        input[i] = 1. + 0.i;

    // Perform the main transaction
    int rc = axidma_twoway_transfer(dev, 
        input_channel, input, FFT_SIZE*sizeof(_Complex short), NULL, 
        output_channel, output, FFT_SIZE*sizeof(_Complex short), NULL,
        true);
    if (rc < 0) {
        fprintf(stderr, "DMA read write transaction failed.\n");
        cleanup();
        return rc;
    }

    for (int i = 0; i < FFT_SIZE; i++)
        printf("%f%+fi\n", crealf(output[i]), cimagf(output[i]));

    cleanup();
    return 0;
}