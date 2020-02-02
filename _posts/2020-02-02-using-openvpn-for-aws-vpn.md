---
title: Using OpenVPN to create a simple VPN for AWS with SSL/Let's Encrypt
layout: post
tags: aws
---

I continue to find a need for a simple and inexpensive VPN solution for Amazon Web Services.  The VPN solutions AWS provides feel like extended pricing overkill for what I am typically looking for.  I also want to add SSL for the HTTPS side of the configuration via [Let's Encrypt](https://letsencrypt.org/).

## Pick 2

In the Good, Fast, Cheap triangle I am working towards Fast and Cheap here.

## Goals

Overall I want to connect to my AWS VPC via VPN, access resources and then disconnect.  I do not have a goal beyond that.

## Process

Here is the walk through I use to stand up an OpenVPN server in an AWS account and use [Let's Encrypt](https://letsencrypt.org/) to provide the SSL certificate.

### Create the Instance

First, in my AWS account I locate OpenVPN image in the AWS marketplace:
![aws marketplace for openvpn](/images/openvpn-marketplace.png)

I then launch this AMI as a **t3.nano** with a public IP (*we will switch to elastic here in a bit*).  I also use their generated security group, **BUT, I add port 80** due to the Let's Encrypt challenge process.

![aws marketplace for openvpn](/images/openvpn-security-group.png)

### Elastic IP and DNS (Route53)

I turn my VPN up and down with the AWS CLI when I need it.  Because of this I prefer to have the instance on an Elastic IP.  Thus, I associate an Elastic IP to the instance.  Then I add the correct DNS names via Route53.

### Login and Configuration

After the instance is up I ssh into the system.

```zsh
DOMAIN=[your_domain]
EMAIL=[your_email]
ssh -i key.pem openvpnas@$DOMAIN
```

On the initial login you'll be presented with the welcome and you'll be walked through the init screen.
![openvpn service agreement](/images/openvpn-agreement-terminal.png)

Please enter 'yes' to indicate your agreement [no]: **yes**
Will this be the primary Access Server node? **yes**
Please specify the network interface and IP address to be used by the Admin Web UI: **1 - all interfaces**
Please specify the port number for the Admin Web UI.  **943**
Please specify the TCP port number for the OpenVPN Daemon  **443**
Should client traffic be routed by default through the VPN?  **no**
Should client DNS traffic be routed by default through the VPN? **yes**
Use local authentication via internal DB? **yes**
Private subnets detected: **XXX.XXX.XXX.XXX/16** (*default*)
Should private subnets be accessible to clients by default? **yes**
Do you wish to login to the Admin UI as "openvpn"? **yes**
Please specify your OpenVPN-AS license key (or leave blank to specify later): **blank**

Next, set your admin password (how you will login to the web app portion of the setup):
```zsh
sudo passwd openvpn
```

### Let's Encrypt - SSL

```zsh
sudo apt-get -y install software-properties-common
sudo add-apt-repository -y ppa:certbot/certbot
sudo apt-get -y update
sudo apt-get -y install certbot
sudo service openvpnas stop
sudo certbot certonly \
  --standalone \
  --non-interactive \
  --agree-tos \
  --email $EMAIL \
  --domains $DOMAIN \
  --pre-hook 'sudo service openvpnas stop' \
  --post-hook 'sudo service openvpnas start'
```

Assuming that process worked we need to load this into OpenVPN
```zsh
sudo ln -s -f /etc/letsencrypt/live/$DOMAIN/cert.pem /usr/local/openvpn_as/etc/web-ssl/server.crt
sudo ln -s -f /etc/letsencrypt/live/$DOMAIN/privkey.pem /usr/local/openvpn_as/etc/web-ssl/server.key
sudo service openvpnas start
```

Next, the site will pull up with a correct HTTPS SSL connection via the domain you used above and port 943.

```
https://DOMAIN:943/admin
```

*Note: in my experience this takes a few seconds to start working correctly, unclear why specifically*


### Cleanup

Inside of the admin area I do a few things:
+ Change the hostname from the IP to the domain name 
+ Add a user for myself

## Done!

Next, I install the OpenVPN client on my machine(s) and connect!