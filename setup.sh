#!/usr/bin/env bash
# example to run
# docker run -p 14005:22 -p 80:80 -p 1935:1935 -p 8080:8080 -p 8181:8181 -p 8282:8282 -p 8383:8383 --name rtmp -d rtmp:latest

# stage1
# A. build .deb
docker build -t rtmptemp --rm=true stage1

# stage2
# A. dump /opt to dist/opt
docker run --name rtmptemp -w /opt --rm=true rtmptemp tar cf - . | ( mkdir -p stage2/dist/opt; cd stage2/dist/opt; tar xf - )

# B. dump /etc/apt/sources.list.d/nginx-local.list
docker run --name rtmptemp --rm=true rtmptemp cat /etc/apt/sources.list.d/nginx-local.list > stage2/dist/nginx-local.list

# C. build rtmp image
docker build -t rtmp:latest --rm=true stage2

# D. delete dir stage2/dist and temp build image
rm -r stage2/dist/opt
rm stage2/dist/nginx-local.list

#docker rmi rtmptemp


