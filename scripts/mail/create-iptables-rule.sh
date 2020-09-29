#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $DIR/../../.env

echo "### Adding a postrouting rule from 172.100.0.0/16 (the mail_network) to ${MAIL_HOST_IP}"
echo " → \`iptables -t nat -I POSTROUTING -s 172.100.0.0/16 -j SNAT --to ${MAIL_HOST_IP}\` "
docker-machine ssh default "sudo iptables -t nat -I POSTROUTING -s 172.100.0.0/16 -j SNAT --to ${MAIL_HOST_IP}"
echo "### Done."
