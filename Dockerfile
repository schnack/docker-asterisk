FROM ubuntu:18.04

ARG     version=17.3.0
ARG 	modules="--disable BUILD_NATIVE"

LABEL   maintainer="schnack.desu@gmail.com"
LABEL   version="${version}"
LABEL   description="https://wiki.asterisk.org/wiki/display/AST/Installing+Asterisk+From+Source"

ARG     DEBIAN_FRONTEND=noninteractive
RUN     apt update && \
        apt upgrade -y && \
        apt install -y wget && \
        cd /usr/local/src && \
        wget http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-${version}.tar.gz && \
        tar -zxvf asterisk-${version}.tar.gz && \
        cd /usr/local/src/asterisk-${version} && \
        ./contrib/scripts/install_prereq install && \
        ./contrib/scripts/install_prereq install-unpackaged && \
        ./configure && \
        make menuselect.makeopts && \
        menuselect/menuselect ${modules} menuselect.makeopts && \
        menuselect/menuselect --list-options > /module.list && \
        make && \
        make install && \
        make samples && \
        make install-logrotate && \
        ldconfig && \
        apt-get -y autoremove && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/* /usr/src/*


EXPOSE  5060/udp
EXPOSE  5061/udp

VOLUME  /var/lib/asterisk  /var/spool/asterisk

CMD     ["asterisk", "-f"]