#!/usr/bin/env bash

echo 'DAMPを起動します。'
echo '初回の起動には時間がかかります。'
echo '終了するには Ctrl+C を押してください。'
sleep 3

cd -- "$(dirname "$BASH_SOURCE")"

# 旧版（PHP 7.2）のコンテナが残っていると 80 番ポートが空かないので、あれば消す
docker rm -f php72.test >/dev/null 2>&1 || true

docker compose up

echo 'DAMPが終了しました。閉じるボタンを押して終了してください。'