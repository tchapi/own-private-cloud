#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $DIR/../../.env

DKIM_KEY=$(tail -n +2 configurations/mails/dkim-${TOP_DOMAIN}.pub | tail -r | tail -n +2 | tail -r  | tr -d '\n')

echo "### In order for your setup to work correctly, you need to add / modify DNS entries for the domain ${TOP_DOMAIN}."
echo "### "
echo "###  - Make sure that your MX entry is set with a high priority"
echo "###  - Add a SPF entry that includes your domain only"
echo "###  - Add a DKIM entry with your selector and key"
echo "###  - Add a DMARC entry with an actual email"

echo ""
echo "${TOP_DOMAIN}.                        MX  0   ${MAIL_DOMAIN}."
echo "${TOP_DOMAIN}.                        TXT     \"v=spf1 mx -all\""
echo "${DKIM_SELECTOR}._domainkey.${TOP_DOMAIN}.    TXT     \"v=DKIM1;k=rsa;p=${DKIM_KEY};\""
echo "_dmarc.${TOP_DOMAIN}.                 TXT     \"v=DMARC1;p=none;pct=100;rua=mailto:postmaster@${TOP_DOMAIN};\""
echo ""

echo "### Done."
