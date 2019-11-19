#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include "dvbt_energy_dispersal.h"

#include <unistd.h> 
#include <string.h> 
#include <sys/types.h> 
#include <sys/socket.h> 
#include <arpa/inet.h> 
#include <netinet/in.h> 

#define INPUT_SIZE (D_PSIZE * (D_NPACKS * D_NBLOCKS + 1))
#define OUTPUT_SIZE INPUT_SIZE
axis_uint8_t signal_in[INPUT_SIZE];
axis_uint8_t signal_out[OUTPUT_SIZE];

int forecast()
{
    return D_PSIZE * (D_NPACKS * D_NBLOCKS + 1);
}
  
#define PORT 5000 
  
int sockfd;
struct sockaddr_in servaddr; 

int init (void)
{ 
    // Creating socket file descriptor 
    if ((sockfd = socket(AF_INET, SOCK_DGRAM, 0)) < 0) { 
        perror("socket creation failed"); 
        exit(EXIT_FAILURE); 
    } 
  
    memset(&servaddr, 0, sizeof(servaddr)); 
      
    // Filling server information 
    servaddr.sin_family = AF_INET; 
    servaddr.sin_port = htons(PORT); 
    servaddr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
  
    return 0; 
} 

int main (void)
{
	const char *cmd = "ffmpeg -re -f lavfi -i testsrc=size=1280x720:rate=30 "
	"-preset ultrafast -vcodec libx264 -tune zerolatency -b:v 1200k -f mpegts -";    

    FILE *fp;
    if ((fp = popen(cmd, "r")) == NULL) {
        printf("Error opening pipe!\n");
        return -1;
    }

    init();

    printf("Input block size: %d\n", D_NPACKS * D_PSIZE * D_NBLOCKS);

    while (1)
    {
        for (int i = n_in; i < forecast(); i++) {
            signal_in[i].data = fgetc(fp);
            signal_in[i].user = (i == 0) ? USER_BLOCK_BEGIN : ((i == forecast()-1) ? USER_BLOCK_END : 0);
            signal_in[i].last = 0x00;
        }

        // Perform top function:
        printf("\nWORK\n");
        printf("forecast: %d\n", forecast());
        dvbt_energy_dispersal(signal_in, signal_out);
        printf("n_in: %d\n", n_in);
        printf("n_out: %d\n", n_out);

        // Check results...
        printf("\nOUT:\n");
        static uint8_t buffer[INPUT_SIZE];
        for (int i = 0; i < n_out; i++)
        {
            if (signal_out[i].user == USER_BLOCK_BEGIN)
                printf("\nBlock begin\n");

            printf("%02x ", (uint8_t)signal_out[i].data);

            if (signal_out[i].user == USER_BLOCK_END) {
                printf("\nBlock end\n");	
                break;
            }

            buffer[i] = (uint8_t)signal_out[i].data;

            //i++;
            if (i >= OUTPUT_SIZE) break;
        }
        int numbytes = sendto(sockfd, (const char*)buffer, n_out, 0, (const struct sockaddr*)&servaddr, sizeof(servaddr)); 
        n_out = 0;
        printf("numbytes: %d\n", numbytes);

        if (forecast() >= n_in) {
            memmove(signal_in, &signal_in[n_in], (forecast() - n_in)*sizeof(axis_uint8_t));
            n_in = forecast() - n_in;
        }
        else n_in = 0;
        signal_in[0].user = USER_BLOCK_BEGIN;
        printf("n_in -> %d\n", n_in);
    }

    pclose(fp);
    close(sockfd);

	return 0;
}