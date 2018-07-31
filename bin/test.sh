#!/usr/bin/env bash
set -xe

if [ ! -d  ~/public_html/example.test ]; then
  mkdir -p ~/public_html/example.test
fi

# dnsmasq check
RET=`nslookup example.test 127.0.0.1 -timeout=1 | grep 'Address: 127.0.0.1'`
if [ ! -z "$RET" ]; then
: #  exit 0;
else
  echo 'nslookup failed'
  exit 1; # failed
fi

# httpd standard check
echo 'Hello World' > ~/public_html/example.test/hello.html
RET=`curl --max-time 1 -H 'Host: example.com' http://127.0.0.1/hello.html | grep 'Hello World'`
if [ ! -z "$RET" ]; then
  rm ~/public_html/example.test/hello.html
: #  exit 0;
else
  echo 'httpd check failed'
  exit 1; # failed
fi


# symlink check
#if [ ! -d ~/tmp/example_link.test ]; then
#  mkdir ~/tmp/example_link.test
#fi
#echo 'I am a Pen.' > ~/tmp/example_link.test/index.html
#ln -s ~/tmp/example_link.test ~/public_html/example_link.test
#RET=`curl -s --max-time 1 http://example_link.test/index.html | grep 'I am a Pen.'`
#if [ ! -z "$RET" ]; then
#: #  exit 0;
#else
#  echo 'symlink check failed'
#  exit 1; # failed
#fi
