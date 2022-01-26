#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $DIR/../.env

# thanks plockc — see here : https://stackoverflow.com/a/17030953/1741150
# 
# This will take a `file.template` file and copy it to `file` while replacing the env
# vars (but quite strictly).
# WARNING : you must escape the `$` characters in the template file
expandVars()
{
    eval "cat <<EOF
$(< $1)
EOF
" 2> /dev/null 1> $2
}

echo "### Building configuration files"
# Traefik configuration
expandVars ./configurations/traefik/traefik.toml.template ./configurations/traefik/traefik.toml

# XBS configuration
expandVars ./configurations/xbs/settings.json.template ./configurations/xbs/settings.json

# Cryptpad configuration
expandVars ./configurations/cryptpad/config.js.template ./configurations/cryptpad/config.js

# Mail configuration
expandVars ./configurations/mails/smtpd.conf.template ./configurations/mails/smtpd.conf
expandVars ./configurations/mails/dkim_signing.conf.template ./configurations/mails/dkim_signing.conf
expandVars ./configurations/mails/dovecot.conf.template ./configurations/mails/dovecot.conf
expandVars ./configurations/mails/virtuals.template ./configurations/mails/virtuals
# Create DKIM key
if [ ! -f ./configurations/mails/dkim-${TOP_DOMAIN}.key ]; then
  echo "### Generating DKIM keys"
  openssl genrsa -out ./configurations/mails/dkim-${TOP_DOMAIN}.key 1024 && openssl rsa -in ./configurations/mails/dkim-${TOP_DOMAIN}.key -pubout -out ./configurations/mails/dkim-${TOP_DOMAIN}.pub
fi

echo "### Done."