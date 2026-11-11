# DAMP default image: Apache + mod_php on a supported PHP release.
# php:8.4-apache follows the latest 8.4.x patch release; rebuild to pick up fixes
# (docker compose build --pull).
FROM php:8.4-apache

# PHP extensions
RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		libbz2-dev \
		libfreetype6-dev \
		libicu-dev \
		libjpeg62-turbo-dev \
		libmagickwand-dev \
		libpng-dev \
		libwebp-dev \
		libzip-dev \
	; \
	docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp; \
	docker-php-ext-install -j"$(nproc)" bz2 exif gd intl mysqli opcache pdo_mysql zip; \
	pecl install imagick; \
	docker-php-ext-enable imagick; \
	rm -rf /tmp/pear /var/lib/apt/lists/*

# Tools used while developing inside the container
RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		git less unzip mariadb-client nodejs npm \
	; \
	rm -rf /var/lib/apt/lists/*
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

RUN cp "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
COPY php/damp.ini "$PHP_INI_DIR/conf.d/damp.ini"

# Virtual hosts: http://<dir>.test -> ~/public_html/<dir>.test, http://pma.test -> phpMyAdmin
RUN a2enmod rewrite expires vhost_alias proxy proxy_http headers
COPY apache2/000-default.conf /etc/apache2/sites-available/000-default.conf
RUN echo 'ServerName localhost' > /etc/apache2/conf-available/servername.conf \
	&& a2enconf servername
