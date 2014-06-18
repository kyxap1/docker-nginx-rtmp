# Use phusion/baseimage as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/baseimage-docker/blob/master/Changelog.md for
# a list of version numbers.
FROM phusion/baseimage:0.9.11

MAINTAINER Alexander Kyxap <kyxap@pro-manage.net>

EXPOSE 22 80 1935

# Set correct environment variables.
ENV HOME /root

# Regenerate SSH host keys. baseimage-docker does not contain any, so you
# have to do that yourself. You may also comment out this instruction; the
# init system will auto-generate one during boot.

# install minimal required packages
RUN sed "s#http://archive#http://ua.archive#g" -i /etc/apt/sources.list && \
apt-get update && apt-get install -qy wget git  

# execute build scenario
RUN git clone https://github.com/kyxap1/nginx-custom-module.git
RUN bash nginx-custom-module/compile.sh https://github.com/arut/nginx-rtmp-module.git ubuntu trusty
# Clean up APT when done. \
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

