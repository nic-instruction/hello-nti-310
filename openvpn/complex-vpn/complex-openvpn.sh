#!/bin/bash
timedatectl set-timezone America/Los_Angeles
timedatectl
systemctl enable firewalld
yum update -y
yum install -y openvpn wget
wget -O /tmp/easyrsa https://github.com/OpenVPN/easy-rsa-old/archive/2.3.3.tar.gz
cd /
tar xfz /tmp/easyrsa
sudo mkdir /etc/openvpn/easy-rsa
sudo cp -rf easy-rsa-old-2.3.3/easy-rsa/2.0/* /etc/openvpn/easy-rsa
chown nicolebade /etc/openvpn/easy-rsa/
sudo cp /usr/share/doc/openvpn-2.4.8/sample/sample-config-files/server.conf /etc/openvpn
wget -O /etc/openvpn/server.conf https://github.com/nic-instruction/hello-nti-310/blob/master/openvpn/complex-vpn/server.conf
sudo openvpn --genkey --secret /etc/openvpn/myvpn.tlsauth
mkdir /etc/openvpn/easy-rsa/keys

yum install bind-utils
# nslookup your_ip 
# to get your DNS address put it in your vars file 
# vim /etc/openvpn/easy-rsa/vars
# set up your DNS name in CN  Update your Province, City, org and Keyname.
# Key name should be server
# These are the default values for fields
# which will be placed in the certificate.
# Don't leave any of these fields blank.
#export KEY_COUNTRY="US"
#export KEY_PROVINCE="NY"
#export KEY_CITY="New York"
#export KEY_ORG="DigitalOcean"
#export KEY_EMAIL="sammy@example.com"
#export KEY_EMAIL=sammy@example.com
#export KEY_CN=openvpn.example.com
#export KEY_NAME="server"
#export KEY_OU="Community"

cd /etc/openvpn/easy-rsa
source ./vars
./clean-all
./build-ca
./build-key-server server
./build-dh
cd /etc/openvpn/easy-rsa/keys
cp dh2048.pem ca.crt server.crt server.key /etc/openvpn
cd /etc/openvpn/easy-rsa
./build-key client
cp /etc/openvpn/easy-rsa/openssl-1.0.0.cnf /etc/openvpn/easy-rsa/openssl.cnf
firewall-cmd --get-active-zones
firewall-cmd --zone=trusted --add-service openvpn
firewall-cmd --zone=trusted --add-service openvpn --permanent
firewall-cmd --list-services --zone=trusted
firewall-cmd --add-masquerade
firewall-cmd --permanent --add-masquerade
firewall-cmd --query-masquerade
SHARK=$(ip route get 8.8.8.8 | awk 'NR==1 {print $(NF-2)}')
firewall-cmd --permanent --direct --passthrough ipv4 -t nat -A POSTROUTING -s 10.8.0.0/24 -o $SHARK -j MASQUERADE
firewall-cmd --reload
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
systemctl restart network.service
systemctl -f enable openvpn@server.service
systemctl start openvpn@server.service
systemctl status openvpn@server.service
mkdir /tmp/client
cp /etc/openvpn/easy-rsa/keys/ca.crt /tmp/client
cp /etc/openvpn/easy-rsa/keys/client.crt /tmp/client
cp /etc/openvpn/easy-rsa/keys/client.key /tmp/client
cp /etc/openvpn/myvpn.tlsauth /tmp/client
cd /tmp
tar cvf client.tar client/
