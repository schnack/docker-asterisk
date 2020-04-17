FROM ubuntu:18.04

ARG     ASTERISK_VER=17.3.0

LABEL   maintainer="schnack.desu@gmail.com"
LABEL   version="${ASTERISK_VER}"
LABEL   description="https://wiki.asterisk.org/wiki/display/AST/Installing+Asterisk+From+Source"

ARG     DEBIAN_FRONTEND=noninteractive
RUN     apt update && \
        apt upgrade -y && \
        apt install -y wget && \
        cd /usr/local/src && \
        wget http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-${ASTERISK_VER}.tar.gz && \
        tar -zxvf asterisk-${ASTERISK_VER}.tar.gz && \
        cd /usr/local/src/asterisk-${ASTERISK_VER} && \
        ./contrib/scripts/install_prereq install && \
        ./contrib/scripts/install_prereq install-unpackaged && \
        ./configure && \
        make menuselect.makeopts && \
        # ====================================================
        # Asterisk modules
        # ----------------------------------------------------
        menuselect/menuselect \
            --disable BUILD_NATIVE \
            menuselect.makeopts && \
        #=====================================================
        make && \
        make install && \
        make samples && \
        make install-logrotate && \
        ldconfig && \
        apt-get -y autoremove && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/* /usr/src/*


EXPOSE  5060 5061

VOLUME  /var/lib/asterisk  /var/spool/asterisk

CMD     ["asterisk", "-f"]