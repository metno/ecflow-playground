FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive


MAINTAINER  Espen Myrland "espenmyr@gmail.com"

RUN apt-get update    
RUN apt-get install -y apt-utils

RUN apt-get install -y libterm-readline-perl-perl
RUN apt-get install -y libterm-readline-gnu-perl

RUN apt-get install -y lsb-release
RUN apt-get install -y libssl-dev

RUN apt-get install -y qtbase5-dev
RUN apt-get install -y qttools5-dev-tools
RUN apt-get install -y libqt5svg5-dev
RUN apt-get install -y libqt5charts5-dev

RUN apt-get install -y libgl1-mesa-dev
RUN apt-get install -y libvulkan-dev
RUN apt-get install -y qt6-base-dev
RUN apt-get install -y qt6-base-dev-tools
RUN apt-get install -y libqt6svg6-dev
RUN apt-get install -y libqt6charts6-dev
RUN apt-get install -y libqt6core5compat6-dev
RUN apt-get install -y curl
RUN apt-get install -y bash
RUN apt-get install -y build-essential
#RUN apt-get install -y libpython2-dev
#RUN apt-get install -y libpython3-dev
RUN apt-get install -y python2-dev
RUN apt-get install -y python3-dev
RUN apt-get install -y python-is-python3

RUN  ln -s /usr/lib/x86_64-linux-gnu/libcrypt.so.1 /usr/lib64/libcrypt.so

RUN apt-get install -qqy telnet
ENV DISPLAY :0
    
# Thanks for build.sh Jan    
ADD build-ecflow.sh /root/build-ecflow.sh
RUN /root/build-ecflow.sh

