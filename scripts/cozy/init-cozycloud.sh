#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $DIR/../../.env

echo "### Creating cloud instance with 10GB as quota"
docker exec -it cozy bash -c "\
  export COZY_ADMIN_PASSWORD=${COZY_ADMIN_PASSPHRASE} && \
  cozy-stack instances add --apps drive,settings ${CLOUD_DOMAIN} --email ${EMAIL} --passphrase ${CLOUD_MASTER_PASSWORD} --disk-quota 30GB"
echo "### Done."