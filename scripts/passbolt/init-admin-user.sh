#!/bin/bash

source ../../environment/production.env

echo "### Creating first admin user"
docker exec passbolt su -m -c "/var/www/passbolt/bin/cake passbolt register_user -u ${EMAIL} -f ${USER} -l ${USER} -r admin" -s /bin/sh www-data
