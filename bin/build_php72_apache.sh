#!/usr/bin/env bash
# export VERSION=1.8.1 ;

echo $VERSION
if [ -z ${VERSION} ] ;
then
  echo 'please set VERSION variable';
  exit 1
fi

# 呼び出された場所からファイルの場所にカレントディレクトリを移動する
cd -- "$(dirname "$BASH_SOURCE")"
cd ../php7.2/apache

# ビルド
docker build -t yousan/php7.2-apache:${VERSION} .

# テストで走らせる
# docker run -it yousan/php7.2-apache:${VERSION} /bin/bash

# プッシュ
# docker push yousan/php7.2-apache:${VERSION}