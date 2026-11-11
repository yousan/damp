# DAMP

DAMPはApache, MySQL(MariaDB), PHPの環境を手早く作るためのDocker設定ファイルです。

```shell
docker compose up
```


## DAMPでなにができるの？

フォルダを作るとブラウザでアクセスできるローカル環境ができます。
例えば ~/public_html/test.test というフォルダを作ると http://test.test でアクセスすることができます。

便利じゃないですか？
案件がたくさんあっても切り替え簡単なんです。
VirtualHostってたくさん書かなくても良いんです。
Hostsの編集もいらないです。

## DAMPのインストール方法

```shell
mkdir -p ~/public_html   # 先に作っておく（Linux では無いと root 所有で作られる）
git clone https://github.com/yousan/damp.git
cd damp
docker compose up
```

初回は PHP のイメージ `yousan/php8.4-apache`（linux/amd64・linux/arm64）を Docker Hub から取ってきます。
更新するときは `git pull` のあと `docker compose pull` と `docker compose up -d --remove-orphans` を実行してください。
`latest` は毎週作り直しているので、PHP のセキュリティ修正が取り込まれます（PHP の版のタグ、例 `yousan/php8.4-apache:8.4.27` もあります）。

Dockerfile（`php8.4/apache`）を変えたときなど、手元で作り直すときは `docker compose build --pull php.test` のあと `docker compose up -d`。`docker compose pull` で Docker Hub のイメージに戻ります。

以前の PHP 7.2 版（コンテナ名 `php72.test`）から更新するときは、サービス名が変わったので一度だけ
`docker compose up -d --remove-orphans`（または `docker rm -f php72.test`）で古いコンテナを消してください。
`/private/var/lib/mysql` のデータベースはそのまま残ります。`php7.2/apache/php` で変えていた PHP 設定は使われなくなるので、`php8.4/apache/php/user.ini` に移してください。

* PHP: 8.4（`yousan/php8.4-apache`。元は `php8.4/apache`）
* phpMyAdmin: http://pma.test/ （ユーザ `root` / パスワード `example`。ローカル開発専用）
* 自分用の PHP 設定は `php8.4/apache/php/user.ini` に書きます

`php5.6/`・`php7.2/`・`django/3.6` はサポートの終わった古い版で、参考のために残しているだけです（テストもしていません）。

