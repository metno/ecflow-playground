FROM ubuntu:18.04
MAINTAINER  Espen Myrland "espenmyr@gmail.com"

RUN apt-get update
RUN apt-get install -y apt-utils
RUN apt-get install -y libterm-readline-perl-perl
RUN apt-get install -y libterm-readline-gnu-perl
#RUN apt-get install -y dialog

RUN apt-get install -y lsb-release
RUN apt-get install -y libssl-dev
RUN apt-get install -y qtbase5-dev
RUN apt-get install -y qttools5-dev-tools
RUN apt-get install -y libqt5svg5-dev
RUN apt-get install -y libqt5charts5-dev
    
RUN apt-get install -y curl
RUN apt-get install -y build-essential
RUN apt-get install -y python-dev
RUN apt-get install -y python3-dev


# Thanks for build 
#ADD build-ecflow.sh /root/build-ecflow.sh
#RUN /root/build-ecflow.sh


# Or: 
# Overridable 
#CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
# Not overridable (well without "forcing")
#ENTRYPOINT ["/usr/sbin/nginx", "-g", "daemon off;"]

#EXPOSE 80
