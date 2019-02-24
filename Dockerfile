FROM phusion/baseimage:0.11
MAINTAINER banyan.cheung@gmail.com

RUN echo /home/worker > /etc/container_environment/HOME
ENV SRC_DIR /home/worker/src
RUN mkdir -p ${SRC_DIR}

ADD build /build

RUN /build/prepare.sh
RUN /build/php.sh
RUN /build/nginx.sh
RUN /build/finish.sh

# add CONFIG
ADD config /home/worker/

# start up
RUN mkdir -p /etc/my_init.d

WORKDIR /home/worker/data/www

CMD ["/sbin/my_init"]