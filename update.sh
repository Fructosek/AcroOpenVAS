#!/bin/sh
greenbone-nvt-sync
greenbone-feed-sync --type GVMD_DATA
greenbone-feed-sync --type SCAP
greenbone-feed-sync --type CERT
sleep 24h
/update.sh &
exit
