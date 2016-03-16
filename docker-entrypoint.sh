#!/bin/bash

composer install --no-interaction --no-dev
/usr/bin/supervisord
