#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $DIR/../../environment/production.env

echo "### Creating cloud instance"
docker-compose run --rm --entrypoint "export COZY_ADMIN_PASSWORD=${COZY_ADMIN_PASSPHRASE}" certbot
docker-compose run --rm --entrypoint "\
  cozy-stack instances add --apps contacts,drive,photos,settings ${CLOUD_DOMAIN} --email ${EMAIL} --passphrase ${CLOUD_MASTER_PASSWORD}" certbot
