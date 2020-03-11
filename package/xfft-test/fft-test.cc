#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>             // Memory setting and copying
#include <errno.h>              // Error codes
#include <time.h>
#include <gnuradio/fft/fft.h>

#define FFT_SIZE 2048

gr::fft::fft_complex fft(FFT_SIZE, false);
gr_complex* input;        
gr_complex* output;

long diffts(struct timespec t1, struct timespec t2)
{
    return 1000000000l * (t2.tv_sec - t1.tv_sec) + 
        (t2.tv_nsec < t1.tv_nsec ? t1.tv_nsec + t2.tv_nsec : t2.tv_nsec - t1.tv_nsec);
}

int main(int argc, char **argv)
{
    input = fft.get_inbuf();
    output = fft.get_outbuf();

    for (int i = 0; i < FFT_SIZE; i++)
        input[i] = 0;

    input[1] = 10000;
        
    struct timespec starttime;
    struct timespec endtime;

    clock_gettime(CLOCK_MONOTONIC, &starttime);

    // Perform the main transaction
    fft.execute();

    clock_gettime(CLOCK_MONOTONIC, &endtime);

    for (int i = 0; i < FFT_SIZE; i++)
        printf("%f%+fi\n", output[i].real(), output[i].imag());

    fprintf(stderr, "Time elapsed: %d us\n", diffts(starttime, endtime)/1000);

    return 0;
}