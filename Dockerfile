#
# Minimum Docker image to build Android AOSP
#
FROM ubuntu:14.04
MAINTAINER jim_lin <jim_lin@quantatw.com> 

RUN adduser --quiet --gecos "" jim
# Set password for the jenkins user (you may want to alter this).
RUN echo "jim:password" | chpasswd
RUN mkdir /home/jim/.ssh -p
ADD apt.conf /etc/apt/
ADD .ssh/ /home/jim/.ssh
ADD gitconfig /home/jim/.gitconfig

RUN echo "export USE_CCACHE=1" >> /home/jim/.bashrc
RUN echo "export CCACHE_DIR=/tmp/ccache" >> /home/jim/.bashrc
RUN mkdir /home/jim/workspace
RUN chown -R jim:jim /home/jim/workspace
RUN chown -R jim:jim /home/jim/.ssh 
RUN chown -R jim:jim /home/jim/.gitconfig 
# Keep the dependency list as short as reasonable
RUN apt-get update && \
    apt-get install -y bc bison bsdmainutils build-essential curl \
        flex g++-multilib gcc-multilib git gnupg gperf lib32ncurses5-dev \
        lib32readline-gplv2-dev lib32z1-dev libesd0-dev libncurses5-dev \
        libsdl1.2-dev libwxgtk2.8-dev libxml2-utils lzop mingw32 tofrodos\
        pngcrush schedtool xsltproc zip zlib1g-dev openjdk-7-jdk python-lxml && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD https://storage.googleapis.com/git-repo-downloads/repo /usr/local/bin/
RUN chmod 755 /usr/local/bin/*

# Improve rebuild performance by enabling compiler cache
ENV USE_CCACHE 1
ENV CCACHE_DIR /tmp/ccache
ENV http_proxy="http://10.241.104.240:5678/"
ENV https_proxy="http://10.241.104.240:5678/"

