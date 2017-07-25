[![Build Status](https://travis-ci.org/yousan/damp.svg?branch=master)](https://travis-ci.org/yousan/damp)


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