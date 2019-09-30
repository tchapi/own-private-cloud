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
$(< $1.template)
EOF
" 2> /dev/null 1> $1
}

echo "### Building configuration files"
# Create the reverse-proxy configurations
expandVars ./configurations/reverse-proxy/cloud.conf
expandVars ./configurations/reverse-proxy/nginx.conf

# Notes extensions
expandVars ./configurations/standardnotes/extensions/advanced-markdown-editor.json
expandVars ./configurations/standardnotes/extensions/autocomplete-tags.json
expandVars ./configurations/standardnotes/extensions/plus-editor.json
expandVars ./configurations/standardnotes/extensions/secure-spreadsheets.json
expandVars ./configurations/standardnotes/extensions/simple-task-editor.json

echo "### Done."