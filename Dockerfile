FROM php:7.2.24-apache-buster
LABEL Ari Mourão <amlima@gmail.com>

RUN apt-get update

RUN apt-get install -y libpq-dev \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo pdo_pgsql pgsql

RUN BEFORE_PWD=$(pwd) \
    && mkdir -p /opt/xdebug \
    && cd /opt/xdebug \
    && curl -k -L https://github.com/xdebug/xdebug/archive/2.8.0.tar.gz | tar zx \
    && cd xdebug-2.8.0 \
    && phpize \
    && ./configure --enable-xdebug \
    && make clean \
    && sed -i 's/-O2/-O0/g' Makefile \
    && make \
    # && make test \
    && make install \
    && cd "${BEFORE_PWD}" \
    && rm -r /opt/xdebug

#RUN docker-php-ext-install pgsql pdo pdo_pgsql

RUN docker-php-ext-enable xdebug

RUN a2enmod rewrite
