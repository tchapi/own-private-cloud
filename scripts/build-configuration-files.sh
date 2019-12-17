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
expandVars ./configurations/syncthing/config.xml.template ./configurations/syncthing/config.xml

echo "### Done."