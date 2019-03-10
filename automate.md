# Automate using the gcloud sdk & bash

Download the google SDK or use the gcloud console.  https://cloud.google.com/sdk/

## Build your startup scripts
Seperate Postgres, Django, LDAP, NFS, Ryslog, ldap-client & nfs-client into seperate scripts.  Note: logsrv should be added to the 
end of every script.  You will spin up 2 NFS & LDAP clients and one of the other servers.  Logsrv should come up first,
followed by Postgres, LDAP and Django.  Your clients should be last.
You can put sleep commands in to give the servers time to configure between spinups.  Note:
your auotmation must run in under 20 minutes.

## Form your compute command
Here's an example of a gcloud compute command:

```
gcloud compute instances create django-a --metadata-from-file django=/django-server-auto.sh \
--image-family=centos-7 \
--tags "http-server","https-server" \
--zone us-east1-b
```

Note: the tags are very important, they grant https and http access to your instance.  Do not include them on things that do 
not need this access.
