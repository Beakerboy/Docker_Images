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
	install-php-extensions \
		gd \
		opcache \
		pdo_mysql \
		pdo_pgsql \
		zip \
		pdo_sqlsrv \
	;

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
		echo 'client_buffer_max_kb_size = 50240'; \
		echo 'sqlsrv.ClientBufferMaxKBSize = 50240'; \
	} > /usr/local/etc/php/conf.d/sqlsrv-recommended.ini

# https://www.drupal.org/node/3060/release
ENV DRUPAL_VERSION 7.x-dev

RUN set -eux; \
	curl -fSL "https://ftp.drupal.org/files/projects/drupal-${DRUPAL_VERSION}.tar.gz" -o drupal.tar.gz; \
	tar -xz --strip-components=1 -f drupal.tar.gz; \
	rm drupal.tar.gz; \
	chown -R www-data:www-data sites modules themes

RUN apt-get update -qq; \
	apt-get install -yqq software-properties-common gnupg

# Install SQL Server
RUN add-apt-repository "$(curl https://packages.microsoft.com/config/ubuntu/16.04/mssql-server-2019.list)"; \
	add-apt-repository "$(curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list)"; \
	curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -; \
	apt-get update -qq; \
	ACCEPT_EULA=Y apt-get install -yqq mssql-server mssql-tools unixodbc-dev
	
ENV PATH="/opt/mssql-tools/bin:${PATH}"

# Install Composer
COPY --from=composer:1 /usr/bin/composer /usr/local/bin/

# Install postfix.
RUN { \
		echo postfix postfix/mailname string 'localhost'; \
		echo postfix postfix/main_mailer_type string 'No configuration'; \
	} | debconf-set-selections \
	&& apt-get install --assume-yes postfix

RUN pear install pear/PHP_CodeSniffer

# Install drush.
#RUN cd /var/www/html; \
#	composer require drush/drush:8.4.8

# vim:set ft=dockerfile:
