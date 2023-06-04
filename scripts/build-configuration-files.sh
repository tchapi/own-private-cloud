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

# Cryptpad configuration
expandVars ./configurations/cryptpad/config.js.template ./configurations/cryptpad/config.js

# Mail configuration
expandVars ./configurations/mails/config/rspamd/override.d/dkim_signing.conf.template ./configurations/mails/config/rspamd/override.d/dkim_signing.conf
expandVars ./configurations/mails/config/postfix-virtual.cf.template ./configurations/mails/config/postfix-virtual.cf
expandVars ./configurations/mails/config/user-patches.sh.template ./configurations/mails/config/user-patches.sh

# Create 1024 DKIM key
if [ ! -f ./configurations/mails/config/rspamd/dkim/rsa-1024-${DKIM_SELECTOR}-${TOP_DOMAIN}.private.txt ]; then
  echo "### Generating DKIM keys"
  openssl genrsa -out ./configurations/mails/config/rspamd/dkim/rsa-1024-${DKIM_SELECTOR}-${TOP_DOMAIN}.private.txt 1024
fi

openssl rsa -in ./configurations/mails/config/rspamd/dkim/rsa-1024-${DKIM_SELECTOR}-${TOP_DOMAIN}.private.txt -pubout -out /tmp/rsa-1024-${DKIM_SELECTOR}-${TOP_DOMAIN}.public.txt
DKIM_KEY=$(tail -n +2 /tmp/rsa-1024-${DKIM_SELECTOR}-${TOP_DOMAIN}.public.txt | tail -r | tail -n +2 | tail -r  | tr -d '\n')
echo "v=DKIM1; k=rsa; p=${DKIM_KEY}" > ./configurations/mails/config/rspamd/dkim/rsa-1024-${DKIM_SELECTOR}-${TOP_DOMAIN}.public.dns.txt
echo -e "${DKIM_SELECTOR}._domainkey IN TXT ( \"v=DKIM1; k=rsa; \"\n	\"p=${DKIM_KEY}\" ) ;" > ./configurations/mails/config/rspamd/dkim/rsa-1024-${DKIM_SELECTOR}-${TOP_DOMAIN}.public.txt

echo "### Done."