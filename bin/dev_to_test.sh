#!/usr/bin/env bash
# Chrome63ぐらいから *.dev を受け付けてくれなくなったので、それを書き換える用のスクリプト
# 1. Chromeが *.dev を開発用に使えなくしてしまった
# 2. そのためDockerの中身を *.test に書き換える必要がある
# 3. しかしDockerの内容はしばらくするとリセットされる
# 4. Dockerのイメージを *.dev から* .test にアップデートしようとしてもPHPのバージョンが古くてコケてしまう
# ということで、現在の最新版の php.test (php.dev) に対して、*.devを*.testに書き換えるためのコマンドです

# docker exec -it php.test cat /etc/apache2/sites-available/000-default.conf

docker exec -i php.test sed -i -e 's/ServerAlias \*\.dev/ServerAlias \*\.test/' /etc/apache2/sites-available/000-default.conf
docker exec -i php.test sed -i -e 's/ServerAlias pma\.dev/ServerAlias pma\.dev pma\.test/' /etc/apache2/sites-available/000-default.conf

# docker exec -it php.test cat /etc/apache2/sites-available/000-default.conf

