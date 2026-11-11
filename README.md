# DAMP

DAMPはApache, MySQL(MariaDB), PHPの環境を手早く作るためのDocker設定ファイルです。

```shell
docker compose up
```

[![CI](https://github.com/yousan/damp/actions/workflows/ci.yml/badge.svg)](https://github.com/yousan/damp/actions/workflows/ci.yml)

## DAMPでなにができるの？

フォルダを作るとブラウザでアクセスできるローカル環境ができます。
例えば ~/public_html/test.test というフォルダを作ると http://test.test でアクセスすることができます。

便利じゃないですか？
案件がたくさんあっても切り替え簡単なんです。
VirtualHostってたくさん書かなくても良いんです。
Hostsの編集もいらないです。

[日本語の情報はこちらにあります](https://qiita.com/yousan/items/f05fa03c1f3951971f2f)

# How to use

`~/public_html/<name>.test/` is served at `http://<name>.test/`.
`*.test` is resolved to 127.0.0.1 by the bundled dnsmasq (on macOS, run `resolver_ja.command` once
to point `/etc/resolver/test` at it).

## Up

```bash
git clone https://github.com/yousan/damp.git
cd damp
docker compose up
```

The first start builds the PHP image locally, which takes a few minutes.

## Down

```bash
docker compose down
```

## Update

```bash
git pull
docker compose build --pull
docker compose up -d
```

Rebuild regularly so the image picks up PHP security releases.

Upgrading from the old PHP 7.2 setup (container `php72.test`): the service was renamed, so remove the
old container once with `docker compose up -d --remove-orphans` (or `docker rm -f php72.test`).
MariaDB data in `/private/var/lib/mysql` is kept. PHP settings you changed under `php7.2/apache/php`
are no longer used; copy them into `php8.4/apache/php/user.ini`.

## What runs

| Service | What | Address |
| --- | --- | --- |
| `php.test` | Apache + PHP 8.4 (`php8.4/apache`) | port 80, `http://<name>.test/` |
| `phpmyadmin.test` | Official `phpmyadmin` image | `http://pma.test/` (user `root`, password `example`) |
| `mysql.test` | MariaDB | port 3306, host `mysql.test` from PHP |
| `dnsmasq.test` | `*.test` -> 127.0.0.1 | port 53 |

Your own PHP settings go in `php8.4/apache/php/user.ini`.

The root password `example` is for local development only. Do not expose these ports to other networks.

## Old PHP versions

`php5.6/`, `php7.2/` and `django/3.6` are kept for reference only. Those PHP and Python versions are
end of life, get no security fixes, and are not tested. See the README in each directory.

## Test

With the stack running:

```bash
bin/test.sh
```
