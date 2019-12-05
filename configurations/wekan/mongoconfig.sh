#!/bin/bash

mongo <<- EOFMONGO

    use $WEKAN_DATABASE;

    var admin = db.getSiblingDB('admin');
    admin.auth('$MONGO_INITDB_ROOT_USERNAME', '$MONGO_INITDB_ROOT_PASSWORD');

    admin.createUser({user: '$WEKAN_DB_USERNAME', pwd: '$WEKAN_DB_PASSWORD', roles: [{role: "readWrite", db:"$WEKAN_DATABASE"}]});

EOFMONGO