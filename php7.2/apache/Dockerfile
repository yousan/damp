# @link https://github.com/docker-library/wordpress/blob/591388696848f29bfa627ab38f78678135096f15/php7.2/apache/Dockerfile
FROM php:7.2-apache

# install the PHP extensions we need
RUN set -ex; \
	apt-get update; \
	apt-get install -y \
		libjpeg-dev \
		libpng-dev \
	; \
	rm -rf /var/lib/apt/lists/*; \
	\
	docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr; \
	docker-php-ext-install gd mysqli opcache
# TODO consider removing the *-dev deps and only keeping the necessary lib* packages

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=2'; \
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini

RUN a2enmod rewrite expires vhost_alias

# for DAMP develop DAMP開発用
RUN apt-get update && apt-get install -y \
  emacs-nox mlocate less git

# mcrypt @link http://willow710kut.hatenablog.com/entry/2018/02/14/213158
RUN apt-get update -y \
    && apt-get install -y libmcrypt-dev \
    && echo '' | pecl install mcrypt-1.0.1 \
    && echo 'extension=mcrypt.so' > /usr/local/etc/php/conf.d/docker-php-ext-pecl.ini

# @link https://github.com/phpbrew/phpbrew/issues/786
# RUN apt-get install libbz2-dev

# Install packages（コロンの後ろはaptで必要なパッケージ）
# mbstring
# bz2: bzip2 libbz2-dev
# intl: libicu-dev # @link https://github.com/docker-library/php/issues/57
# pgsql, pdo_sql: postgresql-client # 動かない
# @link https://hub.docker.com/r/plab/docker-php/~/dockerfile/
# imagick: @see https://github.com/docker-library/php/issues/105#issuecomment-421081065
RUN apt-get update && apt-get install -y \
  bzip2 libbz2-dev \
  libicu-dev \
  mysql-client \
  && apt-get install -y --no-install-recommends libmagickwand-dev \
  && pecl install imagick-3.4.3 \
  && docker-php-ext-configure intl \
  && docker-php-ext-install mbstring bz2 zip intl pdo pdo_mysql \
  && docker-php-ext-enable imagick

# composerのインストール。aptからインストールしようとすると依存パッケージのインストール失敗でエラーになるので手動で。
RUN cd /tmp \
  && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
  && php -r "if (hash_file('sha384', 'composer-setup.php') === '48e3236262b34d30969dca3c37281b3b4bbe3221bda826ac6a9a62d6444cdb0dcd0615698a5cbe587c3f0fe57a54d8f5') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
  && php composer-setup.php \
  && php -r "unlink('composer-setup.php');" \
  && chmod +x composer.phar \
  && mv composer.phar /usr/local/bin/composer

# Install nodebrew, node and npm
RUN cd / \
  && curl -L git.io/nodebrew | perl - setup \
  && echo "PATH=$HOME/.nodebrew/current/bin:$PATH" >> ~/.bashrc && . ~/.bashrc \
  && nodebrew install v8.9.4 && nodebrew use v8.9.4

# gdをfreetype, pngとかに対応させたいが動かない
# apt-get install -y libfreetype6-test libjpeg62-turbo-test libpng12-test \
#	&& docker-php-ext-configure gd -with-freetype-dir=/usr/include/ -with-jpeg-dir=/usr/include/

# pgsql, pdo_pgsql が動かない
#	apt-get install libghc-postgresql-libpq-test \
#	&& docker-php-ext-install pgsql pdo_pgsql
#	&& docker-php-ext-configure pgsql -with-pgsql=/usr/include/postgresql/

