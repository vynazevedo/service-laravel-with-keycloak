#!/bin/bash
set -e

echo "Checking if vendor directory exists..."
if [ ! -d "vendor" ]; then
    echo "Running composer install..."
    composer install --no-dev --optimize-autoloader
fi

chown -R www-data:www-data .
chmod -R 755 .

if [ -d "storage" ]; then
    chmod -R 777 storage
fi
if [ -d "bootstrap/cache" ]; then
    chmod -R 777 bootstrap/cache
fi

exec "$@"
