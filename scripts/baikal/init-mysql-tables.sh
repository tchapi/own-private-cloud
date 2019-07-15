#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $DIR/../../environment/production.env

echo "### Creating Baikal tables"
tables=$(wget https://raw.githubusercontent.com/sabre-io/Baikal/master/Core/Resources/Db/MySQL/db.sql -q -O -)
docker exec -it mysql bash -c "mysql -uroot -p${MYSQL_ROOT_PASSWORD} -D${BAIKAL_DATABASE} <<-EOSQL 
    ${tables} 
EOSQL"
echo "### Done."

