Build example:
docker build . -t test:1.1

Run example:
docker run -v /mnt:/mnt -v /mnt/fromdocker/postgresql:/var/lib/postgresql -v /mnt/fromdocker/lib:/usr/local/var/lib -v /home/acr/AcroOpenVas/start.sh:/start.sh -v /mnt/splunk:/splunk --env SPLUNK_EXCAHNGE_PASSWORD="hello" -p 8443:443 test:1.1
