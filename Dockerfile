FROM debian:buster

MAINTAINER Konstantin Yanson Acribia <kyy@acribia.ru>

RUN apt-get -y update
RUN apt-get install -y \
	cmake \
	pkg-config \
	libglib2.0-dev \
	libgpgme-dev \
	libgnutls28-dev \
	uuid-dev \
	libssh-gcrypt-dev \
	libldap2-dev \
	libhiredis-dev \
	libxml2-dev \
	libradcli-dev \
	libpcap-dev \
	nmap \
	libgcrypt20-dev

RUN apt-get install -y git

WORKDIR /opt
RUN git clone -b stable https://github.com/greenbone/gvm-libs.git ./gvm-libs
WORKDIR /opt/gvm-libs
RUN cmake . && make install
WORKDIR /opt
RUN rm -R /opt/gvm-libs

RUN apt install -y graphviz doxygen bison libksba-dev
RUN git clone -b stable https://github.com/greenbone/openvas.git ./openvas
WORKDIR /opt/openvas
RUN cmake . && make install

RUN apt-get install -y redis-server

WORKDIR /opt


RUN cp /opt/openvas/config/redis-openvas.conf /etc/redis/redis-openvas.conf && \
	chown redis:redis /etc/redis/redis-openvas.conf  && \ 
	echo "db_address = /run/redis-openvas/redis.sock" > /usr/local/etc/openvas/openvas.conf

RUN rm -R /opt/openvas

RUN apt-get install -y gcc cmake libglib2.0-dev libgnutls28-dev libpq-dev postgresql-server-dev-11 pkg-config libical-dev xsltproc
RUN apt-get install -y xmltoman
RUN apt-get install -y libxml++

WORKDIR /opt

RUN git clone -b stable https://github.com/greenbone/gvmd.git ./gvmd
WORKDIR /opt/gvmd
RUN cmake . && make install

RUN apt-get -y install python3-defusedxml python3-lxml python3-paramiko python3-pip python3-setuptools

WORKDIR /opt
RUN rm -R /opt/gvmd

RUN git clone -b stable  https://github.com/greenbone/ospd.git  ./ospd
WORKDIR /opt/ospd
RUN python3 setup.py install

WORKDIR /opt
RUN rm -R /opt/ospd

RUN git clone -b stable https://github.com/greenbone/ospd-openvas.git ./ospd-openvas
WORKDIR /opt/ospd-openvas
RUN python3 setup.py install

WORKDIR /opt
RUN rm -R /opt/ospd-openvas


RUN apt-get -y install curl && \
	curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
	echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
	apt-get -y update && \
	apt-get -y install yarn

RUN apt-get -y install libmicrohttpd-dev

RUN git clone -b stable https://github.com/greenbone/gsa.git ./gsa

WORKDIR /opt/gsa



RUN cmake . && make install 

WORKDIR /opt

RUN rm -R /opt/gsa


### Remove what we dont need
RUN apt -y remove git
RUN apt -y remove wget

RUN apt install -y xml-twig-tools
RUN apt install -y rsync
RUN apt install -y python3-pyparsing

RUN apt-get -y install -y postgresql postgresql-server-dev-all

RUN mkdir /var/run/ospd
RUN mkdir /run/redis-openvas

RUN ldconfig

RUN apt-get install -y sudo

#EXPOSE 8443


COPY ./start.sh /start.sh
COPY ./init.sh /init.sh
COPY ./devopenvas.pem /devopenvas.pem
COPY ./gvmd.sql /gvmd.sql
COPY ./greenbone-nvt-sync /usr/local/bin/greenbone-nvt-sync
COPY ./update.sh /update.sh

#WORKDIR /usr/local/var/lib
#COPY ./lib ./

WORKDIR /

#Delete all sensor dependant files to cut image
#For Acribia only!
#RUN rm -R /usr/local/var/lib/*
#RUN rm -R /var/lib/postgresql/*
RUN greenbone-nvt-sync
RUN greenbone-feed-sync --type GVMD_DATA
RUN greenbone-feed-sync --type SCAP
RUN greenbone-feed-sync --type CERT

####

ENV TZ="Europe/Moscow"
ENV SSL_CERT="/devopenvas.pem"
ENV OPENVAS_ADMIN_PASSWORD="initpassword"
ENV SPLUNK_EXCAHNGE_PASSWORD="initpassword"


RUN apt-get install -y openssh-server
RUN mkdir /run/sshd
RUN mkdir /splunk
COPY ./sshd_config /etc/ssh/sshd_config 
#Dont ask fingerprint when report generated
RUN echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config
RUN echo "StrictHostKeyChecking accept-new" >> /etc/ssh/ssh_config

RUN useradd -p 'openssl passwd -1 initpassword' splunk
RUN mkdir /home/splunk
RUN chown splunk /home/splunk
RUN chown splunk /splunk

RUN apt install -y sshpass
RUN apt install -y socat

RUN apt install -y nmap

CMD [ "/start.sh"]






