#!/usr/bin/env bash

# cd ~/
ls -lat ~/
mkdir ~/pubcli_html
mkdir -p ~/public_html/example.dev
echo 'Hello World' > ~/public_html/example.dev/hello.html
RET=`curl http://example.dev/hello.html | grep 'Hello World'`
if [ ! -z "$RET" ]; then
  exit 0;
else
  exit 1; # failed
fi
