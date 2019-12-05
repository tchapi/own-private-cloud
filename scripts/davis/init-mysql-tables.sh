#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $DIR/../../.env

echo "### Creating Davis tables"
docker exec -it davis bash -c "APP_ENV=prod bin/console doctrine:migrations:migrate --no-interaction"
echo "### Done."

