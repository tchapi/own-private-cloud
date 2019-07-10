#!/bin/bash

echo "### Creating dummy certificates"
docker-compose run --rm --entrypoint "\
  mkdir -p /etc/letsencrypt/live/notes.***REMOVED***.me /etc/letsencrypt/live/sesame.***REMOVED***.me" certbot
docker-compose run --rm --entrypoint "\
  openssl req -x509 -nodes -newkey rsa:1024 -days 1\
    -keyout '/etc/letsencrypt/live/notes.***REMOVED***.me/privkey.pem' \
    -out '/etc/letsencrypt/live/notes.***REMOVED***.me/fullchain.pem' \
    -subj '/CN=localhost'" certbot
docker-compose run --rm --entrypoint "\
  openssl req -x509 -nodes -newkey rsa:1024 -days 1\
    -keyout '/etc/letsencrypt/live/sesame.***REMOVED***.me/privkey.pem' \
    -out '/etc/letsencrypt/live/sesame.***REMOVED***.me/fullchain.pem' \
    -subj '/CN=localhost'" certbot

echo "### Starting nginx ..."
docker-compose up --force-recreate -d proxy

echo "### Deleting dummy certificates"
docker-compose run --rm --entrypoint "\
  rm -Rf /etc/letsencrypt/live/*.***REMOVED***.me && \
  rm -Rf /etc/letsencrypt/archive/*.***REMOVED***.me && \
  rm -Rf /etc/letsencrypt/renewal/notes.***REMOVED***.me.conf \
  rm -Rf /etc/letsencrypt/renewal/sesame.***REMOVED***.me.conf" certbot

echo "### Requesting real Let's Encrypt certificates"
docker-compose run --rm --entrypoint "\
  certbot certonly --webroot -w /var/www/letsencrypt \
    --email ***REMOVED***@***REMOVED***.me \
    -d notes.***REMOVED***.me -d sesame.***REMOVED***.me \
    --rsa-key-size 4096 \
    --agree-tos \
    --force-renewal" certbot

echo "### Reloading nginx ..."
docker-compose exec proxy nginx -s reload