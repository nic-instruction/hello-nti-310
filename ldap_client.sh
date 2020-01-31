#!/bin/bash
# note, this is only part of the ldap client install script.  These are the relevent sed lines.

apt-get update
export DEBIAN_FRONTEND=noninteractive
apt -y install libnss-ldap libpam-ldap ldap-utils
unset DEBIAN_FRONTEND

sed -i 's/passwd:         compat systemd/passwd:         compat systemd ldap/g' /etc/nsswitch.conf
sed -i 's/group:          compat systemd/group:          compat systemd ldap/g' /etc/nsswitch.conf
sed -i 's/password        \[success=1 user_unknown=ignore default=die\]     pam_ldap.so use_authtok try_first_pass/password        \[success=1 user_unknown=ignore default=die\]     pam_ldap.so try_first_pass/g' /etc/pam.d/common-password
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sed -i 's/base dc=example,dc=net/base dc=nti310,cd=local/g' /etc/ldap.conf
sed -i 's,uri ldapi:///,uri ldap://ldap,g' /etc/ldap.conf
sed -i 's/rootbinddn cn=manager,dc=example,dc=net/rootbinddn cn=ldapadm,dc=nti310,dc=local/g' /etc/ldap.conf
sed -i 's/nss_base_group          ou=Group,dc=padl,dc=com\?one/nss_base_group          ou=Group,dc=nti310,dc=local/g' /etc/ldap.conf
sed -i 's/nss_base_passwd ou=People,dc=padl,dc=com\?one/nss_base_passwd ou=People,dc=nti310,dc=local/g' /etc/ldap.conf
sed -i 's/nss_base_shadow ou=People,dc=padl,dc=com\?one/nss_base_shadow ou=People,dc=nti310,dc=local/g' /etc/ldap.conf
