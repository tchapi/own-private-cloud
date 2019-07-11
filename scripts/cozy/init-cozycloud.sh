#!/bin/bash

cozy_url="cloud-staging.***REMOVED***.me"
email="***REMOVED***@***REMOVED***.me"
password="coucou1234"

echo "### Creating cloud instance"
docker-compose run --rm --entrypoint "export COZY_ADMIN_PASSWORD=${COZY_ADMIN_PASSPHRASE}" certbot
docker-compose run --rm --entrypoint "\
  cozy-stack instances add --apps contacts,drive,photos,settings ${cozy_url} --email ${email} --passphrase ${password}" certbot
