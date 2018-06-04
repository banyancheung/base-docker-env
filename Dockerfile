# Use phusion/baseimage as base image. make sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/baseimage-docker/blob/master/Changelog.md for
# a list of version numbers.

FROM phusion/baseimage:0.10.1
MAINTAINER banyan.cheung@gmail.com

RUN echo /home/worker > /etc/container_environment/HOME
ENV SRC_DIR /home/worker/src
RUN mkdir -p ${SRC_DIR}

ADD build /build

RUN /build/install.sh

# add CONFIG
ADD config /home/worker/

# start up
RUN mkdir -p /etc/my_init.d

CMD ["/sbin/my_init"]