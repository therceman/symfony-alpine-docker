FROM alpine:3.15

# ENV Variables
ENV PHP_OPCACHE_VALIDATE_TIMESTAMPS=0

RUN apk add bash

RUN apk --update add openssh-client curl git \ 
    # core php modules
    php-apache2 php-cli php-phar php-openssl \
    # performance php modules
    php-opcache \
    # extra php modules
    php-json php-mbstring \
    # symfony core modules
    php-ctype php-iconv php-session php-tokenizer php-simplexml \
    # symfony extra
    php-dom php-intl \
    # symfony optional
    php-posix \
    # db modules
    php-pdo php-pdo_pgsql php-pgsql && \
    # other magic
    rm -f /var/cache/apk/* && \
    # composer install
    curl -sS https://getcomposer.org/installer | php -- \
    --install-dir=/usr/local/bin --filename=composer && \
    # www dir setup
    mkdir -p /var/www/html/ && chown -R apache:apache /var/www/html

# symfony cli install
RUN curl -sS https://get.symfony.com/cli/installer | bash && mv /root/.symfony/bin/symfony /usr/local/bin/symfony

# copy config files
COPY etc/php/conf.d/opcache.ini /etc/php7/conf.d/opcache.ini
COPY etc/apache2/httpd.conf /etc/apache2/httpd.conf
COPY etc/apache2/sites/ /etc/apache2/sites/
COPY etc/php/php.ini /etc/php7/php.ini
COPY scripts/entrypoint.sh /opt/entrypoint.sh

EXPOSE 80

WORKDIR /var/www/html/

RUN PATH=$PATH:/var/www/vendor/bin:bin

CMD ["/opt/entrypoint.sh"]
