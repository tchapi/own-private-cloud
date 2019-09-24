#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $DIR/../../.env

echo "### Creating first admin user"
docker exec passbolt su -m -c "/var/www/passbolt/bin/cake passbolt register_user -u ${EMAIL} -f ${USER} -l ${USER} -r admin" -s /bin/sh www-data
