#!/usr/bin/env bash
set -e

if [ ! -d  ~/public_html/example.dev ]; then
  mkdir -p ~/public_html/example.dev
fi

# dnsmasq check
RET=`nslookup example.dev 127.0.0.1 -timeout=1 | grep 'Address: 127.0.0.1'`
if [ ! -z "$RET" ]; then
  echo 'nslookup successed'
  exit 1; # failed
  exit 0;
else
  echo 'nslookup failed'
  exit 1; # failed
fi

# httpd standard check
echo 'Hello World' > ~/public_html/example.dev/hello.html
RET=`curl --max-time 1 http://example.dev/hello.html | grep 'Hello World'`
if [ ! -z "$RET" ]; then
  exit 0;
else
  echo 'httpd check failed'
  exit 1; # failed
fi

# symlink check
if [ ! -d ~/tmp/example_link.dev ]; then
  mkdir ~/tmp/example_link.dev
fi
cat 'I am a Pen.' > ~/tmp/example_link.dev/index.html
ln -s ~/tmp/example_link.dev ~/public_html/example_link.dev
RET=`curl --max-time 1 http://example_link.dev/index.html | grep 'I am a Pen.'`
if [ ! -z "$RET" ]; then
  exit 0;
else
  echo 'symlink check failed'
  exit 1; # failed
fi
