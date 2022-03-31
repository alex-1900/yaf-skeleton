FROM php:8-fpm-alpine

# composer installer
ARG COMPOSER_INSTALLER=/usr/src/installer
# composer installer src
ARG COMPOSER_SRC=https://install.phpcomposer.com/installer

WORKDIR /var/www/app

RUN set -ex \
    && export https_proxy=http://192.168.0.103:7890 && export http_proxy=http://192.168.0.103:7890 \
# Custom::Prepare
    && apk update \
    && apk add --no-cache git \
    && curl  -o $COMPOSER_INSTALLER -sS $COMPOSER_SRC \
    && apk add --no-cache git \
# PACKAGE::Install
    && apk add --no-cache \
    zlib-dev \
    cyrus-sasl-dev \
    oniguruma-dev \
    libmcrypt-dev \
    bash \
    ca-certificates \
    openssl \
    shadow \
    zip \
    unzip \
    bzip2 \
    drill \
    ldns \
    openssh-client \
    rsync \
    patch \
    # Install php environment
    imagemagick \
    graphicsmagick \
    ghostscript \
    jpegoptim \
    pngcrush \
    optipng \
    pngquant \
    vips \
    rabbitmq-c \
    c-client \
    # Libraries
    libldap \
    icu-libs \
    libintl \
    libpq \
    libxslt \
    libzip \
    yaml \
    # Build dependencies
    autoconf \
    g++ \
    make \
    libtool \
    pcre-dev \
    gettext-dev \
    freetype-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    vips-dev \
    krb5-dev \
    openssl-dev \
    imap-dev \
    imagemagick-dev \
    rabbitmq-c-dev \
    openldap-dev \
    icu-dev \
    postgresql-dev \
    libxml2-dev \
    ldb-dev \
    pcre-dev \
    libxslt-dev \
    libzip-dev \
    yaml-dev \
    && apk add --no-cache gnu-libiconv --update-cache --allow-untrusted \
# Ext::Prepare
# Ext::Configure
    && PKG_CONFIG_PATH=/usr/local docker-php-ext-configure intl \
    && PHP_OPENSSL=yes docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-configure gd --with-jpeg --with-freetype --with-webp \
    && docker-php-ext-configure ldap \
# Ext::Install \
    && docker-php-ext-install \
        bcmath \
        bz2 \
        calendar \
        exif \
        ffi \
        intl \
        gettext \
        ldap \
        mysqli \
        imap \
        pcntl \
        pdo_mysql \
        pdo_pgsql \
        pgsql \
        soap \
        sockets \
        sysvmsg \
        sysvsem \
        sysvshm \
        shmop \
        xsl \
        zip \
        gd \
        gettext \
        opcache \
    && pecl install apcu \
    && pecl install vips \
    && pecl install yaml \
    && pecl install redis \
    && pecl install mongodb \
    && pecl install imagick \
    && pecl install amqp \
    && pecl install yaf \
    && docker-php-ext-enable \
        apcu \
        vips \
        yaml \
        redis \
        imagick \
        mongodb \
        amqp \
        yaf \
# PACKAGE::Clear
    && apk del -f --purge \
        autoconf \
        g++ \
        make \
        libtool \
        pcre-dev \
        gettext-dev \
        freetype-dev \
        libjpeg-turbo-dev \
        libpng-dev \
        vips-dev \
        krb5-dev \
        openssl-dev \
        imap-dev \
        rabbitmq-c-dev \
        imagemagick-dev \
        openldap-dev \
        icu-dev \
        postgresql-dev \
        libxml2-dev \
        ldb-dev \
        pcre-dev \
        libxslt-dev \
        libzip-dev \
        yaml-dev \
        zlib-dev \
        cyrus-sasl-dev \
# Composer::Install
    && php $COMPOSER_INSTALLER --install-dir=/usr/local/bin/ --filename=composer2 \
    && php $COMPOSER_INSTALLER --install-dir=/usr/local/bin/ --filename=composer1 --1 \
    && ln -sf /usr/local/bin/composer2 /usr/local/bin/composer \
# Custom::Clear
    && rm -rf $COMPOSER_INSTALLER

COPY . /var/www/app

COPY docker/php/www.conf /usr/local/etc/php-fpm.d/www.conf

COPY docker/php/docker-php-ext-xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

EXPOSE 9000

ENTRYPOINT ["php-fpm", "--nodaemonize"]
