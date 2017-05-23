FROM centos:6.8

MAINTAINER oppara

RUN cp -p /usr/share/zoneinfo/Japan /etc/localtime \
    && echo 'ZONE="Asia/Tokyo"' > /etc/sysconfig/clock \
    && echo 'UTC="false"' >> /etc/sysconfig/clock  \
    && source /etc/sysconfig/clock

RUN yum -y update \
    && yum --setopt=tsflags=nodocs -y install \
    epel-release \
    gcc \
    gcc-c++ \
    git \
    wget \
    httpd-devel \
    mod_ssl \
    && yum clean all

RUN yum -y install \
    libxml2-devel \
    openssl-devel \
    bzip2-devel \
    libcurl-devel \
    libjpeg-turbo-devel \
    libpng-devel \
    freetype-devel \
    libicu-devel \
    libmcrypt-devel \
    postgresql-devel \
    readline-devel \
    libxslt-devel \
    && yum clean all


ENV VERSION 71

RUN mkdir /root/tmp
COPY scripts/php* /root/tmp/
RUN /bin/bash /root/tmp/php-build.sh && rm -rf /root/tmp
COPY etc/httpd-php.conf /etc/httpd/conf.d/php.conf

EXPOSE 80 443

CMD ["/usr/sbin/httpd", "-DFOREGROUND"]

WORKDIR /var/www/html
