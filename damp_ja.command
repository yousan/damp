#!/usr/bin/env bash

echo 'DAMPを起動します。'
echo '初回の起動には時間がかかります。'
echo '終了するには Ctrl+C を押してください。'
sleep 3

cd -- "$(dirname "$BASH_SOURCE")"

docker-compose up

echo 'DAMPが終了しました。閉じるボタンを押して終了してください。'