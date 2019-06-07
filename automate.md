# Automate using the gcloud sdk & bash

Download the google SDK or use the gcloud console.  https://cloud.google.com/sdk/

## Build your startup scripts
Seperate Postgres, Django, LDAP, NFS, Ryslog, ldap-client & nfs-client into seperate scripts.  Note: logsrv client should be added to the 
end of every script.  You will spin up 2 NFS & LDAP clients.  Logsrv should come up first,
followed by Postgres, LDAP and Django.  Your clients should be last.
You can put sleep commands in to give the servers time to configure between spinups.  Note:
your auotmation must run in under 20 minutes.

## Form your compute command
Here's an example of a gcloud compute command:

```
gcloud compute instances create rsyslog-server2 \
--image-family centos-7 \
--image-project centos-cloud \
--zone us-east1-b \
--tags "http-server","https-server" \
--machine-type f1-micro \
--scopes cloud-platform \
--metadata-from-file startup-script=/path/to/script.sh \
--private-network-ip=10.128.0.5
```

   * Note: the tags are very important, they grant https and http access to your instance.  Do not include them on things that do 
not need this access.  
   * Note that your image family will be ubuntu-1804-lts and your image-project will be ubuntu-os-cloud for your client. 
   
   * Also, very important: test the heck out of your startup scripts.  Durring the final I can't help you troubleshoot, you are on your own, so make sure your scripts are working perfectly before the final, bearing in mind that things can still go wrong.
