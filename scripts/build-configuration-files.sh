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

# Notes extensions
expandVars ./configurations/standardnotes/templates/advanced-markdown-editor.json.template ./configurations/standardnotes/extensions/advanced-markdown-editor.json
expandVars ./configurations/standardnotes/templates/autocomplete-tags.json.template ./configurations/standardnotes/extensions/autocomplete-tags.json
expandVars ./configurations/standardnotes/templates/plus-editor.json.template ./configurations/standardnotes/extensions/plus-editor.json
expandVars ./configurations/standardnotes/templates/secure-spreadsheets.json.template ./configurations/standardnotes/extensions/secure-spreadsheets.json
expandVars ./configurations/standardnotes/templates/simple-task-editor.json.template ./configurations/standardnotes/extensions/simple-task-editor.json

# XBS configuration
expandVars ./configurations/xbs/settings.json.template ./configurations/xbs/settings.json

# Syncthing configuration
# See https://docs.syncthing.net/dev/device-ids.html and https://github.com/syncthing/syncthing/issues/4217#issuecomment-309116907
# If the certificate and key have not been created yet, create them. They will persist locally, in case you need to rebuild the container
if [ ! -f ./configurations/syncthing/key.pem ]; then
  echo "### Generating Syncthing key, certificate and id"
  # Generate the private key
  openssl ecparam -genkey -name secp384r1 -noout -out ./configurations/syncthing/key.pem
  # Generate the self-signed certificate from the private key, setting the SN to 0, and the CN to syncthing
  openssl req -newkey rsa:2048 -new -nodes -x509 -set_serial 0 -sha1 -days 3650 -key ./configurations/syncthing/key.pem -out ./configurations/syncthing/cert.pem -subj /C=/ST=/L=/O=/OU=/CN=syncthing
fi
# Now, export the SYNC_ID env var, so that we can include it in the config file
SYNC_ID=$(openssl x509 -in ./configurations/syncthing/cert.pem -outform der \
  | openssl sha256 -binary \
  | python -c 'import base64; import sys; print(base64.b32encode(sys.stdin.read()))' \
  | tr -d =)
expandVars ./configurations/syncthing/config.xml.template ./configurations/syncthing/config.xml

# Mail configuration
expandVars ./configurations/mails/smtpd.conf.template ./configurations/mails/smtpd.conf
expandVars ./configurations/mails/dkim_signing.conf.template ./configurations/mails/dkim_signing.conf
expandVars ./configurations/mails/10-ssl.conf.template ./configurations/mails/10-ssl.conf

echo "### Done."