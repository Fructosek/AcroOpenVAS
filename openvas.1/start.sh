#!/bin/sh
echo TZ $TZ
echo $TZ > /etc/timezone
ln -snf /usr/share/zoneinfo/$TZ /etc/localtim
date

export LD_LIBRARY_PATH=/usr/local/lib
service postgresql start
status=`service postgresql status | grep online`
echo Postgresql service status: $status
if [ -z "$status" ]; then
   echo "Error! Can't start Postgresql server. We can't stand it!"
   exit;
fi

/usr/bin/redis-server /etc/redis/redis-openvas.conf
sleep 5

if [ -f "/var/run/ospd.pid" ]; then
	rm /var/run/ospd.pid
fi
ospd-openvas -u /var/run/ospd/ospd.sock --log-file=/usr/local/var/log/gvm/ospd.log

UID=`gvmd --get-users --verbose | grep admin | awk '{print $2}'`
echo admin UID: $UID
if [ -z "$UID" ]; then
        echo Not found Admin. Strarting database initialisation
	/init.sh
fi
sleep 5

gvmd --unix-socket=/usr/local/var/run/gvmd.sock

gsad --port=443 --no-redirect --ssl-private-key=/devopenvas.pem --ssl-certificate=/devopenvas.pem --verbose

tail -f /usr/local/var/log/gvm/gsad.log &
tail -f /usr/local/var/log/gvm/ospd.log &
tail -f /usr/local/var/log/gvm/gvmd.log
