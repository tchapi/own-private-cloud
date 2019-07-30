#!/bin/bash

mongo -- "$MONGO_INITDB_DATABASE" <<- EOFMONGO

    use $MONGO_WEKAN_DATABASE;

    var admin = db.getSiblingDB('admin');
    admin.auth('$MONGO_INITDB_ROOT_USERNAME', '$MONGO_INITDB_ROOT_PASSWORD');
    admin.createUser({user: '$WEKAN_DB_USER', pwd: '$WEKAN_DB_PWD', roles: [{role: "readWrite", db:"$MONGO_WEKAN_DATABASE"}]});

EOFMONGO