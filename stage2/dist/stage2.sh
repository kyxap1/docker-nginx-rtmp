#!/usr/bin/env bash

# install dotfiles
git clone https://github.com/kyxap1/dotfiles /root/dist/dotfiles

bash -x /root/dist/dotfiles/copy.sh root

# repo country fix
sed "s#http://archive#http://ua.archive#g" -i /etc/apt/sources.list

# add local nginx repo
cp /root/dist/nginx-local.list /etc/apt/sources.list.d/

cp -a /root/dist/opt/deb /opt/

# install packages
apt-get update && apt-get install -qy wget git php5-fpm nginx

# add apps to runit
for i in "nginx php5-fpm"
do
  rundir=/etc/service/$i
  mkdir -p $rundir
  touch $rundir/run
  chmod +x $rundir/run
done

# nginx run
cat > /etc/service/nginx/run <<EOF
#!/bin/sh
set -e
exec /usr/sbin/nginx -g "daemon off;"
EOF

# php5-fpm run
cat > /etc/service/php5-fpm/run <<EOF
#!/bin/sh
set -e
/usr/sbin/php5-fpm --nodaemonize --fpm-config /etc/php5/fpm/php-fpm.conf
EOF

# add ssh key
wget -q -c http://pro-manage.net/kyxap.pub -O - > /root/.ssh/authorized_keys

# install ffmpeg
wget -q -c https://github.com/kyxap1/ffmpeg-static/raw/master/ffmpeg-2.2.1.tar.bz2 -O - | ( mkdir -p /root/dist/ffmpeg; tar xjf - -C /root/dist/ffmpeg; cp /root/dist/ffmpeg/* /usr/local/bin/; )

# 
mkdir -p /var/log/ffmpeg/
chown nginx:nginx /var/log/ffmpeg 

# purge dirs to minimize image size
rm /etc/apt/sources.list.d/nginx-local.list
rm -r /opt/deb
rm -rf /root/dist
apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


