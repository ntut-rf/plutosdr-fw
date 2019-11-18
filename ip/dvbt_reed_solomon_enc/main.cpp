#include <stdio.h>

#include "dvbt_reed_solomon_enc_impl.h"

dvbt_reed_solomon_enc_impl rs_enc(2,8,285,255,239,8,51,8);

int main (void)
{
    unsigned char in[(239-51)*8] = {0};
    for (int i=0; i<sizeof(in); i++)
        in[i] = i;
    unsigned char out[(255-51)*8] = {0};

    for (int i=0; i<sizeof(in); i++)
        printf("%02x ", in[i]);
    printf("\n");
    
    rs_enc.general_work(in, out);
    
    for (int i=0; i<sizeof(out); i++)
        printf("%02x ", out[i]);
    printf("\n");

    printf("Done\n");
    return 0;
}