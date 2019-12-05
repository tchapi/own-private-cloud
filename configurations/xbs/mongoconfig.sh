#!/bin/bash

mongo -- "$MONGO_INITDB_DATABASE" <<- EOFMONGO

    use $XBS_DATABASE;

    var admin = db.getSiblingDB('admin');
    admin.auth('$MONGO_INITDB_ROOT_USERNAME', '$MONGO_INITDB_ROOT_PASSWORD');

    admin.createUser({user: '$XBS_DB_USERNAME', pwd: '$XBS_DB_PASSWORD', roles: [{role: "readWrite", db:"$XBS_DATABASE"}]});

    db.newsynclogs.createIndex( { "expiresAt": 1 }, { expireAfterSeconds: 0 } );
    db.newsynclogs.createIndex( { "ipAddress": 1 } );
    db.bookmarks.createIndex( { "lastAccessed": 1 }, { expireAfterSeconds: 21*86400 } );

EOFMONGO