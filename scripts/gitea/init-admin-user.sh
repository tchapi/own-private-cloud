#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $DIR/../../.env

echo "### Creating first admin user"
docker exec git sh -c "su -c 'gitea admin user create --admin --username ${GITEA_ADMIN_USER} --password \"${GITEA_ADMIN_PASSWORD}\" --email ${EMAIL}' git"
