#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $DIR/../../.env

echo "### Cleaning up first"
docker-compose run --rm --entrypoint "\
  rm -Rf /etc/letsencrypt/live && rm -Rf /etc/letsencrypt/archive && rm -Rf /etc/letsencrypt/renewal" certbot
docker-compose run --rm --entrypoint "\
  mkdir -p /etc/letsencrypt/live/${NOTES_DOMAIN} \
  /etc/letsencrypt/live/${PASSWORDS_DOMAIN} \
  /etc/letsencrypt/live/${CLOUD_DOMAIN} \
  /etc/letsencrypt/live/${CALENDAR_DOMAIN} \
  /etc/letsencrypt/live/${BOOKMARKS_DOMAIN} \
  /etc/letsencrypt/live/${SYNC_DOMAIN} \
  /etc/letsencrypt/live/${TASKS_DOMAIN} \
  /etc/letsencrypt/live/${MAIL_DOMAIN} " certbot

echo "### Creating dummy certificates"
docker-compose run --rm --entrypoint "\
  openssl req -x509 -nodes -newkey rsa:1024 -days 1\
    -keyout '/etc/letsencrypt/live/${NOTES_DOMAIN}/privkey.pem' \
    -out '/etc/letsencrypt/live/${NOTES_DOMAIN}/fullchain.pem' \
    -subj '/CN=localhost'" certbot
docker-compose run --rm --entrypoint "\
  openssl req -x509 -nodes -newkey rsa:1024 -days 1\
    -keyout '/etc/letsencrypt/live/${PASSWORDS_DOMAIN}/privkey.pem' \
    -out '/etc/letsencrypt/live/${PASSWORDS_DOMAIN}/fullchain.pem' \
    -subj '/CN=localhost'" certbot
docker-compose run --rm --entrypoint "\
  openssl req -x509 -nodes -newkey rsa:1024 -days 1\
    -keyout '/etc/letsencrypt/live/${CLOUD_DOMAIN}/privkey.pem' \
    -out '/etc/letsencrypt/live/${CLOUD_DOMAIN}/fullchain.pem' \
    -subj '/CN=localhost'" certbot
docker-compose run --rm --entrypoint "\
  openssl req -x509 -nodes -newkey rsa:1024 -days 1\
    -keyout '/etc/letsencrypt/live/${CALENDAR_DOMAIN}/privkey.pem' \
    -out '/etc/letsencrypt/live/${CALENDAR_DOMAIN}/fullchain.pem' \
    -subj '/CN=localhost'" certbot
docker-compose run --rm --entrypoint "\
  openssl req -x509 -nodes -newkey rsa:1024 -days 1\
    -keyout '/etc/letsencrypt/live/${BOOKMARKS_DOMAIN}/privkey.pem' \
    -out '/etc/letsencrypt/live/${BOOKMARKS_DOMAIN}/fullchain.pem' \
    -subj '/CN=localhost'" certbot
docker-compose run --rm --entrypoint "\
  openssl req -x509 -nodes -newkey rsa:1024 -days 1\
    -keyout '/etc/letsencrypt/live/${SYNC_DOMAIN}/privkey.pem' \
    -out '/etc/letsencrypt/live/${SYNC_DOMAIN}/fullchain.pem' \
    -subj '/CN=localhost'" certbot
docker-compose run --rm --entrypoint "\
  openssl req -x509 -nodes -newkey rsa:1024 -days 1\
    -keyout '/etc/letsencrypt/live/${TASKS_DOMAIN}/privkey.pem' \
    -out '/etc/letsencrypt/live/${TASKS_DOMAIN}/fullchain.pem' \
    -subj '/CN=localhost'" certbot
docker-compose run --rm --entrypoint "\
  openssl req -x509 -nodes -newkey rsa:1024 -days 1\
    -keyout '/etc/letsencrypt/live/${MAIL_DOMAIN}/privkey.pem' \
    -out '/etc/letsencrypt/live/${MAIL_DOMAIN}/fullchain.pem' \
    -subj '/CN=localhost'" certbot

# This will spin up the whole thing because of dependencies
echo "### Starting nginx ..."
docker-compose up --force-recreate -d reverse-proxy

echo "### Deleting all certificates"
docker-compose run --rm --entrypoint "\
  rm -Rf /etc/letsencrypt/live && rm -Rf /etc/letsencrypt/archive && rm -Rf /etc/letsencrypt/renewal" certbot

echo "### Requesting real Let's Encrypt certificates"
docker-compose run --rm --entrypoint "\
  certbot certonly --webroot -w /var/www/letsencrypt \
    --email ${EMAIL} \
    -d ${PASSWORDS_DOMAIN} \
    --rsa-key-size 4096 \
    --agree-tos \
    --force-renewal" certbot
docker-compose run --rm --entrypoint "\
  certbot certonly --webroot -w /var/www/letsencrypt \
    --email ${EMAIL} \
    -d ${NOTES_DOMAIN} \
    --rsa-key-size 4096 \
    --agree-tos \
    --force-renewal" certbot
docker-compose run --rm --entrypoint "\
  certbot certonly --webroot -w /var/www/letsencrypt \
    --email ${EMAIL} \
    -d ${CLOUD_DOMAIN} -d settings.${CLOUD_DOMAIN} -d drive.${CLOUD_DOMAIN} -d photos.${CLOUD_DOMAIN} -d contacts.${CLOUD_DOMAIN} \
    --rsa-key-size 4096 \
    --agree-tos \
    --force-renewal" certbot
docker-compose run --rm --entrypoint "\
  certbot certonly --webroot -w /var/www/letsencrypt \
    --email ${EMAIL} \
    -d ${CALENDAR_DOMAIN} \
    --rsa-key-size 4096 \
    --agree-tos \
    --force-renewal" certbot
docker-compose run --rm --entrypoint "\
  certbot certonly --webroot -w /var/www/letsencrypt \
    --email ${EMAIL} \
    -d ${BOOKMARKS_DOMAIN} \
    --rsa-key-size 4096 \
    --agree-tos \
    --force-renewal" certbot
docker-compose run --rm --entrypoint "\
  certbot certonly --webroot -w /var/www/letsencrypt \
    --email ${EMAIL} \
    -d ${SYNC_DOMAIN} \
    --rsa-key-size 4096 \
    --agree-tos \
    --force-renewal" certbot
docker-compose run --rm --entrypoint "\
  certbot certonly --webroot -w /var/www/letsencrypt \
    --email ${EMAIL} \
    -d ${TASKS_DOMAIN} \
    --rsa-key-size 4096 \
    --agree-tos \
    --force-renewal" certbot
docker-compose run --rm --entrypoint "\
  certbot certonly --webroot -w /var/www/letsencrypt \
    --email ${EMAIL} \
    -d ${MAIL_DOMAIN} \
    --rsa-key-size 4096 \
    --agree-tos \
    --force-renewal" certbot

echo "### Reloading nginx ..."
docker-compose exec reverse-proxy nginx -s reload

echo "### Done."
