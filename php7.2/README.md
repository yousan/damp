# Legacy: PHP 7.2 (unmaintained)

PHP 7.2 reached end of life in November 2020 and gets no security fixes
(for example CVE-2026-109618 / CVE-2026-109619, php.net advisory 2026-10-21).
This directory is kept only as a reference for the old `yousan/php7.2-apache` image.
It is not used by `docker-compose.yml` and is not tested.

The default DAMP image is now [`php8.4/apache`](../php8.4/apache).

The phpMyAdmin 4.8.2 copy that used to live in `apache/pma.test` was removed;
`http://pma.test/` is now served by the official `phpmyadmin` image.
