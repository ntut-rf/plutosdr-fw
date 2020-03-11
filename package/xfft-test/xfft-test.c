#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>             // Memory setting and copying
#include <errno.h>              // Error codes
#include <complex.h>
#include <time.h>
#include "libaxidma.h"

#define FFT_SIZE 2048

axidma_dev_t dev;
int output_channel = 1;
int input_channel = 0;
complex short* input;        
complex short* output;

long diffts(struct timespec t1, struct timespec t2)
{
    return 1000000000l * (t2.tv_sec - t1.tv_sec) + 
        (t2.tv_nsec < t1.tv_nsec ? t1.tv_nsec + t2.tv_nsec : t2.tv_nsec - t1.tv_nsec);
}

void cleanup()
{
    if (input) axidma_free(dev, input, FFT_SIZE*sizeof(complex short));
    if (output) axidma_free(dev, output, FFT_SIZE*sizeof(complex short));
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
    input = axidma_malloc(dev, FFT_SIZE*sizeof(complex short));
    if (input == NULL) {
        fprintf(stderr, "Failed to allocate the input buffer.\n");
        cleanup();
        return -ENOMEM;
    }

    // Allocate the output buffer
    output = axidma_malloc(dev, FFT_SIZE*sizeof(complex short));
    if (output == NULL) {
        fprintf(stderr, "Failed to allocate the output buffer.\n");
        cleanup();
        return -ENOMEM;
    }

    for (int i = 0; i < FFT_SIZE; i++)
        input[i] = 0;

    input[1] = 10000;
        
    struct timespec starttime;
    struct timespec endtime;

    clock_gettime(CLOCK_MONOTONIC, &starttime);

    // Perform the main transaction
    int rc = axidma_twoway_transfer(dev, 
        input_channel, input, FFT_SIZE*sizeof(complex short), NULL, 
        output_channel, output, FFT_SIZE*sizeof(complex short), NULL,
        true);

    clock_gettime(CLOCK_MONOTONIC, &endtime);

    if (rc < 0) {
        fprintf(stderr, "DMA read write transaction failed.\n");
        cleanup();
        return rc;
    }

    for (int i = 0; i < FFT_SIZE; i++)
        printf("%f%+fi\n", crealf(output[i]), cimagf(output[i]));

    fprintf(stderr, "Time elapsed: %d us\n", diffts(starttime, endtime)/1000);

    cleanup();
    return 0;
}