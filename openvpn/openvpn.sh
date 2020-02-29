#!/bin/bash
# based on the tutorial here https://openvpn.net/community-resources/static-key-mini-howto/
# with firewall rules from here: https://www.digitalocean.com/community/tutorials/how-to-set-up-and-configure-an-openvpn-server-on-centos-7

# install openvpn
yum -y install openvpn

# set up the static key
# you will need to download this to your client, but the cloud won't let you do it with the perms it has
# so make a copy, chmod the copy to 666 and then download that and rename it to static.key when it lands
# on your machine
openvpn --genkey --secret static.key

# grab the server config from my github (notice we grab the raw file)
wget -O /etc/openvpn https://raw.githubusercontent.com/nic-instruction/hello-nti-310/master/openvpn/server.conf

# configure ip forwarding on the machine, note we needed to do this in the server config when we spun it up too
# then restart network services
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
systemctl restart network.service

# configure the firewall to nat, masquerade, and open port 1194
firewall-cmd --zone=trusted --add-service openvpn
firewall-cmd --zone=trusted --add-service openvpn --permanent
firewall-cmd --list-services --zone=trusted
firewall-cmd --add-masquerade
firewall-cmd --permanent --add-masquerade
firewall-cmd --query-masquerade
SHARK=$(ip route get 8.8.8.8 | awk 'NR==1 {print $(NF-2)}')
firewall-cmd --permanent --direct --passthrough ipv4 -t nat -A POSTROUTING -s 10.8.0.0/24 -o $SHARK -j MASQUERADE
firewall-cmd --reload

# start the openvpn server
systemctl start openvpn@server

# at this point we have to open tcp and udp to port 1194 on google cloud firewall
# then download the client from here: https://raw.githubusercontent.com/nic-instruction/hello-nti-310/master/openvpn/client.ovpn
# and configure with your server's static ip
