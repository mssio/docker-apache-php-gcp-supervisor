#!/bin/bash

# Setup composer
composer install --no-interaction --no-dev

# Setup cron
if test -e "/.cron-config/cron.conf";then
  /usr/bin/crontab /.cron-config/cron.conf
  cron
fi

# Run supervisor
/usr/bin/supervisord
