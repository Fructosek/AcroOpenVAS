#!/bin/sh

if [ -z $TZ ]; then
  TZ="Europe/Moscow"
fi

echo TZ $TZ
echo $TZ > /etc/timezone
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime
date

export LD_LIBRARY_PATH=/usr/local/lib

service postgresql start
status=`service postgresql status | grep online`
echo Postgresql service status: $status
if [ -z "$status" ]; then
   echo "Error! Can't start Postgresql server. We can't work."
   exit;
fi


/usr/bin/redis-server /etc/redis/redis-openvas.conf
sleep 1

if [ -f "/var/run/ospd.pid" ]; then
	rm /var/run/ospd.pid
fi
ospd-openvas -u /var/run/ospd/ospd.sock --log-file=/usr/local/var/log/gvm/ospd.log

################# Init ##########################
echo "Checking if admin user exists in GVMD database..."
UID=`gvmd --get-users --verbose | grep admin | awk '{print $2}'`
echo admin UID: $UID
if [ -z "$UID" ]; then
        echo First boot??? Not found Admin. Strarting database initialisation...
	/init.sh
       echo Initialisation has finished.
fi
#################################################

if [ $OPENVAS_ADMIN_PASSWORD ]; then
  echo Changing admin GUI password from docker CLI
  gvmd --user=admin --new-password="$OPENVAS_ADMIN_PASSWORD"
  echo Done.
fi

gvmd --unix-socket=/usr/local/var/run/gvmd.sock

#Fix reporting problem
chmod 755 -R /usr/local/var/lib/gvm/gvmd/report_formats

if [ -z $SSL_CERT ]; then
  SSL_CERT="/devopenvas.pem"
fi

echo Starting GUI...
gsad --port=443 --no-redirect --ssl-private-key=$SSL_CERT --ssl-certificate=$SSL_CERT --verbose

echo Starting SSH Server...

if [ $SPLUNK_EXCAHNGE_PASSWORD ]; then
	echo "Changing splunk user password..."
	echo "splunk:$SPLUNK_EXCAHNGE_PASSWORD" | chpasswd
	echo Done
fi
chown splunk /splunk
/usr/sbin/sshd -E /var/log/ssh.log

echo "########################################################################"
echo "#                                                                      #"
echo "#                         Ready to work                                #"
echo "#                                                                      #"
echo "########################################################################"

/update.sh &

tail -f /var/log/ssh.log &
tail -f /usr/local/var/log/gvm/gsad.log &
tail -f /usr/local/var/log/gvm/ospd.log &
tail -f /usr/local/var/log/gvm/gvmd.log
