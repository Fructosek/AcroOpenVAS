#!/bin/sh
/init.sh
sleep 10

export LD_LIBRARY_PATH=/usr/local/lib
service postgresql start
/usr/bin/redis-server /etc/redis/redis-openvas.conf
ospd-openvas -u /var/run/ospd/ospd.sock
gvmd --unix-socket=/usr/local/var/run/gvmd.sock 
gsad --port=443 --no-redirect --ssl-private-key=/devopenvas.pem --ssl-certificate=/devopenvas.pem --verbose
tail -f /usr/local/var/log/gvm/gsad.log &
tail -f /usr/local/var/log/gvm/gvmd.log
