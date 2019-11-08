FROM php:5.6-apache

LABEL Ari Mourão <amlima@gmail.com>

RUN apt-get update && apt-get -y install apt-utils gnupg2 apt-transport-https lsb-release \
freetds-bin freetds-dev freetds-common

RUN export DEBIAN_FRONTEND=noninteractive && apt-get update \
    && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/debian/9/prod.list \
        > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get install -y --no-install-recommends \
        locales \
    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen \
    && apt-get update \
    && apt-get -y --no-install-recommends install unixodbc unixodbc-dev \
    && apt-get -y update && \
    export ACCEPT_EULA=Y && apt-get -y install msodbcsql17 mssql-tools

RUN ln -s /usr/lib/x86_64-linux-gnu/libsybdb.so /usr/lib/

RUN BEFORE_PWD=$(pwd) \
    && mkdir -p /opt/xdebug \
    && cd /opt/xdebug \
    && curl -k -L https://github.com/xdebug/xdebug/archive/XDEBUG_2_5_5.tar.gz | tar zx \
    && cd xdebug-XDEBUG_2_5_5 \
    && phpize \
    && ./configure --enable-xdebug \
    && make clean \
    && sed -i 's/-O2/-O0/g' Makefile \
    && make \
    # && make test \
    && make install \
    && cd "${BEFORE_PWD}" \
    && rm -r /opt/xdebug

RUN docker-php-ext-install mssql mysqli pdo pdo_mysql && docker-php-ext-configure mssql

RUN docker-php-ext-enable xdebug

RUN a2enmod rewrite
