# syntax = docker/dockerfile:experimental
FROM php:8.4-fpm

# Auto accept terms of service
ENV ACCEPT_EULA=Y

# Expose default port
EXPOSE 9000

# Set working directory
WORKDIR /var/www/html

# Arguments for New Relic (optional)
ARG NEW_RELIC_APPNAME
ARG NEW_RELIC_LICENSE_KEY
ARG NEW_RELIC_DAEMON_ADDRESS=127.0.0.1:31339

# Install system dependencies and PHP extensions
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-utils \
    autoconf \
    make \
    musl \
    g++ \
    libzip-dev \
    zlib1g-dev \
    libpng-dev \
    supervisor \
    wget \
    curl \
    git \
    zip \
    unzip && \
    docker-php-ext-install -j$(nproc) \
    bcmath \
    pdo \
    pdo_mysql \
    mysqli \
    zip \
    gd && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy PHP configuration overrides
COPY environment/php/confs/php-ini-overrides.ini /usr/local/etc/php/conf.d/99-overrides.ini

# Copy Composer binary
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Copy only necessary files for dependency installation
COPY src/composer.json src/composer.lock /var/www/html/

# Install PHP dependencies
RUN composer install --no-scripts --no-plugins --ignore-platform-reqs --no-dev --optimize-autoloader && \
    rm -rf /root/.composer/cache

# Copy remaining application files
COPY src/ /var/www/html

# Set file permissions
RUN chmod -R 1777 /tmp/ && \
    find /var/www/html -type f -exec chmod 644 {} \; && \
    find /var/www/html -type d -exec chmod 755 {} \; && \
    chown -R www-data:www-data /var/www/html
