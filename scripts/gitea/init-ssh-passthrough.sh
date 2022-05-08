#!/bin/bash

# /!\ THIS SCRIPT MUST BE RUN ON THE DOCKER Host

GITEA_GIT_USER_GROUP_ID=2022
GITEA_GIT_USER_ID=2022

echo "### Creating host git group and user"
sudo groupadd --gid ${GITEA_GIT_USER_GROUP_ID} git
sudo useradd --uid ${GITEA_GIT_USER_ID} --gid ${GITEA_GIT_USER_GROUP_ID} -m git

echo "### Creating the host ⇔ container key pair"
sudo -u git ssh-keygen -t rsa -b 4096 -f "/home/git/.ssh/id_rsa" -C "Gitea Host Key" -q -N ""

echo "### Adding key to authorized_keys"
sudo -u git cat /home/git/.ssh/id_rsa.pub | sudo -u git tee -a /home/git/.ssh/authorized_keys
sudo -u git chmod 600 /home/git/.ssh/authorized_keys

echo "### Creating binary on the host"
cat <<"EOF" | sudo tee /usr/local/bin/gitea
#!/bin/sh
ssh -p 2222 -o StrictHostKeyChecking=no git@127.0.0.1 "SSH_ORIGINAL_COMMAND=\"$SSH_ORIGINAL_COMMAND\" $0 $@"
EOF
sudo chmod +x /usr/local/bin/gitea