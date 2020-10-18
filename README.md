# GVM 20.08 OpenVAS in Docker container

!!! It is no ready yet. !!!

This branch builds docker file for GVM 20.08 (current stable) and include:
        
-  GVM Libraries (gvm-libs-20.08)
-  OpenVAS (openvas-20.08)
-  Greenbone Vulnerability Manager (gvmd-20.08)
-  OSPd (ospd-openvas-20.08)
-  Greenbone Security Assistant (gsa-20.08)

Run docker-comose up and sit back and leax for couple hours.\
It takes a lot of time to compile, download updates and rebuild database.\
Especially downloading. \
\
If you don't want to loose data evry tile comtainer reload it is good idea to setup volumes inside docker-compose.yml file:\
        - "./nvt:/usr/local/var/lib"\
        - "./db:/var/lib/postgresql"\
or 


As well you can setup environment variables:\
        TZ: "Europe/Moscow"  \
        OPENVAS_ADMIN_PASSWORD: "hello" (Password set up during first load only! Afterwards it cand be changed through GUI)\
 

