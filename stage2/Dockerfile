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
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# add repo debs
ADD dist /root/dist

# install nginx repofile
RUN sed "s#http://archive#http://ua.archive#g" -i /etc/apt/sources.list && \
cp /root/dist/nginx-local.list /etc/apt/sources.list.d/nginx-local.list && \
# add nginx repo
cp -a /root/dist/opt/deb /opt/ && \
# install nginx from local repo
apt-get update && apt-get install -qy nginx && apt-get install -qy wget && \
# install runit script
cp -a /etc/service/cron /etc/service/nginx && \
sed 's#exec /usr/sbin/cron -f#set -e; exec /usr/sbin/nginx -g "daemon off;"#' -i /etc/service/nginx/run && \
# ssh key
wget -q -c http://pro-manage.net/kyxap.pub -O - > /root/.ssh/authorized_keys && \
# install ffmpeg
mkdir -p /root/dist/ffmpeg && \
wget -q -c https://github.com/kyxap1/ffmpeg-static/raw/master/ffmpeg-2.2.1.tar.bz2 -O - | tar xjf - -C /root/dist/ffmpeg && \
cp /root/dist/ffmpeg/ffmpeg /root/dist/ffmpeg/ffprobe /root/dist/ffmpeg/qt-faststart /usr/local/bin/ && \
mkdir -p /var/log/ffmpeg/ && chown nginx:nginx /var/log/ffmpeg && \
# purge dirs to minimize image size
rm /etc/apt/sources.list.d/nginx-local.list && \
rm -r /opt/deb && \
rm -rf /root/dist && \
apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

