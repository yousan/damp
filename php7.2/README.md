# Legacy: PHP 7.2 (unmaintained)

PHP 7.2 reached end of life in November 2020 and gets no security fixes
(for example CVE-2026-109618 / CVE-2026-109619, see the
[php.net advisory of 2026-10-21](https://www.php.net/archive/2026.php#2026-10-21-5)).
This directory is kept only as a reference for the old `yousan/php7.2-apache` image.
It is not used by `docker-compose.yml` and is not tested.

The default DAMP image is now [`php8.4/apache`](../php8.4/apache).

The phpMyAdmin 4.8.2 copy that used to live in `apache/pma.test` was removed;
`http://pma.test/` is now served by the official `phpmyadmin` image.
