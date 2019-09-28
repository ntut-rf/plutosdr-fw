#include <stdio.h>

#include "dvbt_reed_solomon_enc_impl.h"

int main (void)
{
    gr::dtv::dvbt_reed_solomon_enc_impl rs_enc(2,8,285,255,239,8,51,8);
    rs_enc.general_work();
    printf("Hello!\n");
    return 0;
}