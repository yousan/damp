#!/usr/bin/env bash

echo 'すべてのdocker psを停止させます。'

docker stop $(docker ps -a -q);