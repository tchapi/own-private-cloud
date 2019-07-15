# Personal Infrastructure As A Service

Services :

  - Standard notes — A free, open-source, and completely encrypted notes app
  - Cozy Cloud (_Drive, photos and settings only_) — A smart personal cloud to gather all your data
  - Passbolt — A free, open-source, extensible, OpenPGP-based password manager
  - X-browser Sync — A free and open-source browser syncing tool
  - Baïkal — A GPLv3 Cal and CardDAV server, based on sabre/dav

> All services are served through an HTTPS proxy based on Nginx, certificates are provided by Let's Encrypt.

# Installation

## Source the env vars needed for OpenStack

    source openrc.sh

## Create the machine

    docker-machine create -d openstack \
    --openstack-flavor-name="s1-2" \
    --openstack-region="GRA5" \
    --openstack-image-name="Debian 9" \
    --openstack-net-name="Ext-Net" \
    --openstack-ssh-user="debian" \
    --openstack-keypair-name="PRIMUS" \
    --openstack-private-key-file="/Users/***REMOVED***/.ssh/id_rsa" \
    default

## Install necessary packages on the host (for passbolt - to generate entropy)

    docker-machine ssh default 'sudo apt update && sudo apt install -y -f haveged'

## Mount external attached block storage volume

> The volumes must be attached beforehand in the OpenStack console

#### The databases volume :

    docker-machine ssh default 'sudo fdisk /dev/sdb # n, p, w'
    docker-machine ssh default 'sudo mkfs.ext4 /dev/sdb1'
    docker-machine ssh default 'sudo mkdir /mnt/databases && sudo mount /dev/sdb1 /mnt/databases'
    docker-machine ssh default 'sudo mkdir /mnt/databases/mysql /mnt/databases/couch /mnt/databases/mongo'

#### The files volume :

    docker-machine ssh default 'sudo fdisk /dev/sdc # n, p, w'
    docker-machine ssh default 'sudo mkfs.ext4 /dev/sdc1'
    docker-machine ssh default 'sudo mkdir /mnt/files && sudo mount /dev/sdc1 /mnt/files'

## Get environment variables to target the remote docker instance

    eval $(docker-machine env default)

## Init all submodules to retrieve up to date code

    git submodule update --init

## Set the dummy SSL certificates, then launch nginx and retrieve the real certificates

    ./scripts/certbot/init-letsencrypt.sh

## Set the Cozy instance

    ./scripts/cozy/init-cozycloud.sh

## Provision the whole thing in daemon mode

> Some containers have already been started by the init-letsencrypt script

    docker-compose up -d

## Create the Passbolt admin user

    ./scripts/passbolt/init-admin-user.sh

## Init the Baikal instance if needed (_if the tables do not already exist_)

    ./scripts/baikal/init-mysql-tables.sh

# Tips

> If you change databases.sh, you need to clear the content of `/mnt/databases/mysql` on the host for the entrypoint script to be replayed entirely

# Literature

  - Docker best practices : https://blog.docker.com/2019/07/intro-guide-to-dockerfile-best-practices/
  - Nginx Reverse proxy : https://www.thepolyglotdeveloper.com/2017/03/nginx-reverse-proxy-containerized-docker-applications/
  - Lets Encrypt with Docker : https://devsidestory.com/lets-encrypt-with-docker/
  - Lets Encrypt with Docker (alt) : https://medium.com/@pentacent/nginx-and-lets-encrypt-with-docker-in-less-than-5-minutes-b4b8a60d3a71
  - Create and configure a block volume in OVH Public Cloud : https://docs.ovh.com/fr/public-cloud/creer-et-configurer-un-disque-supplementaire-sur-une-instance/
  - Shell command  / Entrypoint in Docker : https://stackoverflow.com/questions/41512237/how-to-execute-a-shell-command-before-the-entrypoint-via-the-dockerfile

## Dockerfiles :

  - Cozy : https://github.com/cozy/cozy-stack/blob/master/docs/INSTALL.md
  - Passbolt : https://hub.docker.com/r/passbolt/passbolt/
  - Standard Notes : https://github.com/arugifa/standardnotes-server-docker/blob/master/Dockerfile
  - MariaDB : https://github.com/docker-library/mariadb/blob/master/10.4/docker-entrypoint.sh
  - x-browser-sync : https://github.com/xbrowsersync/api-docker
