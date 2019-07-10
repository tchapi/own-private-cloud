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

    docker-machine ssh default 'sudo fdisk /dev/sdb # n, p, w'
    docker-machine ssh default 'sudo mkfs.ext4 /dev/sdb1'
    docker-machine ssh default 'sudo mkdir /mnt/mysql && sudo mount /dev/sdb1 /mnt/mysql'

## Get environment variables to target the remote docker instace

    eval $(docker-machine env default)

## Set the dummy SSL certificates, then launch nginx and retrieve the real certificates

    ./scripts/certbot/init-letsencrypt.sh

## Provision the whole thing in daemon mode

> Some containers have already been started by the init-letsencrypt script

    docker-compose up -d

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