# PHPUnit Docker Container.
FROM alpine:edge
MAINTAINER Andrey Bolonin <andreybolonin1989@gmail.com>

RUN apk --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing add \
        bash \
        ca-certificates \
        git \
        curl \
        unzip \
        php7 \
        php7-xml \
        php7-zip \
        php7-xmlreader \
        php7-zlib \
        php7-opcache \
        php7-mcrypt \
        php7-openssl \
        php7-curl \
        php7-ctype \
        php7-intl \
        php7-json \
        php7-dom \
        php7-phar \
        php7-mbstring \
        php7-bcmath \
        php7-pdo \
        php7-pdo_pgsql \
        php7-pdo_sqlite \
        php7-pdo_mysql \
        php7-soap \
        php7-xdebug \
        php7-pcntl

RUN ln -s /usr/bin/php7 /usr/bin/php

WORKDIR /tmp

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/bin --filename=composer \
    && php -r "unlink('composer-setup.php');" \
    && composer require "phpunit/phpunit:~5.5.0" --prefer-source --no-interaction \
    && composer require "phpunit/php-invoker" --prefer-source --no-interaction \
    && ln -s /tmp/vendor/bin/phpunit /usr/local/bin/phpunit \
    && sed -i 's/nn and/nn, Julien Breux (Docker) and/g' /tmp/vendor/phpunit/phpunit/src/Runner/Version.php

VOLUME ["/app"]
WORKDIR /app

ENTRYPOINT ["/usr/local/bin/phpunit"]
CMD ["--help"]