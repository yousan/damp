#!/usr/bin/env bash
# Smoke test for a running DAMP stack (docker compose up -d).
# Checks: dnsmasq answers *.test, Apache serves ~/public_html/<name>.test,
# PHP runs on a supported version, and http://pma.test/ reaches phpMyAdmin.
set -eu

HOST=127.0.0.1
DOCROOT=~/public_html/example.test

fail() { echo "FAIL: $*" >&2; exit 1; }

# Wait until Apache answers (the first start can take a while).
for _ in $(seq 1 60); do
  curl -s -o /dev/null --max-time 2 "http://$HOST/" && break
  sleep 2
done

# dnsmasq: example.test -> 127.0.0.1
nslookup -timeout=2 example.test "$HOST" | grep -q 'Address: 127.0.0.1' \
  || fail 'dnsmasq did not resolve example.test to 127.0.0.1'
echo 'ok: dns'

mkdir -p "$DOCROOT"
trap 'rm -f "$DOCROOT/hello.html" "$DOCROOT/version.php"' EXIT

# Static file through the *.test VirtualDocumentRoot
echo 'Hello World' > "$DOCROOT/hello.html"
curl -s --max-time 5 -H 'Host: example.test' "http://$HOST/hello.html" | grep -q 'Hello World' \
  || fail 'httpd did not serve example.test/hello.html'
echo 'ok: httpd'

# PHP executes and is a supported release
echo '<?php echo PHP_VERSION;' > "$DOCROOT/version.php"
PHP_VERSION=$(curl -s --max-time 5 -H 'Host: example.test' "http://$HOST/version.php")
echo "php: $PHP_VERSION"
[[ "$PHP_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+ ]] || fail "PHP did not run: $PHP_VERSION"
MIN_PHP=${MIN_PHP:-8.2}
[ "$(printf '%s\n%s\n' "$MIN_PHP" "$PHP_VERSION" | sort -V | head -n1)" = "$MIN_PHP" ] \
  || fail "PHP $PHP_VERSION is older than $MIN_PHP"
echo 'ok: php'

# phpMyAdmin behind http://pma.test/
for _ in $(seq 1 30); do
  curl -s --max-time 5 -H 'Host: pma.test' "http://$HOST/" | grep -q 'phpMyAdmin' && break
  sleep 2
done
curl -s --max-time 5 -H 'Host: pma.test' "http://$HOST/" | grep -q 'phpMyAdmin' \
  || fail 'pma.test did not return phpMyAdmin'
echo 'ok: phpmyadmin'

echo 'All checks passed.'
