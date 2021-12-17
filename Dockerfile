#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "apply-templates.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

# from https://www.drupal.org/docs/system-requirements/php-requirements
FROM php:7.4-apache-buster

# grab a copy of install-php-extensions
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

# install the PHP extensions we need
RUN set -eux; \
	\
	if command -v a2enmod; then \
		a2enmod rewrite; \
	fi; \
	\
	savedAptMark="$(apt-mark showmanual)"; \
	\
	apt-get update; \
	apt-get install -y --no-install-recommends \
		libfreetype6-dev \
		libjpeg-dev \
		libpng-dev \
		libpq-dev \
		libzip-dev \
                git \
                sudo \
	; \
	\
	docker-php-ext-configure gd \
		--with-freetype \
		--with-jpeg=/usr \
	; \
	\
	install-php-extensions \
		gd \
		opcache \
		pdo_mysql \
		pdo_pgsql \
		zip \
		pdo_sqlsrv-5.10.0beta1 \
                yaml \
		pcov \
                apcu \
	; \
	\
# reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
	apt-mark auto '.*' > /dev/null; \
        apt-mark manual git sudo; \
	apt-mark manual $savedAptMark; \
	ldd "$(php -r 'echo ini_get("extension_dir");')"/*.so \
		| awk '/=>/ { print $3 }' \
		| sort -u \
		| xargs -r dpkg-query -S \
		| cut -d: -f1 \
		| sort -u \
		| xargs -rt apt-mark manual; \
	\
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	rm -rf /var/lib/apt/lists/*

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=60'; \
		echo 'opcache.fast_shutdown=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini

RUN { \
                echo 'apc.enable_cli=1'; \
                echo 'apc.enable=1'; \
        } > /usr/local/etc/php/conf.d/apcu-recommended.ini

COPY --from=composer:2 /usr/bin/composer /usr/local/bin/

# https://www.drupal.org/node/3060/release
ENV DRUPAL_VERSION 9.4.x

WORKDIR /opt
RUN set -eux; \
        git clone -b ${DRUPAL_VERSION} https://git.drupalcode.org/project/drupal.git drupal; \
	chown -R www-data:www-data drupal/sites drupal/modules drupal/themes; \
	rmdir /var/www/html; \
	ln -sf /opt/drupal /var/www/html; \
        cd drupal; \
	composer install; \
	composer require mglaman/phpstan-drupal phpstan/phpstan-phpunit phpstan/phpstan jangregor/phpstan-prophecy drupal/coder

ENV PATH=${PATH}:/opt/drupal/vendor/bin

RUN apt-get update -qq; \
	apt-get install -yqq software-properties-common gnupg

# Install SQL Server
RUN add-apt-repository "$(curl https://packages.microsoft.com/config/ubuntu/16.04/mssql-server-2019.list)"; \
	add-apt-repository "$(curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list)"; \
	curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -; \
	apt-get update -qq; \
	ACCEPT_EULA=Y apt-get install -yqq mssql-server mssql-tools unixodbc-dev
	
ENV PATH="/opt/mssql-tools/bin:${PATH}"

# vim:set ft=dockerfile:
