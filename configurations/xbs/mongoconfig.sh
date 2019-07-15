#!/bin/bash

mongo -- "$MONGO_INITDB_DATABASE" <<- EOFMONGO

    var admin = db.getSiblingDB('admin');
    admin.auth('$MONGO_INITDB_ROOT_USERNAME', '$MONGO_INITDB_ROOT_PASSWORD');
    admin.createUser({user: '$XBROWSERSYNC_DB_USER', pwd: '$XBROWSERSYNC_DB_PWD', roles: [{role: "readWrite", db:"$MONGO_INITDB_DATABASE"}]});

    db.newsynclogs.createIndex( { "expiresAt": 1 }, { expireAfterSeconds: 0 } );
    db.newsynclogs.createIndex( { "ipAddress": 1 } );
    db.bookmarks.createIndex( { "lastAccessed": 1 }, { expireAfterSeconds: 21*86400 } );

EOFMONGO