ENV TZ="Europe/Moscow" #Used each time we run container
ENV SSL_CERT="/devopenvas.pem" #Used each time we run container
ENV OPENVAS_ADMIN_PASSWORD="hello"  #Used only onecem during init phaze. Default user admin
ENV SPLUNK_EXCAHNGE_PASSWORD="hello" #Used each time we run container

Directory for splunk reports /mnt/splunk
-v /mnt/splunk:/splunk



Build example:
docker build . -t test:1.1

Run example:
docker run -v /mnt:/mnt -v /mnt/fromdocker/postgresql:/var/lib/postgresql -v /mnt/fromdocker/lib:/usr/local/var/lib -v /home/acr/AcroOpenVas/start.sh:/start.sh -v /mnt/splunk:/splunk --env SPLUNK_EXCAHNGE_PASSWORD="hello" -p 8443:443 test:1.1

#One more example
#everything inside docker container. We lost database and NVT each time we reboot
docker run -v /mnt:/mnt -v /mnt/splunk:/splunk --env ENV OPENVAS_ADMIN_PASSWORD="i71a3Ou8HZMntFg4EMpYqjpMVE44HWIx" --env SPLUNK_EXCAHNGE_PASSWORD="AUDMDOcYm9gRWlTcIAbQd73OTOI4D9BM" -p 8443:443 test:1.1
