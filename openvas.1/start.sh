#!/bin/sh

export LD_LIBRARY_PATH=/usr/local/lib
service postgresql start
sleep 5
/usr/bin/redis-server /etc/redis/redis-openvas.conf

rm /var/run/ospd.pid
ospd-openvas -u /var/run/ospd/ospd.sock --log-file=/usr/local/var/log/gvm/ospd.log

/init.sh
sleep 5

gvmd --unix-socket=/usr/local/var/run/gvmd.sock  

gsad --port=443 --no-redirect --ssl-private-key=/devopenvas.pem --ssl-certificate=/devopenvas.pem --verbose

tail -f /usr/local/var/log/gvm/gsad.log &
tail -f /usr/local/var/log/gvm/ospd.log &
tail -f /usr/local/var/log/gvm/gvmd.log
