# CentOS 8(?) squid proxy configurations (not fun)

```
#create cert and key
openssl req -new -newkey rsa:2048 -sha256 -days 3072 -nodes -x509 -extensions v3_ca -keyout ~/squid-ca-key.pem -out ~/squid-ca-cert.pem
#combine cert and key
cat ~/squid-ca-cert.pem ~/squid-ca-key.pem | sudo tee -a squid-cert-key.pem
#make a cert directory to store the certs (squid.conf will point here)
sudo mkdir /etc/squid/certs
#move the certs and set ownership/permissions
sudo mv ~/squid-ca-cert.pem /etc/squid/certs
sudo mv ~/squid-ca-key.pem /etc/squid/certs
sudo mv ~/squid-ca-cert-key.pem /etc/squid/certs
sudo chown squid:squid /etc/squid/certs/*.pem
sudo chmod 400 /etc/squid/certs/*.pem
```

## Configure SSL Bump in squid.conf 

```
#... other configs you need in here
#start ssl-bump configs
#0.0.0.0 is needed for IPv4
https_port 0.0.0.0:3128 intercept ssl-bump \
	cert=/etc/squid/certs/squid-ca-cert-key.pem \
	generate-host-certificates=on \
	dynamic_cert_mem_cache_size=16MB

######## Other SSL Bump Configs ############
always_direct allow all

ssl_bump server-first all
sslcrtd_program /usr/lib64/squid/ssl_crtd -s /var/spool/squid/ssl_db -M 4MB
sslcrtd_children 5
```

## Once the squid-cert-key.pem cert is in the right directory AND squid.conf is correctly pointing to squid-ca-cert-key.pem, generate the db

```
sudo /usr/lib64/squid/ssl_crtd -c -s /var/spool/squid/ssl_db
```

## Lastly, fire up squid

```
sudo systemctl start squid
```

## Good reference:
#https://medium.com/@steensply/installing-and-configuring-squid-proxy-for-ssl-bumping-or-peek-n-splice-34afd3f69522
