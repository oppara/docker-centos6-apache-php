FROM centos:6.8

LABEL maintainer oppara

RUN cp -p /usr/share/zoneinfo/Japan /etc/localtime \
    && echo 'ZONE="Asia/Tokyo"' > /etc/sysconfig/clock \
    && echo 'UTC="false"' >> /etc/sysconfig/clock  \
    && source /etc/sysconfig/clock \
    && sed -i -e "s|^mirrorlist=http://mirrorlist.centos.org|#mirrorlist=http://mirrorlist.centos.org|g" /etc/yum.repos.d/*.repo \
    && sed -i -e "s|^#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g" /etc/yum.repos.d/*.repo \
    && sed -i -e "s|mirror\.centos\.org/centos/\$releasever|vault\.centos\.org/6.6|g" /etc/yum.repos.d/*.repo

RUN yum --setopt=tsflags=nodocs -y install \
    epel-release \
    gcc \
    gcc-c++ \
    git \
    wget \
    httpd-devel \
    mod_ssl \
    libxml2-devel \
    openssl-devel \
    bzip2-devel \
    libcurl-devel \
    libjpeg-turbo-devel \
    libpng-devel \
    freetype-devel \
    libicu-devel \
    postgresql-devel \
    readline-devel \
    libxslt-devel \
    && yum clean all

RUN mkdir /root/tmp \
    && cd /root/tmp \
    && wget https://archives.fedoraproject.org/pub/archive/epel/6/x86_64/Packages/l/libmcrypt-2.5.8-9.el6.x86_64.rpm \
    && wget https://archives.fedoraproject.org/pub/archive/epel/6/x86_64/Packages/l/libmcrypt-devel-2.5.8-9.el6.x86_64.rpm \
    && yum -y localinstall libmcrypt-2.5.8-9.el6.x86_64.rpm libmcrypt-devel-2.5.8-9.el6.x86_64.rpm

ENV VERSION 71

COPY scripts/php* /root/tmp/
RUN /bin/bash /root/tmp/php-build.sh && rm -rf /root/tmp
COPY etc/httpd-php.conf /etc/httpd/conf.d/php.conf

EXPOSE 80 443

CMD ["/usr/sbin/httpd", "-DFOREGROUND"]

WORKDIR /var/www/html
