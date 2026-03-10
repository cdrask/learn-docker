FROM ubuntu:24.04 AS base

# Install packages: update filenames if necessary
ARG AC6=ARMCompiler6.24_standalone_linux-x86_64.tar.gz
ARG ARCH=x86_64

ENV USER=ubuntu

# Update docker image OS
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get update
RUN apt-get install -y --no-install-recommends apt-utils
RUN apt-get -y upgrade

# Install necessary dependencies
RUN apt-get install -y nano sudo ca-certificates git make cmake libx11-dev libxext6 libsm6 libxcursor1 libxft2 libxrandr2 libxt6 libxinerama1 libz-dev xterm telnet dos2unix

# Setup default user
RUN if ! id -u $USER >/dev/null 2>&1; then useradd --create-home -s /bin/bash -m $USER && echo "$USER:$USER" | chpasswd && adduser $USER sudo; fi
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

WORKDIR /home/$USER
USER ubuntu

# Install Arm Compiler 6
COPY $AC6 /home/$USER
RUN mkdir /home/$USER/tmp
RUN tar xvfz $AC6 -C /home/$USER/tmp
RUN /home/$USER/tmp/install_$ARCH.sh --i-agree-to-the-contained-eula --no-interactive -d /home/$USER/AC6
RUN rm -rf /home/$USER/tmp
RUN rm $AC6
ENV PATH="/home/$USER/AC6/bin:$PATH"

# Activate license
RUN armlm activate -product 'KEMDK-COM0' -server 'https://mdk-preview.keil.arm.com'
