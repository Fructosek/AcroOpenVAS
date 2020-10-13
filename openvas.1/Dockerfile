FROM debian:buster

MAINTAINER Konstantin Yanson Acribia <kyy@acribia.ru>

RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y install build-essential gcc pkg-config libssh-gcrypt-dev libgnutls28-dev
RUN apt-get -y install libglib2.0-dev libpcap-dev libgpgme-dev bison libksba-dev libsnmp-dev
RUN apt-get -y install libgcrypt20-dev cmake
RUN apt-get -y install redis-server 
RUN apt-get -y install libxml++ rsync nodejs git
RUN apt-get -y install libhiredis-dev libxml++
RUN apt-get -y install libical-dev 
RUN apt-get -y install libpq-dev
RUN apt-get -y install libglib2.0-dev libgnutls28-dev libpq-dev postgresql-server-dev-11 pkg-config libical-dev xsltproc 
RUN apt-get -y install libmicrohttpd-dev libxml2-dev
RUN apt-get -y install doxygen
RUN apt-get -y install libhiredis-dev
### Postgresql
RUN apt-get -y install postgresql postgresql-contrib postgresql-server-dev-all
###
RUN apt-get -y install xml-twig-tools
RUN apt-get -y install xsltproc
RUN apt-get -y install nmap
RUN apt-get -y install psutils
RUN apt-get -y  install python3-defusedxml python3-lxml python3-paramiko python3-pip python3-setuptools

RUN apt-get -y install curl
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get -y update 
RUN apt-get -y install yarn

### Extra packages:
RUN apt-get -y install sudo
RUN apt-get -y install nano mc
RUN apt-get -y install xmltoman
RUN apt-get -y install texlive-latex-extra --no-install-recommends
RUN apt-get -y install texlive-fonts-recommended
RUN apt-get -y install sshpass snmp socat
RUN apt-get -y install smbclient
################################

WORKDIR /opt
RUN git clone -b  gvm-libs-20.08 https://github.com/greenbone/gvm-libs.git ./gvm-libs
RUN git clone -b openvas-20.08 https://github.com/greenbone/openvas.git ./openvas
RUN git clone -b gvmd-20.08 https://github.com/greenbone/gvmd.git ./gvmd
RUN git clone -b ospd-openvas-20.08 https://github.com/greenbone/ospd-openvas.git ./ospd-openvas
RUN git clone -b ospd-20.08  https://github.com/greenbone/ospd.git  ./ospd-20.08
RUN git clone -b gsa-20.08 https://github.com/greenbone/gsa.git ./gsa


WORKDIR /opt/gvm-libs
RUN cmake .
RUN make install

WORKDIR /opt/openvas
RUN cmake .
RUN make install

#Redis
RUN cp ./config/redis-openvas.conf /etc/redis/redis-openvas.conf
RUN chown redis:redis /etc/redis/redis-openvas.conf
RUN echo "db_address = /run/redis-openvas/redis.sock" > /usr/local/etc/openvas/openvas.conf 
RUN mkdir /run/redis-openvas

WORKDIR /opt/gvmd
RUN cmake .
RUN make install


RUN apt-get -y install python3-defusedxml python3-lxml python3-paramiko python3-pip python3-setuptools
WORKDIR /opt/ospd-openvas
RUN python3 setup.py install

WORKDIR /opt/ospd-20.08
RUN python3 setup.py install

WORKDIR /opt/gsa
RUN cmake .
RUN make install

WORKDIR /

EXPOSE 443

COPY ./start.sh /start.sh
COPY ./init.sh /init.sh

CMD [ "/start.sh"]
