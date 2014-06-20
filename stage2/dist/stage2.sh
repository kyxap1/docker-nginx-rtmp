#!/usr/bin/env bash

# repo country fix
sed "s#http://archive#http://ua.archive#g" -i /etc/apt/sources.list

# add local nginx repo
cp /root/dist/nginx-local.list /etc/apt/sources.list.d/

# add debian multimedia repo
# fill sources
DEBMULTIMEDIA_SOURCESLIST=/etc/apt/sources.list.d/deb-multimedia.list
[[ -f $DEBMULTIMEDIA_SOURCESLIST ]] || cat > $DEBMULTIMEDIA_SOURCESLIST <<EOF
# debian multimedia repository
deb http://www.deb-multimedia.org jessie main non-free
deb-src http://www.deb-multimedia.org jessie main non-free

EOF

# copy nginx deb's
cp -a /root/dist/opt/deb /opt/

# setup locale
cat >/etc/default/locale <<EOF
LANG="en_US.UTF-8"
LANGUAGE="en_US:en"
EOF

# install packages
apt-get update
apt-get install -qy --force-yes deb-multimedia-keyring
apt-get install -qy wget findutils git nginx ffmpeg libav-tools

# add apps to runit
for i in nginx php5-fpm
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
/usr/sbin/php5-fpm --nodaemonize --fpm-config /etc/php-fpm.conf
EOF

# install dotfiles
git clone https://github.com/kyxap1/dotfiles /root/dist/dotfiles
bash -x /root/dist/dotfiles/copy.sh root

# add ssh key
wget -q -c http://pro-manage.net/kyxap.pub -O - > /root/.ssh/authorized_keys

# install ffmpeg
# latest version from http://johnvansickle.com/ffmpeg/
#wget -q http://johnvansickle.com/ffmpeg/ -O - | grep -o -P "http://.*?builds/ffmpeg-git-[0-9]+-.*?\.bz2" | xargs -I{} wget -q -c "{}" -O - | ( mkdir -p /tmp/aaT2voo5biu4ua; tar xjf - -C /tmp/aaT2voo5biu4ua; find /tmp/aaT2voo5biu4ua -type f -mindepth 2 -maxdepth 2 | grep -v readme.txt | xargs -I{} mv {} /usr/local/bin/; rm -r /tmp/aaT2voo5biu4ua; )

# version from http://ffmpeg.gusari.org/static/64bit/
#wget -q -c http://ffmpeg.gusari.org/static/64bit/ffmpeg.static.64bit.latest.tar.gz -O - | ( tar xzf - -C /usr/local/bin; )
 
# fallback - https://github.com/kyxap1/ffmpeg-static/raw/master/ffmpeg-2.2.1.tar.bz2

# 
#mkdir -p /var/log/ffmpeg/
#chown nginx:nginx /var/log/ffmpeg 


