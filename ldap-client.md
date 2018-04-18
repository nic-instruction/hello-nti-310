# Install LDAP Client on Ubuntu

```
 apt-get --yes install libpam-ldap nscd
 ```
 
   * change ldapi:/// to ldap:// and put in the private ip of your ldap server: ldap://10.142.0.9
   * dc=nti310,dc=local
   * version 3
   * Make local root datbase: No
   * Does LDAP need a login?  No
   
   ```
   vi /etc/nsswitch.conf
   
   change:
   
passwd:         compat
group:          compat
shadow:         compat

   to:

passwd:         compat ldap
group:          compat ldap
shadow:         compat ldap

   
   ```
restart nscd: `/etc/init.d/nscd restart`

* to test: `getent passwd` you'll see your ldap users and your local users in the output.
* enable password login for your user: `vi /etc/ssh/sshd_config` and change `PasswordAuthentication no` to `PasswordAuthentication yes`

* `/etc/init.d/ssh restart`
