[![Build Status](https://travis-ci.org/yousan/damp.svg?branch=master)](https://travis-ci.org/yousan/damp)

[日本語の情報はこちらにあります](https://qiita.com/yousan/items/f05fa03c1f3951971f2f)

# DAMP
Docker Apache MySQL PHP => Perfect ;)

# How to use

At the docker-compose.yml, there are specified ~/public_html are linked into container DocumentRoot.

## Up
Up damp with commandline with replacing docker-compose.yml

```bash
$ curl -s -L -o - https://raw.githubusercontent.com/yousan/damp/master/docker-compose.yml | sed -e 's/#      - ~\/public_html:\/var\/www\/vhosts/      - ~\/public_html:\/var\/www\/vhosts/g' | docker-compose -f - up
```

## Down
Also down

```bash
$ curl -s -L -o - https://raw.githubusercontent.com/yousan/damp/master/docker-compose.yml | sed -e 's/#      - ~\/public_html:\/var\/www\/vhosts/      - ~\/public_html:\/var\/www\/vhosts/g' | docker-compose -f - down
```


# Sample

## docker-compose

```yaml
version: '3'

services:

  php7.2-apache.test:
    container_name: php72.test
    restart: always
    image: yousan/php7.2-apache
    ports:
      - 80:80
    volumes:
      - ./php7.2/apache/pma.test:/var/www/vhosts/pma.test # You can access http://pma.test to use phpMyAdmin
      - ./php7.2/apache/apache2:/etc/apache2              # Easy config for Apache httpd
      - ./php7.2/apache/php:/usr/local/etc/php            # Easy config for PHP
      # Add symlink directories if you use symlinks at documents.
      - ~/git:/Users/yousan/git       # Can access git directory 
      - ~/svn:/Users/yousan/svn       # Can access svn directory
      - ~/public_html:/var/www/vhosts # Can access ~/public_html as vhost!
    environment:
      PMA_HOST: mysql.test
      PMA_USER: root
      PMA_PASSWORD: example

  mysql.test:
    container_name: mysql.test
    image: mariadb
    environment:
      MYSQL_ROOT_PASSWORD: example
    ports:
      - 3306:3306
    volumes:
      - /private/var/lib/mysql:/var/lib/mysql

  dnsmasq.test:
    container_name: dnsmasq.test
    image: yousan/dnsmasq:1.6.1
    ports:
      - 53:53/tcp
      - 53:53/udp
    cap_add:
      - NET_ADMIN
```

Just spin up your docker-compose.

```javascript
$ docker-compose up
```

## Easy access to ***.test domain

`***.test` domain will automatically redirect into localhost:80.
When you create `~/public_html/something.test` directory, then you can access with the URL.

## phpMyAdmin

DAMP includes phpMyAdmin. You an access http://pma.test

# Releases

## 1.9.5
- Enable Node.js and npm at PHP image
