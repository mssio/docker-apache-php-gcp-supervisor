#!/bin/bash

# Setup composer
composer install --no-interaction --no-dev

# Setup cron
if test -e "/.cron-config/cron.conf";then
  /usr/bin/crontab /.cron-config/cron.conf
  cron
fi

# Setup supervisor configuration
if test -e "/supervisor/supervisord.conf";then
  cp /supervisor/supervisord.conf /etc/supervisor/supervisord.conf
fi

# Set app owner
chown -R www-data:www-data /var/www/html

# Run supervisor
/usr/bin/supervisord
