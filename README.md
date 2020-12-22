https://hub.docker.com/repository/docker/kyyacribia/acroopnevas/general

ENV TZ="Europe/Moscow" #Used each time we run container
ENV SSL_CERT="/devopenvas.pem" #Used each time we run container
ENV OPENVAS_ADMIN_PASSWORD="hello"  #Used only onece during init phaze. Default user admin. 
ENV SPLUNK_EXCAHNGE_PASSWORD="hello" #Used each time we run container

Directory for splunk reports /mnt/splunk
-v /mnt/splunk:/splunk



Build:
#################################
# 1
docker build . -t acroopenvas:1.0
################################
# 2
# Run first time
docker run -v /mnt:/mnt --env TZ="Europe/Moscow" --env SPLUNK_EXCAHNGE_PASSWORD="5bfdEZbqxbVJYOYsiaESZDcY4XUnoIbD"  --env OPENVAS_ADMIN_PASSWORD="5c489WMPL53O7ypbQePB7DEmPqlOJt4V" -t acroopenvas:1.0
# Wait until updates and 
docker exec -it ID bash
# copy data to persitent volumes
mkdir /mnt/postgresql
mkdir /mnt/lib
cp -R /var/lib/postgresql/ /mnt/
cp -R /usr/local/var/lib/ /mnt/
chown 102 -R /mnt/postgresql

#3 Run stable
#Regualr run
docker run -v /mnt/postgresql:/var/lib/postgresql -v /mnt/lib:/usr/local/var/lib -v /mnt/splunk:/splunk --env SSL_CERT="/devopenvas.pem" --env TZ="Europe/Moscow" -p 5000:443 acroopenvas:1.0 &

####################################


OLD HELP


Run example:
#1 Regual run
docker run -v /mnt/fromdocker/postgresql:/var/lib/postgresql -v /mnt/fromdocker/lib:/usr/local/var/lib -v /mnt/splunk:/splunk --env SPLUNK_EXCAHNGE_PASSWORD="hello" -p 9443:443 test:1.1
or
docker run -v /mnt/postgresql:/var/lib/postgresql -v /mnt/lib:/usr/local/var/lib -v /mnt/splunk:/splunk --env SPLUNK_EXCAHNGE_PASSWORD="5bfdEZbqxbVJYOYsiaESZDcY4XUnoIbD" --env OPENVAS_ADMIN_PASSWORD="5c489WMPL53O7ypbQePB7DEmPqlOJt4V" -p 9443:443 test:1.1


#2 First time to save data from /var/lib/postgresql and /usr/local/var/lib
docker run -v /mnt:/mnt -p 8443:443 test:1.1
wait until docer will be ready
Then go inside docker and copy DB and NVTs
docker exec -it X bash

mkdir /mnt/postgresql
mkdir /mnt/lib
cp -R /var/lib/postgresql/ /mnt/postgresql/
cp -R /usr/local/var/lib/ /mnt/lib/
chown 102 -R /mnt/postgresql


#3 everything inside docker container. We lost database and NVT each time we reboot
docker run -v /mnt/splunk:/splunk --env OPENVAS_ADMIN_PASSWORD="i71a3Ou8HZMntFg4EMpYqjpMVE44HWIx" --env SPLUNK_EXCAHNGE_PASSWORD="AUDMDOcYm9gRWlTcIAbQd73OTOI4D9BM" -p 8443:443 test:1.1

