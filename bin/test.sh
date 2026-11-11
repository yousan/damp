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
{ nslookup -timeout=2 example.test "$HOST" || true; } | grep -q 'Address: 127.0.0.1' \
  || fail 'dnsmasq did not resolve example.test to 127.0.0.1'
echo 'ok: dns'

mkdir -p "$DOCROOT"
trap 'rm -f "$DOCROOT/hello.html" "$DOCROOT/version.php" ~/public_html/example.localhost/hello.html' EXIT

# Static file through the *.test VirtualDocumentRoot
echo 'Hello World' > "$DOCROOT/hello.html"
{ curl -s --max-time 5 -H 'Host: example.test' "http://$HOST/hello.html" || true; } | grep -q 'Hello World' \
  || fail 'httpd did not serve example.test/hello.html'
echo 'ok: httpd'

# Hostnames outside *.test are served from ~/public_html/<hostname>/ as well
mkdir -p ~/public_html/example.localhost
echo 'Hello Localhost' > ~/public_html/example.localhost/hello.html
{ curl -s --max-time 5 -H 'Host: example.localhost' "http://$HOST/hello.html" || true; } | grep -q 'Hello Localhost' \
  || fail 'httpd did not serve example.localhost/hello.html'
echo 'ok: httpd (non-.test host)'

# PHP executes and is a supported release
MIN_PHP=${MIN_PHP:-8.2.0}
cat > "$DOCROOT/version.php" <<PHP
<?php echo PHP_VERSION, ' ', version_compare(PHP_VERSION, '$MIN_PHP', '>=') ? 'supported' : 'too-old';
PHP
RESULT=$(curl -s --max-time 5 -H 'Host: example.test' "http://$HOST/version.php" || true)
echo "php: $RESULT"
[[ "$RESULT" =~ ^[0-9]+\.[0-9]+\.[0-9]+.*\ (supported|too-old)$ ]] || fail "PHP did not run: $RESULT"
[[ "$RESULT" == *' supported' ]] || fail "PHP ${RESULT%% *} is older than $MIN_PHP"
echo 'ok: php'

# phpMyAdmin behind http://pma.test/
for _ in $(seq 1 30); do
  { curl -s --max-time 5 -H 'Host: pma.test' "http://$HOST/" || true; } | grep -q 'phpMyAdmin' && break
  sleep 2
done
{ curl -s --max-time 5 -H 'Host: pma.test' "http://$HOST/" || true; } | grep -q 'phpMyAdmin' \
  || fail 'pma.test did not return phpMyAdmin'
echo 'ok: phpmyadmin'

echo 'All checks passed.'
