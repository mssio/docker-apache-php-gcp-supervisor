#!/bin/bash

composer install --no-interaction
/usr/bin/supervisord
