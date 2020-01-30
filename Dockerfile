ARG DEBIAN_FRONTEND=noninteractive

FROM php:7.2.24-apache-buster
LABEL Ari Mourão <amlima@gmail.com>

RUN apt-get update && apt-get install -y --fix-missing \
    git \
    apt-utils \
    #dependencia pgsql
    libpq-dev \
    #dependencias gd
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    #dependencias zip
    zlib1g-dev \
    libzip-dev

RUN docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql
RUN docker-php-ext-configure gd

RUN docker-php-ext-install -j$(nproc) gd
RUN docker-php-ext-install zip
RUN docker-php-ext-install pdo pdo_pgsql pgsql

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

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN docker-php-ext-enable xdebug

RUN a2enmod rewrite
