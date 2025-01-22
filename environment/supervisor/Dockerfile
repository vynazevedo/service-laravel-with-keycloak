FROM php:8.1.12-fpm-alpine
RUN docker-php-ext-install pdo pdo_mysql

RUN apk update && apk add --no-cache supervisor

RUN mkdir -p "/etc/supervisor/logs"

COPY ./supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord", "-n", "-c",  "/etc/supervisor/conf.d/supervisord.conf"]
