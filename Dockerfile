FROM php:5.6.19-apache
MAINTAINER Mario <mario@mss.io>

# Install dependencies
# PHP Dependencies
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
    && docker-php-ext-install -j$(nproc) iconv mcrypt mbstring pdo_mysql bcmath \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd
# Google Cloud Dependencies
RUN apt-get install -y -qq --no-install-recommends wget unzip python openjdk-7-jre-headless openssh-client python-openssl
# Supervisor Dependencies
RUN apt-get install -y -qq --no-install-recommends supervisor
# Install Cron
RUN apt-get install -y -qq --no-install-recommends cron
# Composer Dependencies
RUN apt-get install -y -qq --no-install-recommends git

# Setup Google Cloud
WORKDIR /
# Install the Google Cloud SDK.
ENV HOME /
ENV CLOUDSDK_PYTHON_SITEPACKAGES 1
RUN wget https://dl.google.com/dl/cloudsdk/channels/rapid/google-cloud-sdk.zip && unzip google-cloud-sdk.zip && rm google-cloud-sdk.zip
RUN google-cloud-sdk/install.sh --usage-reporting=true --path-update=true --bash-completion=true --rc-path=/.bashrc --additional-components app-engine-java app-engine-python app kubectl alpha beta

# Disable updater check for the whole installation.
# Users won't be bugged with notifications to update to the latest version of gcloud.
RUN google-cloud-sdk/bin/gcloud config set --installation component_manager/disable_update_check true

# Disable updater completely.
# Running `gcloud components update` doesn't really do anything in a union FS.
# Changes are lost on a subsequent run.
RUN sed -i -- 's/\"disable_updater\": false/\"disable_updater\": true/g' /google-cloud-sdk/lib/googlecloudsdk/core/config.json

ENV PATH /google-cloud-sdk/bin:$PATH
VOLUME ["/.config"]

# Install Composer
ENV COMPOSER_VERSION 1.0.0-beta1
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=${COMPOSER_VERSION}

# Cleanup
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set php configuration
COPY config/php.ini /usr/local/etc/php/

# Enable Required Apache Module
RUN a2enmod rewrite

# Run Application
VOLUME ["/etc/supervisor/conf.d"]
RUN mkdir /supervisor
VOLUME ["/supervisor"]
RUN mkdir /.cron-config
VOLUME ["/.cron-config"]
COPY docker-entrypoint.sh /entrypoint.sh
WORKDIR /var/www/html
CMD ["/entrypoint.sh"]
