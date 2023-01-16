#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $DIR/../../.env

echo "### Creating single user"
docker exec -it linkding bash -c "DJANGO_SUPERUSER_PASSWORD=${LINKDING_PASSWORD} python manage.py createsuperuser --username=${LINKDING_USER} --email=${EMAIL} --noinput"
