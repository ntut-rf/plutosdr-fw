#include <stdio.h>

// Number of output blocks to test
#define NOUTPUT_ITEMS 5

#include "dvbt_energy_dispersal_impl.h"

gr::dtv::dvbt_energy_dispersal_impl impl(1);

int input_signature = impl.input_signature()->sizeof_stream_item(0);
int output_signature = impl.output_signature()->sizeof_stream_item(0);

int noutput_items = NOUTPUT_ITEMS;
gr_vector_int ninput_items = {0};

int prepare_test_data (unsigned char* buffer, size_t size)
{
    const char *cmd = "ffmpeg -re -f lavfi -i testsrc=size=1280x720:rate=30 "
	"-preset ultrafast -vcodec libx264 -tune zerolatency -b:v 1200k -f mpegts -";    

    FILE *fp;
    if ((fp = popen(cmd, "r")) == NULL) {
        printf("Error opening pipe!\n");
        return -1;
    }

    for (int i = 0; i < size; i++) {
        buffer[i] = fgetc(fp);
		// signal[i].data = fgetc(fp);
		// signal[i].user = 0x00;
		// signal[i].last = (i == INPUT_SIZE-1)? 1:0;
    }

    pclose(fp);
    return 0;
}

int main (void)
{
    // Print I/O signature
    printf("input signature: %d\n", input_signature);
    printf("output signature: %d\n", output_signature);

    // Forecast number of input items required
    impl.forecast(noutput_items, ninput_items);
    printf("number of input items: %d\n", ninput_items[0]);
    printf("number of output items: %d\n", noutput_items);

    // Allocate I/O buffer
    unsigned char in[input_signature*ninput_items[0]] = {0};
    unsigned char out[output_signature*noutput_items] = {0};
    gr_vector_const_void_star   input_items     {in};
    gr_vector_void_star         output_items    {out};

    // Prepare test data
    prepare_test_data(in, input_signature*ninput_items[0]);
    
    // Actual work
    impl.general_work(noutput_items, ninput_items, input_items, output_items);
    
    // Print processed data
    // for (int i=0; i<output_signature*noutput_items; i++)
    //     printf("%02x ", out[i]);
    // printf("\n");

    printf("Done\n");
    return 0;
}