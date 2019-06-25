docker-machine create -d openstack \
--openstack-flavor-name="s1-2" \
--openstack-region="GRA5" \
--openstack-image-name="Debian 9" \
--openstack-net-name="Ext-Net" \
--openstack-ssh-user="debian" \

--openstack-keypair-name="PRIMUS" \
--openstack-private-key-file="/Users/***REMOVED***/.ssh/id_rsa" \
test