atp-get update
apt -y install libnss-ldap libpam-ldap ldap-utils
sed -i 's/passwd:         compat systemd/passwd:         compat systemd ldap/g' /etc/nsswitch.conf
sed -i 's/group:          compat systemd/group:          compat systemd ldap/g' /etc/nsswitch.conf
sed -i 's/password        \[success=1 user_unknown=ignore default=die\]     pam_ldap.so use_authtok try_first_pass/password        \[success=1 user_unknown=ignore default=die\]     pam_ldap.so try_first_pass/g' /etc/pam.d/common-password
