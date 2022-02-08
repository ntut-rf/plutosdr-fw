FROM ubuntu:20.04
RUN yes | apt-get update
RUN yes | apt-get install sudo
RUN useradd -g users -s /bin/bash -m user
RUN echo "user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
USER user
RUN mkdir /home/user/plutosdr-fw
WORKDIR /home/user/plutosdr-fw
RUN yes | sudo apt-get install git
RUN yes | sudo apt-get install build-essential
RUN yes | sudo apt-get install libncurses-dev
RUN yes | sudo apt-get install file
RUN yes | sudo apt-get install wget cpio unzip rsync bc
RUN yes | sudo apt-get install python3
RUN yes | sudo apt-get install libssl-dev
