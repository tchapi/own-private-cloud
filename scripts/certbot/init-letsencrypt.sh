#!/bin/bash

notes_url="notes-staging.***REMOVED***.me"
passbolt_url="sesame-staging.***REMOVED***.me"
email="***REMOVED***@***REMOVED***.me"

echo "### Creating dummy certificates"
docker-compose run --rm --entrypoint "\
  rm -Rf /etc/letsencrypt/live && rm -Rf /etc/letsencrypt/archive && rm -Rf /etc/letsencrypt/renewal" certbot
docker-compose run --rm --entrypoint "\
  mkdir -p /etc/letsencrypt/live/${notes_url} /etc/letsencrypt/live/${passbolt_url}" certbot
docker-compose run --rm --entrypoint "\
  openssl req -x509 -nodes -newkey rsa:1024 -days 1\
    -keyout '/etc/letsencrypt/live/${notes_url}/privkey.pem' \
    -out '/etc/letsencrypt/live/${notes_url}/fullchain.pem' \
    -subj '/CN=localhost'" certbot
docker-compose run --rm --entrypoint "\
  openssl req -x509 -nodes -newkey rsa:1024 -days 1\
    -keyout '/etc/letsencrypt/live/${passbolt_url}/privkey.pem' \
    -out '/etc/letsencrypt/live/${passbolt_url}/fullchain.pem' \
    -subj '/CN=localhost'" certbot

echo "### Starting nginx ..."
# This will spin up the whole thing because of dependencies
docker-compose up --force-recreate -d reverse-proxy

echo "### Deleting all certificates"
docker-compose run --rm --entrypoint "\
  rm -Rf /etc/letsencrypt/live && rm -Rf /etc/letsencrypt/archive && rm -Rf /etc/letsencrypt/renewal" certbot

echo "### Requesting real Let's Encrypt certificates"
docker-compose run --rm --entrypoint "\
  certbot certonly --webroot -w /var/www/letsencrypt \
    --email ${email} \
    -d ${passbolt_url} \
    --rsa-key-size 4096 \
    --agree-tos \
    --force-renewal" certbot
docker-compose run --rm --entrypoint "\
  certbot certonly --webroot -w /var/www/letsencrypt \
    --email ${email} \
    -d ${notes_url} \
    --rsa-key-size 4096 \
    --agree-tos \
    --force-renewal" certbot

echo "### Reloading nginx ..."
docker-compose exec reverse-proxy nginx -s reload
