FROM alpine:3.7

MAINTAINER Daniele Cesarini <daniele.cesarini@gmail.com>

ENV TIMEZONE            UTC
ENV PHP_MEMORY_LIMIT    512M
ENV MAX_UPLOAD          50M
ENV PHP_MAX_FILE_UPLOAD 200
ENV PHP_MAX_POST        100M
ENV php_conf /etc/php7/php.ini

RUN	apk update && \
    apk upgrade && \
    apk add --update tzdata && \
    cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
    echo "${TIMEZONE}" > /etc/timezone && \
    apk add --update \
    openssl-dev \
    curl \
    bash \
    supervisor \
    git \
    icu-libs \
    libwebp \
    php7 \
    php7-exif \
    php7-soap \
    php7-openssl \
    php7-gmp \
    php7-pdo_odbc \
    php7-json \
    php7-dom \
    php7-pdo \
    php7-zip \
    php7-mysqli \
    php7-sqlite3 \
    php7-pdo_pgsql \
    php7-bcmath \
    php7-gd \
    php7-odbc \
    php7-pdo_mysql \
    php7-pdo_sqlite \
    php7-gettext \
    php7-xmlreader \
    php7-xmlrpc \
    php7-bz2 \
    php7-zlib \
    php7-iconv \
    php7-pdo_dblib \
    php7-curl \
    php7-ctype \
    php7-mcrypt \
    php7-phar \
    php7-intl \
    php7-opcache \
    php7-tokenizer \
    php7-pspell \
    php7-mbstring \
    php7-ldap \
    php7-xsl \
    php7-session \
    php7-xml \
    php7-simplexml \
    php7-sockets \
    php7-posix && \
    sed -i "s|;*date.timezone =.*|date.timezone = ${TIMEZONE}|i" ${php_conf} && \
    sed -i "s/variables_order = \"GPCS\"/variables_order = \"EGPCS\"/g" ${php_conf} && \
    sed -i "s|;*memory_limit =.*|memory_limit = ${PHP_MEMORY_LIMIT}|i" ${php_conf} && \
    sed -i "s|;*upload_max_filesize =.*|upload_max_filesize = ${MAX_UPLOAD}|i" ${php_conf} && \
    sed -i "s|;*max_file_uploads =.*|max_file_uploads = ${PHP_MAX_FILE_UPLOAD}|i" ${php_conf} && \
    sed -i "s|;*post_max_size =.*|post_max_size = ${PHP_MAX_POST}|i" ${php_conf} && \
    sed -i "s|;*cgi.fix_pathinfo=.*|cgi.fix_pathinfo=0|i" ${php_conf} && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer && \
    mkdir -p /var/log/supervisor && \
    # Cleaning up
    mkdir /www && \
    apk del tzdata curl && \
    rm -rf /var/cache/apk/*

WORKDIR /www

CMD exec /usr/bin/supervisord -n -c /etc/supervisord.conf
